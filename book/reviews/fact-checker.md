# 事实核查报告

日期：2026-08-15

角色：独立事实核查（只读）

最终结论：**PASS**

审阅覆盖论文 arXiv:2608.07135、固定源码基线 `d8bee62c1ddc227d5e4385d80bbf6d7dee266a41`、全书正文与附录，以及第 15 章引用的 Ubuntu 一手资料。审阅过程未读取 GNU 实现源码或 `util/gnu-patches/**`。

## 初审发现与处置

1. 论文架构事实与固定源码导航一度混用证据 ID。第 5 章现用 `[E1-ARCH]` 支持论文星形架构，用 `[E2-ORIENTATION]` 支持固定提交的 workspace 与目录边界。
2. 第 2 章曾把 `uufuzz` 的可选差分能力与 `fuzz_date` 的候选侧 fuzz 混写。正文现明确：固定快照的 `fuzz_date` 不运行参考实现；其他 target 才按各自 harness 接入差分。
3. 第 15 章曾把预发布说明、正式发行日和后续通知放在同一时间线上。正文现分别直链 Ubuntu 25.10 官方 schedule、正式公告和 `date` 通知，并区分事件日、发布日期与核验日。
4. 动态安全资料不再复制出同义证据 ID。安全文章由第 15 章正文直链；由生产事件提炼出的 shadow、canary、回退与安全因果边界明确归入 E4。
5. 本地论文路径不再承担可发布引用。第 2、3 章使用 `<!-- publication: arXiv:2608.07135 -->`；仓库源码引用固定到同一 commit。
6. E2 索引曾窄于正文实际引用范围；现已补齐 AI ownership、测试入口、CI 静态门禁、RustSec、uufuzz target 与源码导航的精确 locator。

## 最终核验

- Ubuntu 25.10 正式发行事件为 2025-10-09；2025-09-26 的 Foundations 文章仅作为发行前状态；2025-10-23 是 `date` 兼容问题通知日，不被写成事故起始日。
- Ubuntu 2026-04-22 总结支持“两阶段外部安全审计”、113 项发现、0.8.0 修复进展以及当时 `cp`、`mv`、`rm` 的 GNU 保留；正文未把这些快照外推成永久状态。
- `book/src` 中 46 个具体 Evidence ID 均有定义和实际引用；无未定义或重复定义。`E2-UUFUZZ-*`、`E4-*` 等索引通配写法不是新 ID。
- 论文首页的标题、作者和 `arXiv:2608.07135v1 [cs.SE] 7 Aug 2026` 与书稿元数据一致。
- `check-source-refs.sh --root book` 与 `check-book.sh --root book --pre-review` 均通过。

残余边界：Ubuntu 26.10、SRU、上游 issue 与官方页面会变化。更新核验日时必须重跑 E3 事实检查，不能只替换日期。
