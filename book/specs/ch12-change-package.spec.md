spec: task
name: "第12章 Change Package"
inherits: book
tags: [chapter, deliverable, evidence]
---

## 意图

把 Agent 的交付单位从 patch 升级为 Change Package。定义行为意图、实现、回归测试、验证记录、风险、来源声明和回退影响之间的关系。

## 约束

- 正文为 3900-5000 个中文字符。
- 使用 E2-NO-TEST-NO-MERGE、E2-AI-POLICY、E2-ATOMICITY、E4-ATOMICITY 与 E4-CHANGE-PACKAGE。
- 给出可直接复制的 YAML 示例并说明它不是仓库现行格式。

## 已定决策

- 证据记录命令、范围、结果与运行环境，不只写“测试通过”。
- 回退影响是每个行为变更的必填评估。

## 边界

### 允许修改
- book/src/part4/ch12-change-package.md

### 禁止修改
- book/src/appendices/task-contract.md

## 验收标准

场景: Change Package 字段闭合
  测试: test_ch12_change_package_schema
  假设 一个行为修复准备审稿
  当 使用本章 YAML
  那么 记录包含意图、来源、实现、测试、验证、风险、责任人和回退影响

场景: 只有 patch 的交付被拒绝
  测试: test_ch12_patch_only
  假设 Agent 只返回代码 diff
  当 应用本章完成定义
  那么 交付被判定不完整

## 排除范围

- 强制 uutils 采用本书 YAML 格式。
