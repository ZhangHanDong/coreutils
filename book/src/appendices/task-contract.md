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
