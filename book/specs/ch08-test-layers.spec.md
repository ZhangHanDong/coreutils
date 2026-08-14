spec: task
name: "第8章 测试层次"
inherits: book
tags: [chapter, testing, integration]
---

## 意图

说明单元、Rust 集成、外部端到端与生产反馈为何不能互相替代。把测试速度、隔离性、覆盖面和诊断成本放在同一分层模型中。

## 约束

- 正文为 12,000–14,000 个中文字符。
- 使用 E1-TEST-STACK、E2-TEST-COMMANDS、E2-EXTERNAL-SUITES、E2-NO-TEST-NO-MERGE 与 E4-VERIFICATION-LADDER。
- 论文中的测试数量只按论文基线陈述。

## 已定决策

- 外部套件是兼容性基准，不是唯一事实源。
- 新发现的差异必须落入本项目可维护的 Rust 回归测试。

## 边界

### 允许修改
- book/src/part3/ch08-test-layers.md

### 禁止修改
- tests/**

## 验收标准

场景: 测试金字塔体现不同反馈周期
  测试: test_ch08_layer_matrix
  假设 四种验证层同时存在
  当 读者选择失败定位入口
  那么 表格给出速度、范围、oracle 与持久化策略

场景: 外部测试修复没有丢失
  测试: test_ch08_external_failure_capture
  假设 一个外部套件用例从失败变为通过
  当 使用本章流程
  那么 还需增加本地 Rust 回归测试

场景: 扩写结构可由独立章节门禁验证
  测试: test_ch08_expansion_structure
  假设 本章已达到批准字符预算
  当 执行章节质量门禁
  那么 本章包含工程案例、反例、可复用工件、三个练习和证明边界

## 排除范围

- 罗列每个 utility 的全部测试。
