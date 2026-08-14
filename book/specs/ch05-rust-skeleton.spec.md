spec: task
name: "第5章 Rust迁移骨架"
inherits: book
tags: [chapter, rust, architecture]
---

## 意图

解释如何先设计可验证的 Rust 骨架，再填充具体行为。重点分析 workspace、utility crate、共享 uucore、feature gate、multicall 与错误模型。

## 约束

- 正文为 13,000–15,000 个中文字符。
- 使用 E1-ARCH、E2-WORKSPACE、E2-UUCORE、E2-MULTICALL、E2-ERROR-MODEL 与 E2-RUST-SAFETY。
- Rust 能力描述必须包含前提与不能防御的语义错误。

## 已定决策

- `UResult` 是退出码与 Rust 错误传播桥接的规范源码例子。
- 模块化不是越细越好，边界由行为和平台变化共同决定。

## 边界

### 允许修改
- book/src/part2/ch05-rust-skeleton.md

### 禁止修改
- src/**

## 验收标准

场景: 架构图映射真实源码
  测试: test_ch05_source_architecture
  假设 Mermaid 图包含 utility、uucore 与 multicall
  当 技术审稿核对符号
  那么 每个节点都有固定源码证据

场景: 语言优势没有绝对化
  测试: test_ch05_rust_limitations
  假设 正文讨论所有权与类型
  当 检查局限部分
  那么 明确逻辑、兼容性与竞态仍需其他验证

场景: 扩写结构可由独立章节门禁验证
  测试: test_ch05_expansion_structure
  假设 本章已达到批准字符预算
  当 执行章节质量门禁
  那么 本章包含工程案例、反例、可复用工件、三个练习和证明边界

## 排除范围

- 教授完整 Rust 语法。
