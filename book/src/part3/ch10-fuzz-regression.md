# 第 10 章：Fuzz、最小化与永久回归

> **定位**：本章接续[第 9 章 Differential Run Record](ch09-differential-testing.md#可复用工件)，把一次未知输入导致的失败转成可解释、可长期运行的项目资产。前置条件是差异已能稳定采集但尚未必被裁决；输出是 Discover–Minimize–Codify–Repair–Verify 五阶段账本和 Fuzz Failure Package。适用于设计 fuzz target、处理不稳定 seed、评审回归质量和管理语料库的读者。

## 问题现场：bug 修了，六周后同一语义又回来

虚构的 `manifest-copy` fuzz target 发现：路径含尾随空格时，候选 stdout 少一条 NUL 记录。Agent 查看巨大输入后修改了字符串处理，原 seed 重放不再失败，团队把 issue 关闭。seed 只保存在 CI 临时目录；提交里没有具名回归，修复理由写成“handle fuzz edge case”。

六周后，另一个重构把路径再次转成文本并调用 `trim()`。普通测试全绿，旧 CI artifact 已过期，原 fuzz campaign 也没有命中相同随机组合。事故以不同文件名再次出现。第一次修复没有成为项目知识：没有最小输入，没有明确契约，没有修复前失败证据，也没有一个每次提交都会运行的永久测试。

另一个团队走向相反极端：把完整 80 MB corpus 全部放进普通 CI，希望“永远不回归”。CI 变慢，样本名全是哈希，审稿者无法说明每个样本保护什么；为了恢复速度，后来的人批量删除“重复 seed”，恰好删掉唯一能触发权限与断链组合的状态。保存字节不等于保存知识。

论文将传统 fuzz、差分测试、grammar-guided 输入、LibFuzzer 覆盖引导和失败缩减放在同一兼容工程语境中 [E1-DIFF-FUZZ]。固定提交中，uufuzz 比较器能把 stdout、可选 stderr 与退出码差异暴露为失败 [E2-UUFUZZ-COMPARE]；仓库贡献流程要求兼容问题先从小测试理解，再向 Rust 测试库加入防回归用例 [E2-COMPAT-WORKFLOW]，`AGENTS.md` 更直接要求行为变化或 bug fix 带测试、外部测试转绿后加入 Rust 测试。[E2-NO-TEST-NO-MERGE] 这些事实共同说明：fuzz 的价值不止在“找到”，还在“固化”。

<!-- source: fuzz/Cargo.toml -->
<!-- source: fuzz/uufuzz/src/lib.rs -->
<!-- source: fuzz/fuzz_targets/fuzz_echo.rs -->
<!-- source: fuzz/fuzz_targets/fuzz_date.rs -->
<!-- source: fuzz/fuzz_targets/fuzz_sort.rs -->
<!-- source: CONTRIBUTING.md -->
<!-- source: AGENTS.md -->

## 心智模型：四类验证，不要用一个“fuzz”词包办

**崩溃 fuzz（crash fuzz）**把 panic、非法内存访问、abort、超时或资源异常当作 oracle。它不需要参考实现，适合解析器和内存/资源安全边界；但正常退出且语义错误通常不会被发现。

**差分 fuzz（differential fuzz）**让同一样本驱动两个实现，再比较契约观察。它能发现“都没崩但行为不同”，同时继承参考实现和比较器的缺陷。第 9 章规定了 oracle 冲突与归一化纪律，本章不重复定义。

**性质测试（property testing）**不问具体黄金输出，而检查不变量，例如“成功记录的路径集合等于已提交文件集合”“重复编码解码保持原生路径身份”“失败不留下本次临时文件”。性质适合没有权威参考或输出空间过大的场景，但性质写错时会系统性接受坏行为。

**永久回归（regression test）**是由一个已裁决反例导出的、具名、最小、确定、常规运行的契约守卫。它通常不再依赖大规模随机搜索，也不应依赖外部参考程序；期望值已由契约与人类裁决固定。corpus seed 可帮助再次探索，永久回归负责防止已知语义消失。

这四类可以组合，却不可互相冒充。一个 target 只调用候选并观察崩溃，不能因为用了 `cargo-fuzz` 就称为差分；一个差分 target 也不自动拥有 grammar；一个 corpus 文件不会因被提交而自然成为可解释回归；属性全绿不证明具体 stdout/退出码契约。

本章采用五阶段闭环，明确标为 **E4-DISCOVER-LOOP 作者提炼**：

```mermaid
flowchart LR
    D["Discover<br/>保存原始输入、环境和症状"] --> M["Minimize<br/>命令/状态/环境/观察"]
    M --> C["Codify<br/>裁决+具名永久回归"]
    C --> R["Repair<br/>最小行为修复"]
    R --> V["Verify<br/>red/green+宽回归+邻域"]
    V -->|新反例| D
    V -->|闭合| A["Failure Asset<br/>回归+seed+证据"]
```

闭环的顺序不可随意交换。先修复再最小化，会失去稳定失败基线；先把巨大 seed 固化，会把无关偶然性写进测试；修复后只跑原 seed，不知道转写回归是否真正捕获缺陷，也不知道修复是否破坏相邻输入。

## 固定提交走查：库、target 与回归规则分层核验

固定源码基线 `d8bee62c1ddc227d5e4385d80bbf6d7dee266a41` 中，`fuzz/Cargo.toml:11-16` 将 fuzz crate 标为 `cargo-fuzz` 并隔离为自己的 workspace，`28-46` 声明 `libfuzzer-sys`、`rand`、`uufuzz` 与若干 utility crate，`48-160` 注册多个独立 fuzz binary。它证明仓库有多个 target 入口，不证明所有 target 共享同一种生成或 oracle。

具体 target 展示了能力差异。`fuzz_date.rs:14-20` 把 LibFuzzer 的 `&[u8]` 按 NUL 拆为 UTF-8 argv；`22-41` 跳过可能读取 stdin 而挂住 fuzzer 的组合；`43-47` 只调用候选 `uumain`。这更接近候选鲁棒性/崩溃搜索，不是该文件中的双实现差分。

`fuzz_echo.rs:20-59` 不使用 LibFuzzer 提供的 `_data` 构造参数，而是由 target 自己随机选择 `-n/-e/-E` 和转义片段；`62-89` 分别执行候选与参考并调用比较器，stderr 差异设置为失败。`fuzz_sort.rs:19-47` 自己生成若干选项和十行输入；`49-84` 做双路比较，但把 `fail_on_stderr_diff` 设为 `false`。[E2-UUFUZZ-COMPARE] 生成策略和 stderr 政策都在 target 层，不在 uufuzz 库自动决定。

uufuzz 库的随机辅助也有具体边界。`fuzz/uufuzz/src/lib.rs:325-347` 生成一个 `String`，字符池含 ASCII、emoji 和由两个字节值转成的 Unicode scalar；它没有生成不可构造的 Rust `String` 非 UTF-8 字节。`350-367` 创建随机临时文件并写 printable ASCII。项目另有 `fuzz_non_utf8_paths.rs` 在 Unix 用 `OsStringExt/OsStrExt` 构造原生路径，这再次说明“路径字节能力”来自具体 target，而非通用字符串生成器。

因此，本章在谈“语法感知、文件树状态、权限、并发与缩减器”时均把它们标为目标设计或 E4 扩展，不宣称基线 target 全部已有。固定源码能证明若干实例，不足以证明覆盖质量、运行时长、corpus 大小或所有 utility 的 fuzz 状态。

永久回归的规则来自项目文档而不是 fuzz 库。`CONTRIBUTING.md:302-330` 的兼容改进流程要求从较小测试开始、理解外部失败、修改 Rust 实现并加入防回归测试；`AGENTS.md:17-23` 把“行为/bug fix 要有测试”与“外部失败转绿要加 Rust 测试”写成合并要求。[E2-COMPAT-WORKFLOW] [E2-NO-TEST-NO-MERGE] 这些规则没有规定本书的 YAML、五阶段命名或 corpus 策略；后者都是 E4 工程化。

### 证据分层表

| 层 | 基线事实 | 不能外推 |
|---|---|---|
| uufuzz library | 执行/比较和随机字符串/文件辅助 | 每 target 语法、状态、缩减、seed、覆盖 |
| `fuzz_date` | NUL 拆 argv、过滤 stdin 组合、运行候选 | 双路差分、文件系统 oracle、所有 date 语法 |
| `fuzz_echo` | 自生成若干选项/转义并做差分 | 使用 LibFuzzer bytes 的覆盖质量、完整 echo grammar |
| `fuzz_sort` | 自生成选项/行，stderr 差异不致命 | stderr 永远非契约、排序 locale 全覆盖 |
| 仓库规则 | 已知行为修复要有 Rust 防回归测试 | fuzz corpus 自动等价于永久测试 |

## 输入生成、种子和覆盖：让预算抵达深层状态

纯随机字节擅长冲击解码器、长度边界和 parser 拒绝路径，却可能长期停在“无效选项”。语法感知生成器把 argv 建模成 flag、带值选项、互斥组、重复规则和操作数，让更多样本进入业务语义。状态感知生成器进一步创建与操作数一致的文件树、权限、链接、已有目标和资源限制。两者不是越复杂越好；生成器必须能序列化为稳定 seed，且每条约束都可由负控检验。

对 CLI，可以把生成分为四层：

1. **token 层**：空参数、前导短横线、超长 token、原生路径字节、NUL 不可表示边界；
2. **grammar 层**：选项值、重复、冲突、`--` 分隔、stdin/操作数优先级；
3. **state 层**：文件/目录/链接/断链、权限、已存在目标、部分文件和特殊节点；
4. **environment 层**：locale、时区、umask、uid、文件系统、资源上限、并发与信号。

覆盖账本不只写执行次数。至少记录命中哪些 option/组合、终止类别、文件树形状、平台能力、比较字段和差异类别。覆盖反馈也不能取代风险采样：覆盖引导可能倾向复杂 parser，却忽略“目标已存在且写到一半失败”的低覆盖高后果场景。历史事故与契约风险应获得固定预算，剩余预算再用于全局探索。

seed 必须携带生成器版本、随机种子、样本序列化、runner 镜像和环境摘要。只保存一个内存结构的 debug 文本，未来生成器升版后可能无法还原。每次 schema 升级要有迁移器或保留旧 replay；不可迁移的 seed 明示归档，不能静默丢弃。

## 最小化：对命令、状态、环境和观察分层做 delta debugging

状态化 CLI 的最小化不是对一串字节反复二分。一个复合失败可以同时包含 argv、stdin、目录树、权限、环境和非确定时序；若只删字节，会得到“更短但不能重现”的样本。

**第一层，稳定症状签名。** 先定义要保留的失败：特定 panic 指纹、退出码差异、stdout 记录缺失、文件类型变化或 timeout。不要用完整日志哈希，因为随机路径和时间会让同一根因看似不同；也不要只用“任意不等”，否则缩减可能从数据损坏跳到无关 stderr 差异。

**第二层，命令缩减。** 删除选项、操作数和 stdin 区段，缩短 token，同时保证语法仍到达同一状态。每次尝试都从新沙箱重放，保存尝试图，避免局部最小值被误当成唯一最小值。

**第三层，文件树缩减。** 删除无关节点、缩短路径和内容、简化链接深度、权限与已有目标。对非 UTF-8 路径必须以字节/原生表示操作，不能先转 String。对文件系统副作用，症状签名同时包含 before/after 关键字段。

**第四层，环境缩减。** 移除不相关 env，逐项恢复默认 locale、时区、umask、资源限制和用户。环境一旦被证明必要，就进入最小 fixture，而不是藏在开发机配置中。

**第五层，稳定性审计。** 普通确定性失败连续重放 N 次应得到同一症状。竞态/timeout 要报告复现率和置信范围，尝试加入 barrier、虚拟时钟或故障注入；无法稳定化的样本进入 quarantine，不得伪造一个确定性期望。

最小化前后的工件都要保留。原始样本能证明发现背景和辅助检查多因素；最小样本用于回归与解释。若缩减器存在 bug，二者之间的 lineage 让团队能够回滚到原件。

## 完整工程案例

案例延续第 9 章 `DRR-MANIFEST-007`。复合 seed 含两个普通文件、一个尾随空格名、一个 `\xFF` 名、一个断链和七个选项。观察到 stdout 少记录且断链被错误复制。人类已把两项分类为候选缺陷，允许进入本章闭环。

**Discover。** 接收系统保存原始 seed、生成器 `manifest-grammar/v5`、候选 commit、参考 artifact、两个沙箱快照、所有输出、比较器版本和差异签名。`DIFF-OUT-01` 的签名是“成功退出但 committed 多重集合不等于 stdout 多重集合”；`DIFF-FS-02` 是“断链 after type 不同”。安全扫描确认样本无用户数据。

**Minimize。** 两个差异拆开处理。对 `DIFF-OUT-01`，删除断链和普通文件，删到单个 `x<space>` 名；选项从七个删到一个必要输出选项；locale 与时区被证明无关。对 `DIFF-FS-02`，只保留一个断链和目标不存在初态。每次重放使用新沙箱，连续 20 次稳定。复合原件仍保留并指向两个最小 seed。

**Codify。** 契约负责人批准 `REG-MANIFEST-TRAILING-SPACE-001` 与 `REG-MANIFEST-DANGLING-LINK-002`。第一个测试以原始路径字节和 NUL 记录断言，不调用 `trim()`；第二个检查 exit、stderr 类别、目标节点类型和残留临时文件。测试名说明行为，不叫 `fuzz_case_4819`。在修复前 commit 上，两项都失败；red receipt 包含选择器、runner、退出状态和日志哈希。

**Repair。** Agent 的 Task Contract 只允许修改目标 utility 和两个回归。第一项修复去掉提交记录路径上的文本裁剪；第二项修复在复制前保留链接分类。Agent 发现可抽共享 helper，但停止并提出后续任务，没有扩大当前 diff。人类逐项解释路径原生表示和失败清理。

**Verify。** 同一测试在候选上转绿，原始复合 seed 重放相等；运行相关 utility 进程测试，并在两个最小 seed 的邻域生成尾随空格长度、不同原生字节和链接深度变体。目标结论只覆盖 Linux 本地文件系统；网络 FS、Windows 路径和并发树保持 Unverified。两个最小 seed进入版本库回归，复合 seed进入 corpus，谱系写入 Failure Package。

六个月后，如果同类差异再次出现，维护者可从回归 ID 追到契约、原始发现、red/green、修复 commit 和相邻生成策略。这个链路才是“失败资产化”，而不是把聊天或 CI 链接当永久记忆。

## 反例

**反例一：修代码但不固化。** 原 seed 在当前 campaign 中不再失败，不能保证未来 campaign 会再次采到。没有具名回归，已知行为仍依赖概率。处理：在修复前先得到 red，修复后 green，并把最小用例放入常规测试选择器。

**反例二：把 corpus 全部变成测试。** 大量互相相关且不可解释的 seed 会拖慢 CI并掩盖契约。处理：最小具名回归进主测试库；代表性/覆盖 seed 进受管理 corpus；原始大工件进可寻址存储。三者有 lineage，但承担不同职责。

**反例三：不稳定失败硬写期望。** 竞态 100 次出现 3 次，却把一次输出写成黄金文件。未来测试既 flaky 又可能锁定偶然调度。处理：先 quarantine，记录复现率，寻找 barrier 或专用并发夹具；稳定前可作为调查资产，不能写成确定性 Pass。

**反例四：让生成器避开所有难样本。** `fuzz_date` 基线跳过 stdin 组合是为避免挂起的具体 target 决策，不意味着 stdin 行为无风险。生产设计应增加可控输入/timeout harness 或把缺口记入账本，不能将 skip 计为覆盖。

## 模式提炼

**模式一：发现—最小化—固化—修复—复验。** 问题是一次失败会随 artifact 过期；机制是按顺序产生可寻址工件。前提是样本可重放且契约有人裁决；失效边界是不稳定竞态或不可复制环境。替代方案是 quarantine、专用 runner 与生产记录重放。

**模式二：双资产保留。** 问题是巨大 seed 难审、最小 seed 丢上下文；机制是同时保存原始发现和最小回归，以 lineage 连接。前提是有存储与保留策略；失效边界是敏感数据。替代方案是受限原件、脱敏最小用例和内容哈希索引。

**模式三：回归先红后绿。** 问题是与修复同时加入的测试可能从未捕获缺陷；机制是在修复前基线运行并保存失败回执。前提是旧候选可构建；若不可构建，使用隔离 mutation 负控或可复现旧 artifact，并明确证据较弱。

**模式四：历史反例回流生成器。** 问题是回归只守一个点；机制是将最小 seed 及其结构标签加入邻域变异。前提是生成器能表达该状态；失效边界是危险副作用或昂贵环境。替代方案是离线 campaign 或更小发布流量。

## 可复用工件

下面的 **Fuzz Failure Package** 是 E4 schema，不是仓库现行格式。它把发现、缩减、裁决、回归、修复和复验串为一个对象，并让不稳定状态保持可见。

```yaml
schema: fuzz-failure-package/v1
failure_id: FFP-MANIFEST-001
discovered_by:
  target: manifest_differential
  target_commit: abcdef0
  engine: libfuzzer
  generator: manifest-grammar/v5
  seed: 0x7c5a21
  run_id: FUZZ-RUN-2026-0814-09
raw_artifact:
  id: RAW-MANIFEST-001
  sha256: rawhash
  access: project-confidential
  environment: runner-linux-ext4-v3
symptom:
  signature: committed_multiset_missing_record
  first_differential_record: DRR-MANIFEST-007
  stability: {replays: 20, reproduced: 20}
classification:
  state: candidate_defect
  contract: BC-MANIFEST-007@v4
  owner: compatibility-owner
minimization:
  reducer: cli-tree-dd/v2
  lineage: [RAW-MANIFEST-001, MIN-MANIFEST-001]
  minimal_argv_hex: [6d616e69666573742d636f7079, "7820"]
  minimal_tree: fixture:trailing-space-one-file
  removed_environment: [TZ, locale_variants]
regression:
  id: REG-MANIFEST-TRAILING-SPACE-001
  locator: tests/by-util/example-only
  pre_fix_receipt: RUN-REG-001-RED
  expected_observables: [stdout_bytes, exit_code, filesystem_snapshot]
repair:
  commit: candidate-fix-hash
  scope: local_behavior
  rollback: revert_single_commit
verification:
  post_fix_receipt: RUN-REG-001-GREEN
  original_seed_replay: pass
  neighborhood_campaign: FUZZ-RUN-2026-0814-10
  wider_regression: pass
residual_unknowns: [windows_native_path, network_fs, concurrent_tree]
corpus_disposition:
  minimal: versioned_regression_and_seed
  raw: restricted_object_store
  retention: 2y_then_review
```

状态机至少包含 `Discovered`、`Reproducible`、`Minimized`、`Classified`、`CodifiedRed`、`Repaired`、`Verified`、`Quarantined` 和 `Closed`。`Quarantined` 不是失败垃圾桶；必须有负责人、下一实验和到期时间。只有 regression red、修复 green、原 seed 复验和残余未知都入账，才能从 `Repaired` 到 `Verified`。

## AI Coding 工作台

给 Agent 的上下文由最小契约、原始/最小 seed、症状签名、允许路径、runner 命令和停止条件组成。Agent 可建议分层缩减、生成重复运行脚本、把最小样本转写为测试、实现已裁决修复并整理证据；它不能自行把失败标成候选 bug、删除不稳定样本、扩大 skip，或用修复后的实现定义期望。

任务提示应把阶段写清：“当前只做 Minimize，不修改候选”；“当前只做 Codify，测试必须在基线失败”；“当前 Repair，不修改 target 与 comparator”；“当前 Verify，不调整期望”。把四项混在一个会话中会制造自证闭环：同一个 Agent可以同时改实现、测试、生成器和判定尺子，让任何结果看起来绿色。

工作台还要显示语料库成本：每个 seed 的大小、执行时间、独特覆盖/契约标签、敏感性、最后命中和保留理由。自动去重只提供候选集合，人类在删除永久资产前要确认语义保护没有丢失。对安全敏感样本，Agent 的可见范围服从第 4 章 Context Manifest，公开回归可以只表达防御不变量。

## 能证明什么／不能证明什么

| 能证明什么 | 不能证明什么 |
|---|---|
| 固定提交存在多 target、LibFuzzer 入口和不同生成/比较形状。[E2-UUFUZZ-COMPARE] | 所有 target 都是差分、都语法感知、覆盖充分或持续运行。 |
| 项目规则要求已知行为修复进入 Rust 测试库。[E2-COMPAT-WORKFLOW] [E2-NO-TEST-NO-MERGE] | 任意 corpus 文件已经是稳定、具名、契约正确的回归。 |
| 最小回归的 red/green 回执可证明指定提交、runner 与期望下由失败转为通过。 | 根因唯一、所有相邻输入正确或其他平台无同类缺陷。 |
| 连续重放可测量该环境中的稳定性，quarantine 可诚实表达未知。 | 低复现率就是无风险，或用更多重试能修复竞态。 |
| 邻域 campaign 可证明已探索声明的变体和预算。 | 状态空间穷尽、并发/权限/真实文件系统得到生产保真覆盖。 |

## 局限

Fuzz 只能探索生成器可达、harness 可观察、oracle 可判断且预算允许的空间。真实权限、内核竞态、资源枯竭、特殊文件系统和跨机器时序常需专用环境。覆盖反馈描述代码路径，不直接描述行为契约；高覆盖仍可能错过一次危险状态转移。

最小化会改变问题。多因素缺陷可能被拆成一个症状，导致团队误以为根因单一；原始样本因此不能立即删除。语料库还可能携带客户路径、内容或漏洞细节，必须分级存储。最后，fuzz 发现的数量不是团队质量 KPI：更多发现可能表示搜索更好，不是实现更差；为了降低数字而缩小生成空间会伤害系统。

## 实践清单

- [ ] 明确 target 属于崩溃、差分、性质或组合，不用“fuzz”掩盖 oracle。
- [ ] 区分 uufuzz 库与每个 target 的输入、跳过、环境和比较策略。
- [ ] 保存原始 seed、生成器/runner 版本、症状签名与环境。
- [ ] 按命令、文件树、环境和观察分层最小化，每步新沙箱重放。
- [ ] 最小永久回归在修复前失败、修复后通过，名称表达契约。
- [ ] 原始样本、最小回归与探索 corpus 分层保存并连接 lineage。
- [ ] 不稳定失败进入有负责人的 quarantine，不伪装确定性。
- [ ] 把最小反例回流生成器邻域，并报告未覆盖状态空间。

## 练习

- **练习一：设计验证。** 为一个带 stdin 和文件树的命令分别设计 crash、differential 与 property target，写出三种 oracle、timeout、危险状态隔离和能够证明 target 会失败的负控。
- **练习二：做一次四层缩减。** 从“八个选项、十个文件、两个 locale、一次退出码差异”的复合样本出发，列出命令、树、环境、观察的删除顺序；每一步写稳定症状签名和回滚到原件的条件。
- **练习三：构造永久资产。** 写一份 Fuzz Failure Package，要求包含 raw/min lineage、20 次稳定性、具名回归、red/green、邻域 campaign、未验证平台和 retention；再说明删除任一字段会让哪个审查问题无法回答。

## 本章证据

fuzz、差分、grammar 和缩减的项目研究背景来自 [E1-DIFF-FUZZ]；基线比较器与 target 差异来自 [E2-UUFUZZ-COMPARE]；从外部兼容失败到 Rust 回归的步骤来自 [E2-COMPAT-WORKFLOW]；测试随行为修复进入合并门禁来自 [E2-NO-TEST-NO-MERGE]。五阶段循环、Failure Package、quarantine 与语料分层均是 E4-DISCOVER-LOOP 作者综合，不是仓库现行 schema。

### 版本演化说明

论文基线为 **arXiv:2608.07135**；源码事实固定在 **d8bee62c1ddc227d5e4385d80bbf6d7dee266a41**，本章核验截止日为 **2026-08-14**。target、生成器、corpus 与比较器会快速演化；复用本章时必须逐文件核验“是否差分、如何生成、跳过什么、比较什么”，永久回归则负责让过去裁决过的行为跨版本继续可见。
