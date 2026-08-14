# 技术审查报告

日期：2026-08-14  
角色：独立技术审查（只读）  
初始结论：**CHANGES_REQUIRED**  
修订后处置：见 `review-summary.md`

审阅覆盖 Rust 软件迁移、clean-room、Agent Atomicity、静态/动态/差分/fuzz 门禁、Change Package、DoD 与生产发布。审阅过程未读取 GNU 实现源码或 `util/gnu-patches/**`。

## 发现

1. **P0｜成稿扫描被写成上下文证明**：`scripts/check-source-refs.sh` 只扫描 Markdown 禁止字符串并验证 source marker，不能证明 Agent 没有读取、索引或缓存禁止内容。必须把结果准确命名为“出版物引用扫描”，将允许列表、规范化路径、工具 ACL、网络策略和实际访问日志另列为过程控制。
2. **P1｜DoD Profile 不一致**：正文使用五种可组合 Profile，附录压成 `local/shared/production`，混淆爆炸半径、安全敏感度和发布范围。应全书统一为 `mechanical`、`local_behavior`、`shared_core`、`safety_critical`、`release_default` 的数组并取门禁并集。
3. **P1｜四值状态模板不可执行**：附录 E 声明 `Pass/Fail/Unverified/N/A`，却只给空复选框。应改为包含 requirement ID、status、evidence run、owner、review time、waiver 的表或 schema。
4. **P1｜Context Manifest 缺追溯字段**：模板只有声明来源，没有 commit/hash、规范化路径、检索时间、批准决定和实际访问。应分离 `declared_access` 与 `observed_access`。
5. **P2｜Cargo 继承表述不准确**：workspace 成员不会自动继承全部 package/依赖/lint；需要按机制显式接入，profile 语义另行核对。
6. **P2｜`uufuzz` 案例与 E4 扩展未分开**：基线保存 lossy UTF-8 字符串、比较前 trim/处理 stderr 前缀，stderr 失败可配置，且不采集文件系统副作用；原始字节、signal、资源限制和快照是本书扩展。
7. **P2｜aspirational 风格写成硬要求**：贡献指南明确部分规则仍属目标，应区分指南目标与 lint/CI 的机械强制。
8. **P2｜Task Contract 示例伪精确**：`echo` 示例不成立且关键字段缺失；应改为虚构 utility 并明确它不是完整真实契约。
9. **P2｜任务缺停止/升级出口**：模板应加入 `stop_conditions`、`escalation_owner`、阻塞交付格式和“Agent 不得自行改契约”。
10. **P2｜FFI 清单不完整**：需覆盖 `repr(C)`/布局/union、unwind、回调生命周期/线程/重入、分配释放方、nullability、函数指针和动态库版本。

## 已通过审查

行为契约、参考非绝对 oracle、双沙箱、契约授权 normalization、差异先分类、fuzz 分层最小化、red/green 永久回归、人类所有权、写操作 Shadow 限制和多层回退的技术方向成立。Rust 被正确限定为验证阶梯的一层，没有被写成语义或系统安全的自动证明。

残余风险：模板仍需在具体项目的 CI、工具 ACL 和发布控制面中做真实演练，本文档本身不能证明这些集成已存在。
