spec: task
name: "第9章 Differential Testing"
inherits: book
tags: [chapter, differential-testing, oracle]
---

## 意图

把遗留可执行文件作为行为 oracle，分析输入生成、双路执行、结果规范化、比较策略与误报边界。以 uufuzz 真实结果模型为核心源码证据。

## 约束

- 正文为 4400-5500 个中文字符。
- 使用 E1-DIFF-FUZZ、E2-UUFUZZ-RUN、E2-UUFUZZ-COMPARE、E2-ERROR-COMPAT 与 E4-SEARCHER。
- 明确 stdout、stderr、退出码和文件系统副作用的比较差异。

## 已定决策

- legacy oracle 不是规范本身，旧实现 bug 和版本差异需要裁决层。
- stderr 是否严格比较必须由行为契约指定。

## 边界

### 允许修改
- book/src/part3/ch09-differential-testing.md

### 禁止修改
- fuzz/**

## 验收标准

场景: 双路执行流程映射 uufuzz
  测试: test_ch09_differential_flow
  假设 图中包含 Rust 与 legacy 两个执行分支
  当 技术审稿核对比较节点
  那么 stdout、stderr 与退出码对应真实字段

场景: oracle 冲突进入裁决
  测试: test_ch09_oracle_conflict
  假设 旧实现与标准或多个实现冲突
  当 应用本章流程
  那么 差异不会被自动复制为目标行为

## 排除范围

- 执行真实 GNU differential fuzz campaign。
