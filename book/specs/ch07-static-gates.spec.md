spec: task
name: "第7章 静态验证门禁"
inherits: book
tags: [chapter, rustc, clippy, supply-chain]
---

## 意图

建立 rustc、rustfmt、Clippy、Cargo policy 与依赖审计的静态门禁分工。解释门禁怎样缩小 Agent 输出空间，以及每层不能证明什么。

## 约束

- 正文为 4200-5400 个中文字符。
- 使用 E2-STATIC-GATES、E2-DENY、E2-LINTS、E2-WORKSPACE 与 E4-VERIFICATION-LADDER。
- 不把编译通过写成行为兼容证明。

## 已定决策

- 门禁顺序从快速、确定性高的检查到较慢检查。
- dependency policy 与源码正确性分开报告。

## 边界

### 允许修改
- book/src/part3/ch07-static-gates.md

### 禁止修改
- Cargo.toml

## 验收标准

场景: 每个门禁有明确防御边界
  测试: test_ch07_gate_matrix
  假设 表格列出 rustc、rustfmt、Clippy 与 cargo-deny
  当 技术审稿检查表格
  那么 每行同时包含能发现和不能发现的问题

场景: 编译通过不冒充兼容性
  测试: test_ch07_compile_is_not_compatibility
  假设 Rust 程序构建成功
  当 套用本章判定
  那么 仍需行为测试与 oracle 验证

## 排除范围

- 重跑完整 uutils 静态检查。
