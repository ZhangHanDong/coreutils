spec: task
name: "第16章 AI-Native Rust Migration Pipeline"
inherits: book
tags: [chapter, pipeline, adoption]
---

## 意图

把前十五章压缩成可投入项目的十阶段 pipeline，并给出不同风险等级下的裁剪方式。章节以输入、产物、门禁和退出条件连接各阶段。

## 约束

- 正文为 4400-5500 个中文字符。
- 使用 E1-LESSONS、E2-AI-POLICY、E2-COMPAT-WORKFLOW、E3-AUDIT-UPDATE、E4-PIPELINE 与 E4-ROLLBACK。
- 至少包含一个完整阶段表和一张端到端 Mermaid 图。

## 已定决策

- 十阶段从系统盘点到生产迁移，不以代码生成结束。
- 裁剪只减少与风险无关的门禁，不删除行为契约、人工责任和回退。

## 边界

### 允许修改
- book/src/part5/ch16-pipeline.md

### 禁止修改
- book/src/appendices/**

## 验收标准

场景: pipeline 阶段可执行
  测试: test_ch16_pipeline
  假设 一个迁移项目进入阶段0
  当 按阶段表推进
  那么 每阶段都有输入、产物、门禁和退出条件

场景: 低风险裁剪不移除底线
  测试: test_ch16_tailoring
  假设 项目风险较低且不使用遗留 oracle
  当 裁剪 pipeline
  那么 行为契约、人工责任和回退计划仍保留

## 排除范围

- 把 pipeline 声明为适用于所有项目的行业标准。
