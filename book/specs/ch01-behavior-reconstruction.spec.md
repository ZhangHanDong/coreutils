spec: task
name: "第1章 从代码翻译到行为重建"
inherits: book
tags: [chapter, methodology, behavior]
---

## 意图

建立全书核心命题：AI 辅助迁移是可验证行为重建，不是逐行翻译。读者应能区分源代码相似性、功能存在与可观察行为兼容。

## 约束

- 正文为 4000-5000 个中文字符，包含定位、Mermaid、局限、实践清单和版本演化说明。
- 使用 E1-P1、E2-GOALS、E4-SEARCHER、E4-VERIFICATION-LADDER。
- 明确 E4-SEARCHER 是本书提炼而非论文原结论。

## 已定决策

- 用 Legacy Behavior -> Contract -> Agent Search -> Rust -> Verification 作为全书主图。
- 用可观察行为五元组引出第3章。

## 边界

### 允许修改
- book/src/part1/ch01-behavior-reconstruction.md

### 禁止修改
- book/src/part1/ch02-uutils-case.md

## 验收标准

场景: 核心命题形成闭环
  测试: test_ch01_contract
  假设 读者只阅读第1章
  当 质量门禁和结构审稿检查本章
  那么 能定位迁移输入、约束、搜索、实现与验证五个环节
  并且 章节包含不少于三个证据 ID

场景: 方法提炼没有冒充论文结论
  测试: test_ch01_evidence_boundary
  假设 E4-SEARCHER 出现在正文
  当 事实审稿检查出处
  那么 文本明确标记其为本书提炼

## 排除范围

- uutils 完整历史与生产部署细节。
