spec: task
name: "第4章 Clean Room与上下文边界"
inherits: book
tags: [chapter, clean-room, governance]
---

## 意图

把 clean-room 从法律备注提升为 Agent 上下文访问控制。章节给出允许源、禁止源、派生风险、记录方式与越界响应。

## 约束

- 正文为 10,000–12,000 个中文字符。
- 使用 E2-CLEANROOM、E2-AI-POLICY、E1-P1 与 E4-CONTEXT-BOUNDARY。
- 不链接或描述 GNU 实现源码。

## 已定决策

- 上下文许可表区分 MAY READ、MUST NOT READ 与 NEEDS REVIEW。
- clean-room 只降低派生风险，不自动证明实现独立性。

## 边界

### 允许修改
- book/src/part2/ch04-clean-room.md

### 禁止修改
- util/**

## 验收标准

场景: 访问边界可直接执行
  测试: test_ch04_permission_matrix
  假设 Agent 开始兼容性任务
  当 查阅本章许可表
  那么 手册、规范、黑盒输出与目标仓库有明确分类

场景: 禁止来源不进入书稿
  测试: test_ch04_forbidden_source
  假设 质量脚本扫描本章
  当 发现禁止实现来源
  那么 门禁返回失败

场景: 扩写结构可由独立章节门禁验证
  测试: test_ch04_expansion_structure
  假设 本章已达到批准字符预算
  当 执行章节质量门禁
  那么 本章包含工程案例、反例、可复用工件、三个练习和证明边界

## 排除范围

- 针对具体司法辖区的法律意见。
