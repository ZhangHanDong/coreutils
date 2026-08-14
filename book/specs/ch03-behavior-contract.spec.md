spec: task
name: "第3章 行为契约"
inherits: book
tags: [chapter, contract, compatibility]
---

## 意图

把兼容目标转换成可执行的行为契约。读者应能从命令说明提取输入、输出、退出状态、副作用、错误与平台差异，并识别契约中的非对称允许项。

## 约束

- 正文为 12,000–14,000 个中文字符。
- 使用 E1-P1、E2-GOALS、E2-ERROR-COMPAT 与 E4-CHANGE-PACKAGE。
- 至少给出成功、失败、文件系统副作用和平台差异矩阵。

## 已定决策

- stderr 不默认要求字节相等，是否严格比较由契约显式声明。
- 性能与扩展特性不覆盖兼容性主契约。

## 边界

### 允许修改
- book/src/part1/ch03-behavior-contract.md

### 禁止修改
- book/src/part2/**

## 验收标准

场景: 行为矩阵覆盖主要观察面
  测试: test_ch03_behavior_matrix
  假设 一个待迁移 CLI
  当 读者使用本章模板
  那么 模板包含输入、stdout、stderr、退出码、文件系统和平台列

场景: 含糊兼容声明被拒绝
  测试: test_ch03_rejects_vague_compatibility
  假设 声明仅写“功能兼容”
  当 套用本章检查表
  那么 它被判定为不可验证契约

场景: 扩写结构可由独立章节门禁验证
  测试: test_ch03_expansion_structure
  假设 本章已达到批准字符预算
  当 执行章节质量门禁
  那么 本章包含工程案例、反例、可复用工件、三个练习和证明边界

## 排除范围

- ABI 与网络协议的完整形式化规格。
