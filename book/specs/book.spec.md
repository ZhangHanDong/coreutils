spec: project
name: "AI Coding 时代的 Rust 软件迁移工程"
tags: [book, rust, migration, ai-coding, mdbook, uutils]
---

## 意图

在 `/Users/zhangalex/Work/Projects/consult/coreutils/book` 创建一部完整中文 mdBook，从 uutils/coreutils 论文、MIT 许可源码、项目规则和 Ubuntu 生产迁移资料中，提炼可验证的 AI 辅助 Rust 重实现方法。书籍必须把论文事实、源码事实、生产事实与作者方法提炼分层，使工程师能够复用行为契约、差分 oracle、分层验证、人工治理和可回滚发布流程。

## 约束

- 正文包含且仅包含 16 个编号章节，并包含前言与六个附录。
- 全书预算为 245,000-283,000 个中文字符；论证完整时允许上浮至 300,000 个中文字符。
- 每个正文章必须遵守其章节规格中的字符预算，并包含 `> **定位**`、至少三处一手证据引用、至少一条 evidence comment、至少一张 Mermaid 图、完整工程案例、反例、可复用工件、三个练习、证明边界表、模式提炼、实践清单、局限以及 `### 版本演化说明`。
- 论文基线为 arXiv:2608.07135；源码基线为 `d8bee62c1ddc227d5e4385d80bbf6d7dee266a41`；当前性核验截止日为 2026-08-14。
- 不读取、复制、引用或派生 GNU coreutils GPLv3 实现源码、注释、辅助结构、测试夹具或 `util/gnu-patches/**` 内容。
- 证据标签检查必须拒绝未使用一手来源的外部事实，以及将 E4 方法提炼写成来源原结论的章节。
- `mdbook build` 与所有书籍质量检查必须返回 0，才能报告完成。
- 最终验收检查必须拒绝发生在自动门禁之前的三角色审稿，以及审稿角色直接修改书稿的记录。

## 已定决策

- 输出目录固定为 `/Users/zhangalex/Work/Projects/consult/coreutils/book`。
- 使用 mdBook 0.5.3 与 `mdbook-mermaid`，Mermaid 离线处理。
- 使用“方法论主线 + uutils 贯穿案例”的结构，而不是项目史或规则词典结构。
- 使用 E1 论文、E2 源码、E3 生产、E4 方法提炼四级证据标签。
- 三条 E2E 轨迹放在附录 A，每条连接至少三个正文章。
- 同一段超过三行的源码只在一个规范章节完整引用，其他章节交叉引用。

## 边界

### 允许修改
- book/**

### 禁止修改
- Cargo.toml
- Cargo.lock
- src/**
- tests/**
- fuzz/**
- util/**
- docs/**
- README.md
- CONTRIBUTING.md
- DEVELOPMENT.md
- AGENTS.md

### 禁止行为
- 不运行或读取 GNU coreutils 实现源码。
- 不把论文后的 AI 治理规则写成论文自身结论。
- 不把 Ubuntu 25.10 的默认部署写成所有工具已经永久完成迁移。
- 不使用无法核实的版本、测试数量、性能数字或安全结论。
- 不留下 `TODO`、`TBD`、空章节、伪造引用或仅作装饰的图。

## 验收标准

<!-- lint-ack: bdd-rule-grouping — 本项目规格按完整交付门禁组织，单层场景比能力分组更便于映射检查脚本。 -->

场景: 完整 mdBook 可以离线构建
  测试: test_mdbook_build
  假设 输出目录包含 `book.toml` 与 `src/SUMMARY.md`
  当 执行 `mdbook build /Users/zhangalex/Work/Projects/consult/coreutils/book`
  那么 命令退出码为 "0"
  并且 构建目录包含 `index.html`

场景: 目录覆盖批准的信息架构
  测试: test_summary_covers_approved_structure
  假设 `src/SUMMARY.md` 已生成
  当 质量脚本读取目录链接
  那么 恰好存在 "16" 个编号正文章
  并且 存在前言与 "6" 个附录
  并且 所有链接目标文件存在

场景: 正文章节满足证据与结构契约
  测试: test_chapter_quality_contract
  假设 "16" 个正文章均已写完
  当 质量脚本逐章检查内容
  那么 每章存在定位块、Mermaid 图、至少 "3" 处证据引用、evidence comment 和版本演化说明
  并且 每章存在完整工程案例、反例、可复用工件、至少 "3" 个练习和“能证明什么／不能证明什么”边界表
  并且 每章字符数位于其批准的最小值和最大值之间

场景: 独立章节门禁执行批准的扩写契约
  测试: test_check_chapter_rejects_expansion_contract_violation
  假设 指定一个编号正文和对应章节规格
  当 执行 `bash book/scripts/check-chapter.sh <chapter-path>`
  那么 门禁从章节规格读取该章的最小和最大字符预算
  并且 缺少工程案例、反例、工件、三个练习或证明边界时返回非 "0"

场景: 缺失章节会阻止交付
  测试: test_missing_chapter_fails_quality_gate
  假设 `SUMMARY.md` 链接到不存在的章节
  当 执行书籍质量脚本
  那么 脚本退出码非 "0"
  并且 stderr 标识缺失路径

场景: 失效源码引用会阻止交付
  测试: test_invalid_source_reference_fails_quality_gate
  假设 某章引用不存在的 uutils 源码路径
  当 执行源码引用检查
  那么 脚本退出码非 "0"
  并且 stderr 标识章节和引用路径

场景: GNU 实现来源会阻止交付
  测试: test_forbidden_gnu_source_reference_fails_quality_gate
  假设 书稿出现 `util/gnu-patches/` 或 GNU 实现源码链接
  当 执行 clean-room 检查
  那么 脚本退出码非 "0"
  并且 stderr 标识禁止来源

场景: 占位内容会阻止交付
  测试: test_placeholder_content_fails_quality_gate
  假设 任一正文章包含 `TODO`、`TBD` 或空的二级标题
  当 执行书籍质量脚本
  那么 脚本退出码非 "0"
  并且 stderr 标识文件和占位类型

场景: 未完成审稿会阻止最终状态
  测试: test_review_gate_requires_three_roles
  假设 fact-checker、tech-reviewer 或 structure-editor 任一结果缺失
  当 执行最终验收检查
  那么 脚本退出码非 "0"
  并且 stderr 标识缺失的审稿角色

场景: 缺少批准的版本基线会阻止交付
  测试: test_missing_version_baseline_fails_quality_gate
  假设 任一正文章未声明 arXiv:2608.07135、源码 commit `d8bee62c1ddc227d5e4385d80bbf6d7dee266a41` 或核验日期 `2026-08-14`
  当 执行版本基线检查
  那么 脚本退出码非 "0"
  并且 stderr 标识章节和缺失的基线字段

场景: 事实与方法提炼混写会阻止交付
  测试: test_unlabeled_evidence_synthesis_fails_quality_gate
  假设 某章的外部事实未使用一手来源，或把 E4 方法提炼写成来源原结论
  当 执行证据标签检查
  那么 脚本退出码非 "0"
  并且 stderr 标识章节和不一致的证据标签

场景: 审稿提前或直接改稿会阻止最终状态
  测试: test_review_must_follow_automatic_gate_and_remain_read_only
  假设 三角色审稿在自动门禁通过之前执行，或审稿角色直接修改书稿
  当 执行最终验收检查
  那么 脚本退出码非 "0"
  并且 stderr 标识审稿顺序或只读约束违规

## 排除范围

- 英文版、纸书排版、EPUB 和精排 PDF。
- 修改、修复或发布 uutils/coreutils 代码。
- 读取 GNU coreutils 实现源码进行逐行对照。
- 重做论文实验、Ubuntu 安全审计或全套性能基准。
- 宣称本书方法是行业标准、形式化证明或适用于所有迁移项目。
