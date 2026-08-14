spec: task
name: "第11章 Human Owns the Change"
inherits: book
tags: [chapter, governance, review]
---

## 意图

明确使用 Agent 不转移意图、接受、架构、审稿沟通与最终责任。把“理解每一行”转换为可观察的人类门禁行为。

## 约束

- 正文为 3800-4900 个中文字符。
- 使用 E2-AI-OWNERSHIP、E2-AI-POLICY、E2-NO-TEST-NO-MERGE 与 E4-CHANGE-PACKAGE。
- 不把当前 AI policy 归入论文事实。

## 已定决策

- Agent authorship 与 change ownership 分离。
- 人类审稿回复不得由 Agent 代答。

## 边界

### 允许修改
- book/src/part4/ch11-human-owns-change.md

### 禁止修改
- AGENTS.md

## 验收标准

场景: 责任矩阵覆盖交付生命周期
  测试: test_ch11_responsibility_matrix
  假设 Agent 生成实现和测试
  当 人类准备提交变更
  那么 矩阵要求其确认意图、diff、证据、风险与审稿回复

场景: 无法解释的代码不能通过
  测试: test_ch11_unexplained_change
  假设 提交者不能解释关键实现
  当 应用人类门禁
  那么 Change Package 被退回而不是依赖测试绿灯豁免

## 排除范围

- 规定雇佣关系或法律责任主体。
