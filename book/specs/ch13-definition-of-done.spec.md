spec: task
name: "第13章 Definition of Done"
inherits: book
tags: [chapter, done, verification]
---

## 意图

把上下文、原子性、静态检查、测试、差分、fuzz、人工审阅和回退整合为 AI Migration Definition of Done。

## 约束

- 正文为 3900-5100 个中文字符。
- 使用 E2-STATIC-GATES、E2-NO-TEST-NO-MERGE、E2-AI-OWNERSHIP、E4-CHANGE-PACKAGE 与 E4-VERIFICATION-LADDER。
- 每个检查项说明适用条件，不要求无关项目机械照搬。

## 已定决策

- 完成是门禁合取，不是模型自评或单项测试结果。
- 不能执行的门禁必须记录为未验证或获得显式豁免。

## 边界

### 允许修改
- book/src/part4/ch13-definition-of-done.md

### 禁止修改
- book/src/appendices/dod-checklist.md

## 验收标准

场景: 完成定义覆盖全链路
  测试: test_ch13_dod
  假设 一个迁移变更声称完成
  当 使用本章门禁表
  那么 上下文、构建、测试、差分、人工责任与回退均有状态

场景: 未验证项不能写成通过
  测试: test_ch13_unverified_gate
  假设 相关 fuzz target 未运行
  当 生成完成记录
  那么 该项标记为未验证而不是通过

## 排除范围

- 声称清单能够形式化证明正确性。
