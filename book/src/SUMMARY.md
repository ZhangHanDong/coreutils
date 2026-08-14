# 目录

- [前言](preface.md)
- [证据与版本策略](evidence-policy.md)

# 第一部分：重新定义迁移问题

- [第 1 章：从代码翻译到行为重建](part1/ch01-behavior-reconstruction.md)
- [第 2 章：uutils——一个基础软件重实现样本](part1/ch02-uutils-case.md)
- [第 3 章：兼容性不是功能列表，而是行为契约](part1/ch03-behavior-contract.md)

# 第二部分：约束 Agent 的搜索空间

- [第 4 章：Clean Room 与 Agent Context Boundary](part2/ch04-clean-room.md)
- [第 5 章：用 Rust 建立迁移骨架](part2/ch05-rust-skeleton.md)
- [第 6 章：Agent Atomicity](part2/ch06-agent-atomicity.md)

# 第三部分：建立可验证闭环

- [第 7 章：静态验证门禁](part3/ch07-static-gates.md)
- [第 8 章：测试层次](part3/ch08-test-layers.md)
- [第 9 章：Differential Testing](part3/ch09-differential-testing.md)
- [第 10 章：Fuzz、最小化与永久回归](part3/ch10-fuzz-regression.md)

# 第四部分：治理 AI 生成的变更

- [第 11 章：Human Owns the Change](part4/ch11-human-owns-change.md)
- [第 12 章：从 Patch 到 Change Package](part4/ch12-change-package.md)
- [第 13 章：AI Migration Definition of Done](part4/ch13-definition-of-done.md)

# 第五部分：进入真实生产环境

- [第 14 章：Shadow、Canary、监控与回滚](part5/ch14-rollout-rollback.md)
- [第 15 章：Ubuntu 部署、安全审计与方法边界](part5/ch15-ubuntu-boundaries.md)
- [第 16 章：AI-Native Rust Migration Pipeline](part5/ch16-pipeline.md)

# 附录

- [附录 A：三条端到端迁移轨迹](appendices/e2e-traces.md)
- [附录 B：迁移 Task Contract 模板](appendices/task-contract.md)
- [附录 C：Agent 上下文许可清单](appendices/context-permissions.md)
- [附录 D：Rust Safety Profile](appendices/rust-safety-profile.md)
- [附录 E：Definition of Done 检查表](appendices/dod-checklist.md)
- [附录 F：证据索引、术语表与参考资料](appendices/evidence-index.md)
