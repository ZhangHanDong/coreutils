# 《AI Coding 时代的 Rust 软件迁移工程》成书设计

**日期：** 2026-08-14

**输出目录：** `/Users/zhangalex/Work/Projects/consult/coreutils/book`

**主要读者：** 中高级 Rust 工程师；Tech Lead、架构师与迁移负责人

**出版形态：** 可持续维护、可离线构建的中文 mdBook

## 1. 成书目标

本书以 uutils/coreutils 为贯穿案例，把 AI 辅助的软件迁移重新定义为“受约束的行为重建”，而不是源代码逐行翻译。最终产物既要解释论文和源码呈现的工程事实，也要提供可直接复用的迁移流程、任务契约、上下文边界、验证门禁和回滚清单。

全书不把 uutils 宣称为“AI Coding Rust 的行业最佳实践”。严谨定位是：从一个真实的大型 Rust 重实现案例、当前仓库的 AI 治理规则以及 Ubuntu 的生产迁移反馈中，提炼一套有证据、可反驳、可验证的迁移方法。

核心命题是：

> AI Coding 的关键不是教 Agent 一次写对代码，而是构造一个系统，使错误更难越过交付边界。

## 2. 证据与版本基线

全书使用四个互不混淆的证据层级：

| 等级 | 类型 | 用途 |
|---|---|---|
| E1 | 论文事实 | uutils 的设计原则、测试体系、比较数据和论文总结 |
| E2 | 源码事实 | 当前 Rust 仓库中的代码、测试、工具链和 AI 治理规则 |
| E3 | 生产事实 | Ubuntu 迁移、真实故障、安全审计、监控与回退机制 |
| E4 | 方法提炼 | 本书基于 E1-E3 得出的工程模型、规则与模板 |

基线固定如下：

- 论文：*Rust Coreutils: Rebuilding Unix Foundations in a Modern Language*，arXiv:2608.07135。
- 论文测量：按论文声明，GNU coreutils 9.9 与 uutils 0.4.0。
- 本地源码：uutils/coreutils commit `d8bee62c1ddc227d5e4385d80bbf6d7dee266a41`，描述版本 `0.10.0-120-gd8bee62c1`。
- 当前性核验截止日：2026-08-14。

每章都声明分析基线与当前性边界。论文中的历史数据不使用当前仓库数据回填；论文之后发生的 Ubuntu 安全审计和部分 GNU 回退被明确标记为后续生产证据。

## 3. Clean-room 边界

本书只读取和引用：

- 用户提供的论文；
- uutils/coreutils 的 MIT 许可源码、测试和项目文档；
- POSIX、Rust、Ubuntu、uutils 等项目的一手公开资料；
- GNU coreutils 用户手册、黑盒可观察行为和论文已公开的比较结果。

本书禁止读取、复制或派生自 GNU coreutils GPLv3 实现源码的代码、辅助结构、注释、测试夹具或表达。不得为了举例打开 `util/gnu-patches/**` 中可能包含实现派生内容的文件。书中代码片段来自 uutils Rust 源码；规范性示例必须标记为本书示例。

## 4. 信息架构

### 前言

- 阅读准备与非前置知识
- 三条阅读路径：实现者、迁移负责人、AI 工程治理者
- 证据等级、源码定位和版本标记
- 全书知识地图

### 第一部分：重新定义迁移问题

1. 从代码翻译到行为重建
2. uutils：一个基础软件重实现样本
3. 兼容性不是功能列表，而是行为契约

### 第二部分：约束 Agent 的搜索空间

4. Clean Room 与 Agent Context Boundary
5. 用 Rust 建立迁移骨架
6. Agent Atomicity：小任务、小补丁、单一行为意图

### 第三部分：建立可验证闭环

7. rustc、Clippy、rustfmt 与依赖门禁
8. 单元测试、集成测试与外部兼容测试
9. Differential Testing：把旧实现变成 oracle
10. Fuzz、失败最小化与永久回归测试

### 第四部分：治理 AI 生成的变更

11. Human Owns the Change
12. 从 Patch 到 Change Package
13. AI Migration Definition of Done

### 第五部分：进入真实生产环境

14. Shadow、Canary、监控与回滚
15. Ubuntu 部署、安全审计与方法边界
16. AI-Native Rust Migration Pipeline

### 附录

- 附录 A：三条跨章节 E2E 迁移轨迹
- 附录 B：迁移 Task Contract 模板
- 附录 C：Agent 上下文许可清单
- 附录 D：Rust Safety Profile
- 附录 E：Definition of Done 检查表
- 附录 F：证据索引、术语表与参考资料

## 5. 章节契约

每个正文章必须包含：

1. `> **定位**`：核心问题、前置章节和适用场景。
2. 为什么这很重要：把本章放回迁移主线。
3. 源码与事实证据：至少三处一手证据引用。
4. 核心机制图：至少一张语义有效、可渲染的 Mermaid 图。
5. 模式提炼：问题、机制、适用前提和失效边界。
6. 实践清单：读者能够执行或检查的动作。
7. 反例或局限：明确 Rust、AI 或测试不能自动解决的部分。
8. `### 版本演化说明`：论文基线、源码基线和核验日期。

同一段源码超过三行时，只在一个规范章节完整引用；其他章节使用“详见第 N 章”交叉引用。所有代码块必须直接支撑论证。

## 6. 篇幅与深度预算

- 16 个正文章，每章 3,500-5,500 个中文字符。
- 前言与六个附录合计 18,000-25,000 个中文字符。
- 全书目标 80,000-110,000 个中文字符。
- 每个主要论点分析四层：现象、根因、约束机制、生产边界。
- 三条 E2E 轨迹每条连接至少三个章节，并包含一张 Mermaid sequence diagram。

篇幅以论证闭合为先，不通过重复概念、堆叠代码或改写同一证据扩充字数。

## 7. mdBook 工程结构

```text
book/
├── book.toml
├── README.md
├── specs/
│   ├── book.spec.md
│   └── ch01-...ch16-*.spec.md
├── scripts/
│   ├── check-book.sh
│   ├── check-source-refs.sh
│   └── check-mermaid.sh
├── src/
│   ├── SUMMARY.md
│   ├── preface.md
│   ├── part1/
│   ├── part2/
│   ├── part3/
│   ├── part4/
│   ├── part5/
│   └── appendices/
├── theme/
│   ├── book.css
│   └── head.hbs
└── book/                 # mdbook build 输出，生成后存在
```

`mdbook-mermaid` 作为预处理器；构建不依赖在线脚本。自定义 CSS 只调整中文排版、证据标签、表格、提示块和打印可读性，不改变 mdBook 的导航语义。

## 8. 引用方式

源码引用统一写成：

```text
uutils/coreutils@d8bee62c: AGENTS.md:7-23
```

并链接到对应 GitHub commit permalink。每章末尾列出“本章证据”，区分论文页码、源码路径、官方生产资料与本书推导。

引用论文时以概括为主，不长篇逐字摘录。所有外部事实链接到一手来源；无法由一手来源确认的内容不写成确定事实。

## 9. 质量门禁

自动检查在三角色审稿之前运行：

- `mdbook build` 成功；
- `SUMMARY.md` 中 16 个正文章和六个附录全部可达；
- 每章存在定位块、Mermaid、至少三处证据引用和版本演化说明；
- 所有本地源码路径存在，GitHub permalink 使用固定 commit；
- Mermaid 预处理与渲染成功；
- 不存在 `TODO`、`TBD`、空章节或占位语句；
- 交叉引用章节真实存在且格式统一；
- 不引用 GNU 实现源码或 `util/gnu-patches/**`；
- 字数落在批准预算内。

自动门禁通过后，启动三个只读审稿角色：

- fact-checker：事实、版本、来源、源码定位和因果链；
- tech-reviewer：Rust、公平性、生产约束、模板可执行性；
- structure-editor：重复论点、章节主线、图表作用和措辞。

审稿问题按事实错误、技术边界、结构和措辞顺序修订。所有问题和处理结果记录在 `reviews/review-summary.md`。

## 10. 验收结果

完成状态必须同时满足：

- 源文件位于批准的输出目录；
- `mdbook build` 返回 0；
- 自动质量脚本返回 0；
- 三角色审稿已经完成，关键问题全部解决或以明确理由记录；
- 构建后的首页、至少五个代表章节和附录在浏览器中可读；
- 最终交付包含源码、构建产物、规格、检查脚本和审稿摘要。

## 11. 排除范围

第一版不包含英文翻译、出版社纸书排版、EPUB/PDF 精排、GNU 实现源码分析、对 uutils 代码的功能修改、性能基准复现或 Ubuntu 安全审计的重新执行。它们可以成为后续独立项目，不阻塞本版 mdBook。
