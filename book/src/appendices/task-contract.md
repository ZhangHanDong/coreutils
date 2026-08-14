# 附录 B：迁移 Task Contract 模板

Task Contract 是给人和 Agent 共同使用的执行边界。它应在编码之前完成，在 Change Package 中原样保留。下面模板适合单一行为意图；如果一个任务需要多个互不依赖的意图，应拆成多个契约，而不是继续增加“顺便修改”。[E4-ATOMICITY]

## 可复制模板

```yaml
contract_version: "1"
task_id: "MIG-UTILITY-001"
title: "用一句话描述唯一行为意图"

intent:
  current_observation: "当前可重复观察到什么"
  desired_behavior: "候选实现应满足什么行为"
  non_goals:
    - "本任务明确不处理的相邻问题"

behavior_contract:
  inputs:
    argv: []
    stdin: "字节、文本或无输入"
    filesystem_fixture: "初始文件树与权限"
    environment: {}
    platform: "OS / architecture / filesystem"
  observables:
    stdout: "exact | normalized | ignored，并说明规则"
    stderr: "exact | normalized | informative-only"
    exit_status: "精确值或允许集合"
    filesystem_effects: "路径、内容、权限、时间与原子性"
    timing_or_resource_limits: "仅在属于契约时填写"
  allowed_variance:
    - "已证明可接受的差异及理由"

context_boundary:
  may_read:
    - "允许的规范、测试、Rust 模块和黑盒记录"
  must_not_read:
    - "受许可证、clean-room、隐私或安全限制的来源"
  needs_human_review:
    - "unsafe、FFI、依赖、公开 API、生产配置"

change_boundary:
  allowed_paths: []
  forbidden_paths: []
  maximum_semantic_scope: "一个行为意图"
  mechanical_changes_separated: true

control_flow:
  stop_conditions:
    - "需要读取未授权来源"
    - "修复要求改变共享接口或降低门禁"
    - "必要平台/fixture 无法验证"
  escalation_owner: "task owner"
  blocked_output: "只交付证据、未决问题和新的契约请求"
  agent_may_amend_contract: false

verification:
  reproduction_command: "最小复现入口"
  tests_required:
    - "失败先行的 Rust 回归测试"
    - "相关单元或集成测试"
  static_gates: []
  differential_cases: []
  platform_matrix: []
  evidence_to_capture:
    - "命令、版本、退出状态和原始日志"

risk:
  blast_radius: "direct | shared | system-critical"
  known_unknowns: []
  rollback: "如何撤销代码或切回 provider"

ownership:
  human_owner: "姓名或角色"
  reviewer: "姓名或角色"
  agent_role: "实现搜索、测试生成或证据整理"
  approval_required_for: []

completion:
  definition_of_done_profiles:
    - "mechanical | local_behavior | shared_core | safety_critical | release_default"
  unverified_policy: "显式阻断或批准豁免"
```

## 填写规则

`current_observation` 必须是可复现事实，不能写成“似乎不兼容”。`desired_behavior` 应描述外部可观察结果，不预设内部实现。`non_goals` 是控制 Agent 搜索空间的关键字段：例如修复退出码时，明确不统一所有错误文案、不升级依赖、不重排模块。[E4-SEARCHER]

`observables` 的每一项都必须选择比较策略。二进制输出、路径字节和 locale 相关文本不能在未论证时强行转成 UTF-8；stderr 是否精确兼容要服从项目目标，而不是默认忽略。文件系统副作用至少考虑存在性、内容、权限、链接、时间戳和失败后的部分状态。第 3 章的行为六元组可直接作为填写检查。

`context_boundary` 不只是 clean-room 声明，还涵盖私有客户数据、凭证、漏洞材料和第三方许可证。允许列表最好具体到文件或数据类别；“可读整个仓库”通常过宽。执行过程中若发现必须访问未列来源，Agent 应停止该分支并请求人类扩展契约，不能自行把来源加入上下文。[E2-CLEANROOM][E4-CONTEXT-BOUNDARY]

`verification` 要同时定义命令和证据。只写“运行测试”无法复核；应给出选择器、feature、平台、oracle 版本和比较字段。对于差分发现，先证明回归测试在修复前失败，再证明修复后通过。对于共享或生产关键变更，要列出未运行的平台，不能把编译成功折算为运行验证。

`ownership` 使责任可追踪。Agent 可以提出实现、生成候选测试和整理结果，但人类所有者需要理解补丁、解释行为选择并回应评审。这与 uutils 对 AI 贡献和人类责任的明确要求一致。[E2-AI-OWNERSHIP][E2-AI-POLICY]

## 极简示例片段：虚构 utility 的退出码

下面是明确虚构的 `example` utility 片段，用来演示字段之间的关系，不声称任何真实命令具有该退出码。实际 Change Package 仍需填写上面的完整模板。

```yaml
task_id: "MIG-EXAMPLE-017"
title: "假设契约：缺失输入文件时保持退出码 2"
intent:
  current_observation: "在已固定的虚构夹具中 oracle=2、candidate=1"
  desired_behavior: "给定最小输入时 candidate 返回 2"
  non_goals: ["统一 stderr 文案", "重构共享错误类型"]
behavior_contract:
  inputs: {argv: ["missing"], platform: "linux-x86_64 test image"}
  observables: {stdout: "exact empty", stderr: "semantic category", exit_status: 2, filesystem_effects: "none"}
context_boundary:
  may_read: ["公开 CLI 规范", "黑盒观测", "candidate Rust 源码"]
  must_not_read: ["参考实现源码"]
change_boundary:
  allowed_paths: ["src/uu/example", "tests/by-util/test_example.rs"]
control_flow:
  stop_conditions: ["需要修改共享错误接口", "无法重放 oracle"]
  escalation_owner: "utility maintainer"
verification:
  reproduction_command: "harness replay cases/exit-017.json"
  tests_required: ["test_missing_input_exit_2"]
  static_gates: ["cargo fmt --check", "cargo clippy -p uu_example --tests"]
  platform_matrix: ["linux-x86_64"]
risk:
  blast_radius: "direct"
  known_unknowns: ["其他平台尚未执行"]
  rollback: "撤销该原子提交"
ownership:
  human_owner: "utility maintainer"
  reviewer: "compatibility reviewer"
  approval_required_for: ["扩大平台范围", "改变退出码契约"]
completion:
  definition_of_done_profiles: ["local_behavior"]
  unverified_policy: "阻断合并"
```

一个好契约应让另一位评审者在不访问聊天历史的情况下回答五个问题：为什么改、允许读什么、允许改哪里、怎样证明、谁承担责任。若答案依赖 Agent 的隐含上下文，契约仍不完整。

## 三个风险级别的完整应用

这里的“低、中、高”只描述本次任务的爆炸半径，不替代第 13 章的 Profile。真正执行时仍填写 `definition_of_done_profiles` 数组；风险变化会触发重新签约，而不是沿用最初标签。

### 低风险：局部解析错误

假设某虚构 utility 的一个纯参数分支错误接受空值。它不写文件、不进入共享 crate，适用 `[local_behavior]`。

```yaml
contract_version: "1"
task_id: "MIG-LOCAL-021"
title: "拒绝 --width= 的空值并保持既有诊断类别"
intent:
  current_observation: "固定夹具下空值被接受，进程返回 0"
  desired_behavior: "空值在任何 I/O 前被拒绝，返回契约值 1"
  non_goals: ["重写参数解析器", "统一所有数值诊断"]
behavior_contract:
  inputs:
    argv: ["--width="]
    stdin: "empty"
    filesystem_fixture: "empty temporary directory"
    environment: {LC_ALL: "C"}
    platform: "linux-x86_64 fixture LOCAL-021"
  observables:
    stdout: "exact empty"
    stderr: "diagnostic category INVALID_WIDTH；动态程序名前缀归一化"
    exit_status: "exact 1"
    filesystem_effects: "none"
    timing_or_resource_limits: "N/A"
  allowed_variance: ["绝对临时目录映射为 <TMP>"]
context_boundary:
  may_read: ["公开 CLI 规范", "fixture LOCAL-021", "目标 utility Rust 模块与测试"]
  must_not_read: ["参考实现源码", "生产日志"]
  needs_human_review: ["扩大到共享参数解析"]
change_boundary:
  allowed_paths: ["src/uu/example", "tests/by-util/test_example.rs"]
  forbidden_paths: ["src/uucore", "Cargo.lock", ".github"]
  maximum_semantic_scope: "只裁决空 width"
  mechanical_changes_separated: true
control_flow:
  stop_conditions: ["需要修改共享 API", "oracle 两次重放不一致"]
  escalation_owner: "utility maintainer"
  blocked_output: "RED run、未决字段与新契约建议"
  agent_may_amend_contract: false
verification:
  reproduction_command: "harness replay LOCAL-021"
  tests_required: ["test_empty_width_rejected", "target utility suite"]
  static_gates: ["fmt", "target clippy"]
  differential_cases: ["LOCAL-021"]
  platform_matrix: ["linux-x86_64=run"]
  evidence_to_capture: ["RED/GREEN run、commit、exit、stdout/stderr hash"]
risk:
  blast_radius: "direct"
  known_unknowns: ["其他 locale 未运行"]
  rollback: "撤销单一补丁；不涉及数据恢复"
ownership: {human_owner: "utility maintainer", reviewer: "compatibility reviewer", agent_role: "实现与证据整理", approval_required_for: ["契约变化"]}
completion: {definition_of_done_profiles: ["local_behavior"], unverified_policy: "阻断合并"}
```

### 中风险：共享路径抽象

任务要在共享 crate 中保留非 UTF-8 路径，直接代码仍可能很少，但消费者和平台扩张使其适用 `[shared_core]`；若实现引入 `unsafe`，必须重新签约并组合 `safety_critical`。

```yaml
contract_version: "1"
task_id: "MIG-SHARED-008"
title: "共享路径诊断保留 OS 原生字节"
intent:
  current_observation: "共享 helper 提前转 UTF-8，代表 utility 对非 UTF-8 路径失败"
  desired_behavior: "路径留在 OsStr/Path 边界；调用者按契约输出或传播"
  non_goals: ["全仓诊断重写", "新增编码依赖", "改变公开 CLI 文案"]
behavior_contract:
  inputs: {argv: ["<NON_UTF8_PATH>"], stdin: "none", filesystem_fixture: "含非 UTF-8 名称与符号链接", environment: {LC_ALL: "C"}, platform: "Unix run；Windows compile-only"}
  observables: {stdout: "per utility", stderr: "原始路径字节不得被替换为错误字符", exit_status: "按代表用例固定", filesystem_effects: "失败前后树一致", timing_or_resource_limits: "N/A"}
  allowed_variance: ["OS error 文本按已批准 category 比较"]
context_boundary:
  may_read: ["共享路径模块", "直接消费者清单", "代表 utility 测试", "公开平台 API 文档"]
  must_not_read: ["参考实现源码", "未清理客户路径"]
  needs_human_review: ["公开 API", "新依赖", "unsafe/FFI", "新增 target"]
change_boundary:
  allowed_paths: ["src/uucore/path", "三个代表消费者", "对应测试"]
  forbidden_paths: ["发布配置", "无关 utility"]
  maximum_semantic_scope: "一个共享表示边界与迁移的三个样本"
  mechanical_changes_separated: true
control_flow:
  stop_conditions: ["消费者矩阵不完整", "safe API 无法保持字节", "Windows 行为必须改变"]
  escalation_owner: "shared-core owner"
  blocked_output: "影响矩阵、最小反例、接口备选"
  agent_may_amend_contract: false
verification:
  reproduction_command: "harness replay PATH-008 --fixture non-utf8"
  tests_required: ["共享单元性质", "三个代表进程测试", "workspace relevant tests"]
  static_gates: ["workspace fmt", "workspace clippy", "dependency policy"]
  differential_cases: ["PATH-008-A", "PATH-008-LINK"]
  platform_matrix: ["linux=run", "macOS=run", "windows=compile-only/Unverified runtime"]
  evidence_to_capture: ["IMPACT-PATH-008", "RED/GREEN", "feature/target 命令"]
risk:
  blast_radius: "shared"
  known_unknowns: ["Windows 非 UTF-8 语义不同且未运行"]
  rollback: "先撤代表消费者，再撤兼容接口；不得留下半迁移 API"
ownership: {human_owner: "shared-core owner", reviewer: "platform reviewer", agent_role: "接口候选与调用者迁移", approval_required_for: ["扩大消费者", "安全 profile 升级"]}
completion: {definition_of_done_profiles: ["shared_core"], unverified_policy: "Windows 保持显式 Unverified，阻断声称全平台完成"}
```

### 高风险：删除 provider 的默认切换

默认流量和不可逆副作用使任务组合 `[local_behavior, safety_critical, release_default]`。实现完成不等于契约关闭，只有真实产物回滚演练和观察窗口结束后才可完成。

```yaml
contract_version: "1"
task_id: "MIG-DELETE-003"
title: "将受限 cohort 的删除命令切换到候选 provider"
intent:
  current_observation: "shadow 样本满足门限，默认路径仍为旧 provider"
  desired_behavior: "仅 cohort C3 使用候选；任一硬阈值触发自动切回"
  non_goals: ["全量默认", "改变恢复策略", "放宽差异比较"]
behavior_contract:
  inputs: {argv: ["来自脱敏工作负载集合的参数"], stdin: "binary-preserving", filesystem_fixture: "可丢弃快照与攻击性链接/权限夹具", environment: "固定 locale/umask", platform: "生产同构镜像与 cohort 标签"}
  observables: {stdout: "按用例", stderr: "category+敏感信息扫描", exit_status: "exact/set", filesystem_effects: "目标、非目标、权限、链接和失败残留完整快照", timing_or_resource_limits: "P95 与超时预算"}
  allowed_variance: ["只有差异登记表批准的字段"]
context_boundary:
  may_read: ["脱敏 replay bundle", "候选代码", "聚合指标", "批准的 rollout 配置"]
  must_not_read: ["原始生产路径/凭证", "参考实现源码"]
  needs_human_review: ["真实流量", "删除权限", "provider 与 kill switch", "豁免"]
change_boundary:
  allowed_paths: ["候选删除 utility", "目标测试", "本任务 rollout 配置"]
  forbidden_paths: ["其他 provider", "全局监控阈值"]
  maximum_semantic_scope: "C3 cohort 默认切换"
  mechanical_changes_separated: true
control_flow:
  stop_conditions: ["出现未分类删除差异", "kill switch 超过恢复目标", "夹具隔离失效", "任何监控 hard gate 越界"]
  escalation_owner: "release commander"
  blocked_output: "冻结 rollout、保全 run/快照、执行回退"
  agent_may_amend_contract: false
verification:
  reproduction_command: "rollout replay DELETE-003 --artifact <signed>"
  tests_required: ["red/green", "权限/链接/竞态", "故障注入", "恢复演练"]
  static_gates: ["full policy gate", "artifact provenance"]
  differential_cases: ["DELETE-CORPUS-003"]
  platform_matrix: ["production-equivalent=run", "cohort C3=canary"]
  evidence_to_capture: ["signed artifact", "shadow diff", "canary metrics", "rollback timestamps", "post-rollback snapshot"]
risk:
  blast_radius: "system-critical"
  known_unknowns: ["长尾挂载类型留在 exclusion list"]
  rollback: "kill switch -> provider 切回 -> cohort 冻结 -> 状态核验；删除数据依靠预先快照恢复"
ownership: {human_owner: "utility owner", reviewer: "safety reviewer", agent_role: "候选与报告，不持有发布权", approval_required_for: ["开始 canary", "扩流", "豁免", "恢复"]}
completion: {definition_of_done_profiles: ["local_behavior", "safety_critical", "release_default"], unverified_policy: "任何关键 Unverified 阻断晋级"}
```

三份契约展示了同一个升级原则：新事实改变读权限、写范围、验证矩阵或恢复责任时，先暂停并升版契约，再继续搜索。不能等补丁写完后再把已经发生的扩张补记成“原本计划”。
