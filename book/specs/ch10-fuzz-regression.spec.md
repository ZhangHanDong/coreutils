spec: task
name: "第10章 Fuzz与永久回归"
inherits: book
tags: [chapter, fuzzing, regression]
---

## 意图

解释未知输入空间如何通过 fuzz 被探索，以及一个差异怎样经过缩减、分类、固化、修复和复验成为永久工程资产。

## 约束

- 正文为 12,000–14,000 个中文字符。
- 使用 E1-DIFF-FUZZ、E2-UUFUZZ-COMPARE、E2-COMPAT-WORKFLOW、E2-NO-TEST-NO-MERGE 与 E4-DISCOVER-LOOP。
- 区分崩溃 fuzz、差分 fuzz、性质测试和回归测试。

## 已定决策

- 失败最小化发生在固化回归测试之前。
- fuzz corpus 不替代具名的最小回归用例。

## 边界

### 允许修改
- book/src/part3/ch10-fuzz-regression.md

### 禁止修改
- fuzz/**

## 验收标准

场景: 差异转为永久测试
  测试: test_ch10_discover_loop
  假设 fuzz 发现一个可复现差异
  当 执行五阶段循环
  那么 最终产物包含最小输入、分类、回归测试与修复证据

场景: 不稳定失败不直接进入修复
  测试: test_ch10_flaky_failure
  假设 差异无法稳定复现
  当 应用本章准入条件
  那么 它进入隔离与观察而不是伪造确定性回归测试

场景: 扩写结构可由独立章节门禁验证
  测试: test_ch10_expansion_structure
  假设 本章已达到批准字符预算
  当 执行章节质量门禁
  那么 本章包含工程案例、反例、可复用工件、三个练习和证明边界

## 排除范围

- 教授 libFuzzer 的完整 API。
