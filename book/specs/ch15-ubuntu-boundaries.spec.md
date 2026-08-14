spec: task
name: "第15章 Ubuntu部署与方法边界"
inherits: book
tags: [chapter, ubuntu, audit, counterexample]
---

## 意图

用 Ubuntu 25.10 到 26.04 的真实生产时间线检验本书方法。既呈现大规模迁移的成功，也纳入 `date` 事故、安全审计和三个 GNU 工具保留的反证。

## 约束

- 正文为 4500-5500 个中文字符。
- 使用 E1-OS-INTEGRATION、E3-MIGRATION-DESIGN、E3-DATE-INCIDENT、E3-AUDIT-UPDATE、E3-RELEASE-26.04 与 E3-KNOWN-RISKS。
- 所有生产事件给出精确日期或版本，不把不同时点压成单一状态。

## 已定决策

- 安全审计事实优先于“Rust 自动更安全”的概括。
- 26.04 是 rust-coreutils 默认 provider，但 `cp`、`mv`、`rm` 暂由 GNU 提供。

## 边界

### 允许修改
- book/src/part5/ch15-ubuntu-boundaries.md

### 禁止修改
- book/src/part5/ch14-rollout-rollback.md

## 验收标准

场景: 生产时间线可核实
  测试: test_ch15_timeline
  假设 读者比较论文、25.10 与 26.04
  当 阅读时间线
  那么 每个节点包含来源、日期、版本或部署状态

场景: 反证没有被成功叙事吞没
  测试: test_ch15_counterevidence
  假设 章节总结迁移总体成功
  当 检查同一结论的限制条件
  那么 同时包含审计发现、已知风险和部分工具回退

## 排除范围

- 重新执行 Zellic 安全审计。
