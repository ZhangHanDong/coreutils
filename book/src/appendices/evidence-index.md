# 附录 F：证据索引、术语表与参考资料

本附录列出正文使用的稳定证据 ID。网页链接指向一手资料；本地源码链接固定在 `d8bee62c1ddc227d5e4385d80bbf6d7dee266a41`。

## E1：论文事实

- **E1-PAPER**：Ledru、Tardieu、Zacchiroli，[*Rust Coreutils: Rebuilding Unix Foundations in a Modern Language*](https://arxiv.org/abs/2608.07135)，全文与摘要。
- **E1-P1**：论文第 2 页，P1 要求 uutils 成为 functional drop-in replacement；成功调用的成功性、退出码、stdout 与文件系统结果保持一致，stderr 允许更有信息量。
- **E1-P2-P3**：论文第 2-3 页，现代软件能力与“保持代码小且可维护”的设计原则。
- **E1-ARCH**：论文第 3 页，多个 utility crate 依赖共享 `uucore`，以及 multicall binary 的体积动机。
- **E1-TEST-STACK**：论文第 3-4 页，单元、集成、外部端到端套件的三层测试策略与 GNU 套件趋势图。
- **E1-DIFF-FUZZ**：论文第 4-5 页，传统 fuzz、differential testing、grammar-guided 输入、LibFuzzer 覆盖引导和失败缩减。
- **E1-COMPARE**：论文第 5-6 页，依赖供应链与复杂度比较；数字只在注明论文版本和方法时使用。
- **E1-COMMUNITY**：论文第 6-8 页，仓库活动、贡献者漏斗与现代语言吸引新贡献者的观察。
- **E1-OS-INTEGRATION**：论文第 6-7 页，Apertis、Snap Spectacles、Ubuntu 25.10 部署、真实兼容性反馈、持续性能监控与按机器回退。
- **E1-LESSONS**：论文第 7-8 页，兼容原则、差分测试、fuzz、系统监控和大规模用户测试是替换基础组件的关键条件。

## E2：源码、项目规则与工具链事实

- **E2-AI-OWNERSHIP**：[`AGENTS.md:7-10`](https://github.com/uutils/coreutils/blob/d8bee62c1ddc227d5e4385d80bbf6d7dee266a41/AGENTS.md#L7-L10)，驱动 Agent 的人负责输出，审稿回复由人完成。
- **E2-CLEANROOM**：[`AGENTS.md:12-15`](https://github.com/uutils/coreutils/blob/d8bee62c1ddc227d5e4385d80bbf6d7dee266a41/AGENTS.md#L12-L15)、[`CONTRIBUTING.md:17-25`](https://github.com/uutils/coreutils/blob/d8bee62c1ddc227d5e4385d80bbf6d7dee266a41/CONTRIBUTING.md#L17-L25) 与 [`CONTRIBUTING.md:128-133`](https://github.com/uutils/coreutils/blob/d8bee62c1ddc227d5e4385d80bbf6d7dee266a41/CONTRIBUTING.md#L128-L133)，禁止基于 GNU 实现源码派生内容，同时允许阅读 GNU 手册而非源码；黑盒/外部套件入口另见 E2-EXTERNAL-SUITES。
- **E2-NO-TEST-NO-MERGE**：[`AGENTS.md:17-23`](https://github.com/uutils/coreutils/blob/d8bee62c1ddc227d5e4385d80bbf6d7dee266a41/AGENTS.md#L17-L23)，行为变化与 bug fix 需要测试，外部测试差异修复要固化 Rust 回归测试。
- **E2-ORIENTATION**：[`CONTRIBUTING.md:29-51`](https://github.com/uutils/coreutils/blob/d8bee62c1ddc227d5e4385d80bbf6d7dee266a41/CONTRIBUTING.md#L29-L51)，utility、`uucore`、测试、multicall 和 fuzz 目录边界。
- **E2-GOALS**：[`CONTRIBUTING.md:62-75`](https://github.com/uutils/coreutils/blob/d8bee62c1ddc227d5e4385d80bbf6d7dee266a41/CONTRIBUTING.md#L62-L75)，兼容、跨平台、可靠、性能和测试目标。
- **E2-RUST-SAFETY**：[`CONTRIBUTING.md:140-187`](https://github.com/uutils/coreutils/blob/d8bee62c1ddc227d5e4385d80bbf6d7dee266a41/CONTRIBUTING.md#L140-L187)，避免 panic/exit、限制 unsafe、路径使用 `OsStr`/`Path`。
- **E2-AI-POLICY**：[`CONTRIBUTING.md:218-229`](https://github.com/uutils/coreutils/blob/d8bee62c1ddc227d5e4385d80bbf6d7dee266a41/CONTRIBUTING.md#L218-L229)，AI 贡献允许但人类必须理解、解释、负责并保持补丁小而集中。
- **E2-ATOMICITY**：[`CONTRIBUTING.md:231-244`](https://github.com/uutils/coreutils/blob/d8bee62c1ddc227d5e4385d80bbf6d7dee266a41/CONTRIBUTING.md#L231-L244) 与 [`CONTRIBUTING.md:276-286`](https://github.com/uutils/coreutils/blob/d8bee62c1ddc227d5e4385d80bbf6d7dee266a41/CONTRIBUTING.md#L276-L286)，原子提交、小而自包含的 PR、机械移动与功能修改分离。
- **E2-COMPAT-WORKFLOW**：[`CONTRIBUTING.md:302-330`](https://github.com/uutils/coreutils/blob/d8bee62c1ddc227d5e4385d80bbf6d7dee266a41/CONTRIBUTING.md#L302-L330)，从最小外部测试到 Rust 回归测试的兼容性修复流程。
- **E2-STATIC-GATES**：[`DEVELOPMENT.md:53-88`](https://github.com/uutils/coreutils/blob/d8bee62c1ddc227d5e4385d80bbf6d7dee266a41/DEVELOPMENT.md#L53-L88) 与 [`.pre-commit-config.yaml:47-69`](https://github.com/uutils/coreutils/blob/d8bee62c1ddc227d5e4385d80bbf6d7dee266a41/.pre-commit-config.yaml#L47-L69)，pre-commit、Clippy、rustfmt 与 Cargo.lock 检查。
- **E2-DENY**：[`deny.toml:3-31`](https://github.com/uutils/coreutils/blob/d8bee62c1ddc227d5e4385d80bbf6d7dee266a41/deny.toml#L3-L31) 与 [`deny.toml:45-125`](https://github.com/uutils/coreutils/blob/d8bee62c1ddc227d5e4385d80bbf6d7dee266a41/deny.toml#L45-L125)，advisory、license、duplicate 与 source policy。
- **E2-TEST-COMMANDS**：[`DEVELOPMENT.md:111-152`](https://github.com/uutils/coreutils/blob/d8bee62c1ddc227d5e4385d80bbf6d7dee266a41/DEVELOPMENT.md#L111-L152)，Cargo 与 nextest 的测试选择。
- **E2-EXTERNAL-SUITES**：[`DEVELOPMENT.md:197-241`](https://github.com/uutils/coreutils/blob/d8bee62c1ddc227d5e4385d80bbf6d7dee266a41/DEVELOPMENT.md#L197-L241)，BusyBox 与 GNU 外部测试套件入口。
- **E2-WORKSPACE**：[`Cargo.toml:375-395`](https://github.com/uutils/coreutils/blob/d8bee62c1ddc227d5e4385d80bbf6d7dee266a41/Cargo.toml#L375-L395)，workspace 成员、Rust 2024、MSRV 与版本。
- **E2-LINTS**：[`Cargo.toml:517-538`](https://github.com/uutils/coreutils/blob/d8bee62c1ddc227d5e4385d80bbf6d7dee266a41/Cargo.toml#L517-L538)，workspace 级 lint 配置。
- **E2-MULTICALL**：[`src/bin/coreutils.rs:52-143`](https://github.com/uutils/coreutils/blob/d8bee62c1ddc227d5e4385d80bbf6d7dee266a41/src/bin/coreutils.rs#L52-L143)，根据二进制名或第二参数选择并调度 utility。
- **E2-UUCORE**：[`src/uucore/src/lib/lib.rs:16-140`](https://github.com/uutils/coreutils/blob/d8bee62c1ddc227d5e4385d80bbf6d7dee266a41/src/uucore/src/lib/lib.rs#L16-L140)，共享模块与平台/feature gate。
- **E2-ERROR-MODEL**：[`src/uucore/src/lib/mods/error.rs:5-32`](https://github.com/uutils/coreutils/blob/d8bee62c1ddc227d5e4385d80bbf6d7dee266a41/src/uucore/src/lib/mods/error.rs#L5-L32) 与 [`error.rs:65-103`](https://github.com/uutils/coreutils/blob/d8bee62c1ddc227d5e4385d80bbf6d7dee266a41/src/uucore/src/lib/mods/error.rs#L65-L103)，`UResult`、`UError` 与退出码的桥接。
- **E2-ERROR-COMPAT**：[`src/uucore/src/lib/mods/error.rs:461-506`](https://github.com/uutils/coreutils/blob/d8bee62c1ddc227d5e4385d80bbf6d7dee266a41/src/uucore/src/lib/mods/error.rs#L461-L506)，对 OS error 文本进行兼容性规范化。
- **E2-UUFUZZ-RUN**：[`fuzz/uufuzz/src/lib.rs:26-38`](https://github.com/uutils/coreutils/blob/d8bee62c1ddc227d5e4385d80bbf6d7dee266a41/fuzz/uufuzz/src/lib.rs#L26-L38) 与 [`lib.rs:157-243`](https://github.com/uutils/coreutils/blob/d8bee62c1ddc227d5e4385d80bbf6d7dee266a41/fuzz/uufuzz/src/lib.rs#L157-L243)，结果模型和参考实现执行。
- **E2-UUFUZZ-COMPARE**：[`fuzz/uufuzz/src/lib.rs:246-323`](https://github.com/uutils/coreutils/blob/d8bee62c1ddc227d5e4385d80bbf6d7dee266a41/fuzz/uufuzz/src/lib.rs#L246-L323)，stdout、可选 stderr 与退出码比较。
- **E2-CARGO-OFFICIAL**：[Cargo Workspaces](https://doc.rust-lang.org/cargo/reference/workspaces.html)、[Features](https://doc.rust-lang.org/cargo/reference/features.html) 与 [Profiles](https://doc.rust-lang.org/cargo/reference/profiles.html)。

<!-- source: AGENTS.md -->
<!-- source: CONTRIBUTING.md -->
<!-- source: DEVELOPMENT.md -->
<!-- source: .pre-commit-config.yaml -->
<!-- source: deny.toml -->
<!-- source: Cargo.toml -->
<!-- source: src/bin/coreutils.rs -->
<!-- source: src/uucore/src/lib/lib.rs -->
<!-- source: src/uucore/src/lib/mods/error.rs -->
<!-- source: fuzz/uufuzz/src/lib.rs -->

## E3：生产与版本演化事实

- **E3-MIGRATION-DESIGN**：Ubuntu Foundations，[*Migration to rust-coreutils in 25.10*](https://discourse.ubuntu.com/t/migration-to-rust-coreutils-in-25-10/59708)，发布于 2025-04-23；支持 Essential package 的迁移、保护性 diversion 与回退设计。
- **E3-DEFAULT-25.10**：Ubuntu Foundations，[*Ubuntu 25.10 Foundations Edition*](https://discourse.ubuntu.com/t/ubuntu-25-10-foundations-edition-what-s-coming-and-what-s-next/68147)，发布于 2025-09-26；这是发行前说明，支持默认使用 rust-coreutils 并保留 GNU 切换路径，不把发布日期写成正式发行日。
- **E3-RELEASE-25.10**：[Ubuntu 25.10 release schedule](https://documentation.ubuntu.com/release-notes/25.10/schedule/) 与 [正式发布公告](https://discourse.ubuntu.com/t/ubuntu-25-10-questing-quokka-released/69067)，正式发行事件日为 2025-10-09。
- **E3-DATE-INCIDENT**：Ubuntu Foundations，[*Enabling updates on Ubuntu 25.10 systems*](https://discourse.ubuntu.com/t/enabling-updates-on-ubuntu-25-10-systems/70773)，通知发布于 2025-10-23；记录当时已解决的 `date` 兼容问题影响部分系统的自动更新检查，以及 `0.2.2-0ubuntu2.1` 或更高版本不受影响。通知日不是事故首次发生日。
- **E3-AUDIT-UPDATE**：Ubuntu Foundations，[*An update on rust-coreutils*](https://discourse.ubuntu.com/t/an-update-on-rust-coreutils/80773/1)，总结发布于 2026-04-22；审计事件分为 2025-12 至 2026-01、2026-02 至 2026-03 两阶段，支持 113 项发现、0.8.0 修复进展以及截至该文时 26.04 中 `cp`、`mv`、`rm` 的 GNU 保留。
- **E3-RELEASE-26.04**：[Ubuntu 26.04 LTS summary](https://documentation.ubuntu.com/release-notes/26.04/summary-for-lts-users/)，正式发行事件日为 2026-04-23；支持 rust-coreutils 为默认 provider、兼容回退仍在，且三个文件操作工具暂用 GNU。
- **E3-SECURITY-26.04**：[Ubuntu 26.04 LTS security updates](https://ubuntu.com/blog/ubuntu-26-04-lts-security-updates)，发布于 2026-04-10；将内存安全实现的采用与成熟度绑定，并说明先在 interim release 验证、再进入 LTS 的阶段方向。
- **E3-KNOWN-RISKS**：[Ubuntu 26.04 LTS changes since 25.10](https://documentation.ubuntu.com/release-notes/26.04/changes-since-previous-interim/)；`published_at=unknown`（官方页面未暴露独立发布日期），`last_updated_at=2026-05-06`，`verified_at=2026-08-14`。适用范围：页面整体适用于 Ubuntu 26.04 LTS 相对 25.10 的变化；POSIX ACL 条目明确说明问题也存在于 Ubuntu 25.10，`rust-coreutils` 漏洞清单以“This release”限定于 Ubuntu 26.04 LTS。

E3 时间字段遵循“事件日与发布日期分列”：发行事件取官方 schedule/公告，后续总结的发布日期只说明信息何时公开。E3 提供发生了什么；E4 才把 shadow、canary、kill switch 和 rollback drill 组织成可迁移方法，两层不得合写成“Ubuntu 采用了本书流水线”。

## E4：本书方法提炼

- **E4-SEARCHER**：Agent 是约束下的实现搜索器，而非代码翻译器。
- **E4-CONTEXT-BOUNDARY**：把许可证、隐私、供应链与生产资料访问权写成 Agent Context Boundary。
- **E4-ATOMICITY**：一个 Agent 任务对应一个行为意图、一个小 diff 和一个验证集合。
- **E4-CHANGE-PACKAGE**：交付单位是实现、回归测试、验证证据和责任说明的组合，而非孤立 patch。
- **E4-DISCOVER-LOOP**：Discover -> Minimize -> Codify -> Repair -> Verify。
- **E4-VERIFICATION-LADDER**：类型/编译、lint、单元、集成、差分、fuzz、CI、生产监控逐级压缩错误空间。
- **E4-ROLLBACK**：迁移安全来自错误可发现、可定位、可恢复，而不是对实现者或模型“永不犯错”的假设。
- **E4-PIPELINE**：十阶段 AI-Native Rust Migration Pipeline。

## 术语表

- **行为契约（behavior contract）**：第 3 章规范的七字段 `K=(I,O,X,S,E,P,U)`，分别覆盖输入/前态、输出通道、退出/信号/超时、状态转移、环境、平台能力、非确定性/未知，并要求独立的 `non_goals`。
- **oracle**：对同一输入给出期望观察结果的参考机制；它可能是旧实现、规范、黄金文件或性质断言。
- **clean room**：实现团队不接触禁止来源代码，只依据允许的规范和黑盒行为独立实现。
- **differential testing**：对同一输入运行多个实现并比较观察结果。
- **回归捕获**：把一次发现的差异缩减为稳定、永久运行的测试。
- **Change Package**：包含意图、实现、测试、证据、风险和回退信息的变更交付单元。
- **TOCTOU**：检查与使用之间状态变化造成的竞态漏洞或错误。
- **Task Contract**：编码前固定单一行为意图、上下文、变更范围、停止条件、验证与责任的任务契约。
- **Agent Context Manifest**：同时记录声明权限和实际工具访问的上下文清单；它不保存模型隐式推理。
- **Agent Atomicity**：一个 Agent 任务对应一个可独立接受、拒绝和回退的行为决策及证据集。
- **Profile**：由可观察触发条件选择的 DoD 门禁集合；本书的五种 Profile 可组合并取要求并集。
- **normalization（归一化）**：仅在行为契约授权时，对非确定或环境相关观测作结构化映射后比较。
- **Shadow**：不让候选结果影响用户、但对真实或重放输入采集候选观测的发布状态。
- **Canary**：将候选交给有限且代表性的实际工作负载，并以预设阈值决定扩展或回退。
- **provider**：在发行版或部署系统中为某组命令/能力提供实际文件和默认实现的软件包或实现方。
- **artifact provenance**：把候选二进制、源码 commit、构建参数、依赖锁、签名与 rollout 配置连接起来的来源链。
- **blast radius**：一次错误可能触及的调用者、平台、数据与流量范围；不等同于 diff 行数。
- **cohort**：按预先声明的风险维度选择并可独立停止的一组机器、用户或工作负载。
- **hard gate / soft gate**：hard gate 越界必须停止或回退；soft gate 要求人类解释后才可晋级。
- **kill switch**：不依赖新构建即可停止候选路径或切回 provider 的受控入口。
- **rollback drill**：使用真实产物和权限计时演练切回与状态恢复，而非只阅读步骤。
- **stateful shadow**：让候选处理代表输入但以只读、快照、命名空间或双写验证隔离副作用的观察阶段。
- **run ID**：标识一次固定基线、命令、环境、时间和结果的可重放验证执行。
- **seed**：可以重放差异或性质失败的最小化输入及其环境/fixture。
- **Unverified**：因未运行、环境缺失或证据不足而无法判定；不是较弱的 Pass。
- **exception / waiver**：由有权角色批准、范围受限、具有补偿控制、回滚和到期日的临时未知接受。
- **L1/L2/L3**：附录 E 的 Evidence Ready、Change Ready、Release Ready 判定级别；它们引用而不替代第 13 章 Profile。

## 章节反向索引

| 主题/工件 | 首次建立 | 深化与验证 | 生产/模板入口 |
|---|---|---|---|
| 问题重定义、成功边界 | 第 1 章 | 第 2、3 章 | 前言、附录 A |
| Behavior Contract / oracle | 第 3 章 | 第 8—10 章 | 附录 B、A |
| Context Boundary / Manifest | 第 4 章 | 第 12、16 章 | 附录 C |
| Rust 接缝、共享层 | 第 5 章 | 第 7、11 章 | 附录 D、A 轨迹二 |
| Agent Atomicity / Task Contract | 第 6 章 | 第 12、13 章 | 附录 B |
| 静态门禁与测试层级 | 第 7、8 章 | 第 9、10 章 | 附录 E L1/L2 |
| 差分、fuzz、回归捕获 | 第 9、10 章 | 第 12 章 | 附录 A 轨迹一/三 |
| 人类审查、AI 责任 | 第 11 章 | 第 12、16 章 | 附录 E |
| Change Package | 第 12 章 | 第 13、16 章 | 附录 A、E |
| DoD Profile | 第 13 章（规范接口） | 第 14—16 章 | 附录 D、E（引用接口） |
| Shadow / canary / kill switch | 第 14 章 | 第 15、16 章 | 附录 A 轨迹三 |
| Ubuntu 生产边界 | 第 15 章 | 第 14、16 章方法解释 | 本附录 E3 |
| 十阶段流水线、30/60/90 | 第 16 章 | 全书回流 | 附录 A 全部轨迹 |

## Evidence ID 到章节的反向入口

- `E1-P1`、`E1-TEST-STACK`、`E1-DIFF-FUZZ`：第 2、3、8—10 章，用于兼容目标与验证技术的研究窗口事实。
- `E1-ARCH`、`E2-UUCORE`、`E2-ERROR-MODEL`：第 5、7、11 章及附录 A 轨迹二，用于共享层与错误桥接。
- `E2-CLEANROOM`、`E2-AI-OWNERSHIP`、`E2-AI-POLICY`：第 4、6、11—13、16 章与附录 B/C/E。
- `E2-NO-TEST-NO-MERGE`、`E2-COMPAT-WORKFLOW`、`E2-UUFUZZ-*`：第 8—10、12 章与附录 A 轨迹一/三。
- `E2-STATIC-GATES`、`E2-DENY`、`E2-TEST-COMMANDS`：第 7、8、12、13 章与附录 D/E。
- `E3-MIGRATION-DESIGN`、`E3-DEFAULT-25.10`、`E3-RELEASE-25.10`：第 14、15 章；分别支持设计、发行前状态和正式发行事件，不能互换。
- `E3-DATE-INCIDENT`：第 14—16 章与附录 A 轨迹三，只支持官方写明的影响、解决状态和版本边界。
- `E3-AUDIT-UPDATE`、`E3-RELEASE-26.04`、`E3-KNOWN-RISKS`：第 14—16 章与附录 D，支持审计、范围和已知生产限制。
- `E4-*`：分布于所有方法章；每个 ID 都是工程综合，采用者需要用自己的 Task Contract、run 和生产证据重新验证。

## 版本与核验声明

本书 E2 基线为 `d8bee62c1ddc227d5e4385d80bbf6d7dee266a41`，E3 currentness cutoff 为 **2026-08-14**。论文 arXiv 版本提交于 2026-08-07；论文数据窗口、仓库固定 commit 和 Ubuntu 生产日期是三条独立时间轴。维护者更新任一时间轴时，应先用本反向索引定位受影响章节，再修改结论与版本说明，不用较新的 E3 事实倒填较早 E1 测量。
