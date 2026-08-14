# 独立审阅处置摘要

日期：2026-08-14  
审阅流程：自动门禁通过后，恰好三名只读审阅者并行完成事实核查、技术审查与结构编辑；主笔统一修订，审阅者未直接改稿。

## 已接受并修订

- 把 Zellic 的工作统一为“分两个阶段进行的外部安全审计”；新增 `E3-SECURITY-26.04`，修正 clean-room、AI policy、stderr 与动态 issue 的证据归因。
- 明确第 1 章五个观察面与第 3 章行为六元组的关系；修正空路径操作数、虚构 utility 示例与 Cargo workspace 继承表述。
- 将 clean-room 脚本准确限定为“出版物引用扫描”，新增 GNU 实现 GitHub URL 的负向回归；正文把工具 ACL、规范化允许列表、网络策略与访问日志列为独立控制。
- 全书统一五种可组合 DoD Profile：Mechanical、Local Behavior、Shared Core、Safety Critical、Release Default；附录 B/D/E 使用相同枚举和取并集规则。
- DoD 空复选框改为含 requirement ID、四值 status、run ID、owner/time 与 waiver 的证据表。
- Context Manifest 分离 `declared_access` 与 `observed_access`，加入 commit/hash、规范化路径、时间、批准决定和输出摘要 hash。
- Task Contract 增加停止条件、升级负责人、阻塞交付和不得自行改契约；FFI 清单补齐布局、unwind、回调、分配器、nullability 与动态库边界。
- 明示基线 `uufuzz` 的 lossy UTF-8、trim、可选 stderr 失败和无文件系统快照限制，把生产级 ExecutionRecord 标为 E4 扩展。
- 16 章均增加“模式提炼”，说明模式名、解决问题、适用前提与失效边界；质量门禁和负向夹具同步要求该节存在。
- 扩充前言的读者准备、证据用途、实际采用步骤和跳读代价；统一篇幅规格权威。
- 附录 A 增加三条轨迹的产物 ID、Task Contract/Profile、源码锚点、失败返回和 DoD/Change Package 交接。
- 修正六个发布状态、两处文字错误、中文目录和术语表，并增加正文—附录相对链接。

## 部分接受

- 结构审阅建议“每个部分设置持续演化的 uutils 侧栏”。本稿没有再引入重复侧栏，而是通过增强附录 A 的三条贯穿轨迹、固定源码锚点及正文到附录的链接实现同一目标。理由：完整 Ubuntu 时间线和 `uufuzz` 细节已各有唯一展开位置，重复侧栏会破坏既定去重规则。
- “每条关键详见均可点击”没有机械性地改写所有章号提及；只对 Task Contract、Context Manifest、Safety/DoD、发布章和端到端轨迹等执行入口增加链接。普通叙事中的前后章号保留为阅读提示。

## 拒绝项

无技术或事实建议被完全拒绝。未逐字采用的编辑建议均在“部分接受”中说明替代方案。

## 残余风险与发布结论

- Ubuntu 26.10、SRU 和上游 issue 是动态事实；未来变更核验日必须重跑 E3 事实检查。
- 文档模板不等于真实工具 ACL、CI 或生产回退已经部署；采用团队必须做端到端演练。
- `mdbook-mermaid` 按 mdBook 0.5.0 构建，而当前 mdBook 为 0.5.3；实测预处理、HTML 与 Mermaid 资源生成成功，保留为非阻断工具版本警告。

在上述限定下，三类阻断发现均已落入正文、附录或自动门禁；修订稿可以进入最终构建与视觉验收。
