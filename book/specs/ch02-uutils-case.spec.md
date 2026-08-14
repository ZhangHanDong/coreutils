spec: task
name: "第2章 uutils案例"
inherits: book
tags: [chapter, uutils, paper]
---

## 意图

用论文和固定源码建立 uutils 案例基线，说明它能支持哪些迁移结论、不能支持哪些 AI 结论。把设计、架构、测试、社区和部署放进同一事实地图。

## 约束

- 正文为 13,000–15,000 个中文字符。
- 使用 E1-P1、E1-P2-P3、E1-ARCH、E1-TEST-STACK、E1-OS-INTEGRATION 与 E2-ORIENTATION。
- 论文测量版本与当前源码版本分开陈述。

## 已定决策

- 论文事实与后来仓库 AI policy 使用不同证据标签。
- 本章不宣称 uutils 是行业标准。

## 边界

### 允许修改
- book/src/part1/ch02-uutils-case.md

### 禁止修改
- book/src/part1/ch01-behavior-reconstruction.md

## 验收标准

场景: 案例基线可复核
  测试: test_ch02_baselines
  假设 论文与源码基线不同
  当 事实审稿读取本章
  那么 两条基线均包含版本或 commit 与日期

场景: AI 结论没有倒灌进论文
  测试: test_ch02_ai_claim_boundary
  假设 本章提到 Coding Agent
  当 检查其证据标签
  那么 相关判断标记为 E2 或 E4 而不是 E1

场景: 扩写结构可由独立章节门禁验证
  测试: test_ch02_expansion_structure
  假设 本章已达到批准字符预算
  当 执行章节质量门禁
  那么 本章包含工程案例、反例、可复用工件、三个练习和证明边界

## 排除范围

- 对论文复杂度测量进行重新计算。
