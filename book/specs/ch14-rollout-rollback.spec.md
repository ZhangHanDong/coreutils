spec: task
name: "第14章 分阶段发布与回滚"
inherits: book
tags: [chapter, rollout, rollback]
---

## 意图

解释测试之后仍需 shadow、canary、监控、分批扩展和回滚。把部署看作持续产生兼容性证据的实验，而非一次性切换。

## 约束

- 正文为 12,000–14,000 个中文字符。
- 使用 E1-OS-INTEGRATION、E1-LESSONS、E3-MIGRATION-DESIGN、E3-DATE-INCIDENT 与 E4-ROLLBACK。
- 监控指标覆盖正确性、性能、故障率和回退信号。

## 已定决策

- 每个扩展阶段都有准入、观察窗口和回退阈值。
- 回退路径在迁移前设计并持续演练。

## 边界

### 允许修改
- book/src/part5/ch14-rollout-rollback.md

### 禁止修改
- book/src/part5/ch15-ubuntu-boundaries.md

## 验收标准

场景: 发布状态机具有回退边
  测试: test_ch14_rollout_state_machine
  假设 迁移从 shadow 进入 canary
  当 指标越过回退阈值
  那么 状态机返回旧实现并保留诊断证据

场景: 测试通过不触发全量直发
  测试: test_ch14_no_big_bang
  假设 CI 全绿但无真实流量证据
  当 应用本章发布门禁
  那么 只能进入受限部署阶段

场景: 扩写结构可由独立章节门禁验证
  测试: test_ch14_expansion_structure
  假设 本章已达到批准字符预算
  当 执行章节质量门禁
  那么 本章包含工程案例、反例、可复用工件、三个练习和证明边界

## 排除范围

- 指定某个监控厂商或发布平台。
