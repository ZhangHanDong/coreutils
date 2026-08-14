spec: task
name: "第6章 Agent Atomicity"
inherits: book
tags: [chapter, ai-coding, change-scope]
---

## 意图

把小补丁要求转化为 Agent 任务设计规则。说明单一行为意图、最小影响面和针对性验证如何降低归因与审稿成本。

## 约束

- 正文为 10,000–12,000 个中文字符。
- 使用 E2-AI-POLICY、E2-ATOMICITY、E2-NO-TEST-NO-MERGE 与 E4-ATOMICITY。
- 区分机械移动、重构与行为修改。

## 已定决策

- 一个任务对应一个行为意图、一个小 diff 与一个验证集合。
- 小补丁不是固定行数阈值，而是可独立接受或拒绝的审稿单元。

## 边界

### 允许修改
- book/src/part2/ch06-agent-atomicity.md

### 禁止修改
- book/src/part3/**

## 验收标准

场景: 任务切分规则可应用
  测试: test_ch06_atomic_task
  假设 一个任务同时修 bug、改名并重构
  当 使用本章决策树
  那么 任务被拆成可独立验证的单元

场景: 无测试小补丁不被豁免
  测试: test_ch06_small_patch_still_needs_evidence
  假设 diff 只有一行但改变行为
  当 检查 Change Package
  那么 仍要求回归测试与验证证据

场景: 扩写结构可由独立章节门禁验证
  测试: test_ch06_expansion_structure
  假设 本章已达到批准字符预算
  当 执行章节质量门禁
  那么 本章包含工程案例、反例、可复用工件、三个练习和证明边界

## 排除范围

- 为所有组织规定统一的 diff 行数上限。
