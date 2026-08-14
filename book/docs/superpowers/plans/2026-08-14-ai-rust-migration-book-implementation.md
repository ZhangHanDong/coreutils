# AI Rust Migration Book Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build and verify the complete Chinese mdBook 《AI Coding 时代的 Rust 软件迁移工程：从 uutils 提炼的可验证重写方法》 under `/Users/zhangalex/Work/Projects/consult/coreutils/book`.

**Architecture:** Treat the book as a source-governed artifact: a project contract and per-chapter specs define the content; an evidence atlas pins paper, source, and production claims; mechanical scripts check structure, clean-room boundaries, references, diagrams, and review records; mdBook renders the final site. The prose follows a five-part causal chain from behavior contracts through production rollback, with uutils as a recurring case rather than a universal prescription.

**Tech Stack:** Markdown, mdBook 0.5.3, mdbook-mermaid, POSIX shell checks, Mermaid, agent-spec 1.2.0.

## Global Constraints

- Modify only `/Users/zhangalex/Work/Projects/consult/coreutils/book/**`.
- Never read or cite GNU coreutils implementation source or `util/gnu-patches/**`.
- Paper baseline: arXiv:2608.07135; repository baseline: `d8bee62c1ddc227d5e4385d80bbf6d7dee266a41`; verification date: 2026-08-14.
- Produce exactly 16 numbered chapters, one preface, and six appendices.
- Each numbered chapter contains a positioning anchor, at least one Mermaid diagram, at least three evidence references, a limitation, an actionable checklist, and a version-evolution note.
- Run the automatic quality gate before exactly three read-only review agents.
- Do not commit or stage changes; the user owns Git integration.

---

### Task 1: Book Skeleton and Failure-First Quality Harness

**Files:**
- Create: `book/book.toml`
- Create: `book/src/SUMMARY.md`
- Create: `book/theme/book.css`
- Create: `book/tests/test_book_quality.sh`
- Create: `book/scripts/check-book.sh`
- Create: `book/scripts/check-source-refs.sh`
- Create: `book/scripts/check-mermaid.sh`

**Interfaces:**
- Consumes: `book/specs/book.spec.md`.
- Produces: `scripts/check-book.sh`, the single automatic gate used by later tasks.

- [ ] **Step 1: Write the failing shell contract test**

The test creates deliberately incomplete temporary book fixtures and requires the gate to reject a missing chapter, a forbidden GNU-source reference, a placeholder, an invalid source path, and incomplete reviews.

- [ ] **Step 2: Run the test to verify RED**

Run: `bash book/tests/test_book_quality.sh`

Expected: FAIL because `book/scripts/check-book.sh` does not exist.

- [ ] **Step 3: Create the minimal checks and mdBook configuration**

Implement deterministic checks with actionable `stderr` messages and `set -eu`. Configure `mdbook-mermaid` and the Chinese typography stylesheet.

- [ ] **Step 4: Run the test to verify GREEN**

Run: `bash book/tests/test_book_quality.sh`

Expected: PASS with all negative fixtures rejected for the intended reason.

### Task 2: Evidence Atlas, Outline, and Chapter Contracts

**Files:**
- Create: `book/docs/book-outline.md`
- Create: `book/src/evidence-policy.md`
- Create: `book/src/appendices/evidence-index.md`
- Create: `book/specs/ch01-*.spec.md` through `book/specs/ch16-*.spec.md`

**Interfaces:**
- Consumes: paper text, uutils source at the pinned commit, official Ubuntu and Rust sources.
- Produces: stable evidence IDs `E1-*`, `E2-*`, `E3-*`, `E4-*` and chapter acceptance budgets.

- [ ] **Step 1: Verify every planned local source path and line range**

Run focused `nl -ba` and `rg` queries only against MIT-licensed uutils files. Record exact paths and commit permalinks.

- [ ] **Step 2: Write the outline and evidence policy**

Define neighboring chapter dependencies, canonical locations for repeated source excerpts, evidence labels, and the distinction between source fact and synthesis.

- [ ] **Step 3: Write 16 chapter specs**

Each spec states intent, decisions, boundaries, character budget, evidence set, Mermaid requirement, limitation, and deterministic acceptance scenarios.

- [ ] **Step 4: Validate all specs**

Run: `for f in book/specs/ch*.spec.md; do agent-spec parse "$f"; agent-spec lint "$f" --min-score 0.7; done`

Expected: all specs parse with at least one scenario and meet the lint threshold.

### Task 3: Preface and Part I - Behavior Reconstruction

**Files:**
- Create: `book/src/preface.md`
- Create: `book/src/part1/ch01-behavior-reconstruction.md`
- Create: `book/src/part1/ch02-uutils-case.md`
- Create: `book/src/part1/ch03-behavior-contract.md`

**Interfaces:**
- Consumes: `E1-P1`, project history, compatibility goals, evidence policy.
- Produces: the book thesis, three reading paths, and the observable-behavior model used by all later chapters.

- [ ] **Step 1: Write the preface and knowledge map**
- [ ] **Step 2: Write Chapters 1-3 with source-backed Mermaid flows**
- [ ] **Step 3: Run chapter-local mechanical checks**

Run: `bash book/scripts/check-book.sh --draft --chapters part1`

Expected: the three completed chapters pass all applicable draft checks.

### Task 4: Part II - Constraining Agent Search

**Files:**
- Create: `book/src/part2/ch04-clean-room.md`
- Create: `book/src/part2/ch05-rust-skeleton.md`
- Create: `book/src/part2/ch06-agent-atomicity.md`

**Interfaces:**
- Consumes: AGENTS.md, CONTRIBUTING.md, Cargo workspace architecture, Rust safety rules.
- Produces: Agent Context Boundary, Rust migration skeleton, and Agent Atomicity patterns.

- [ ] **Step 1: Write Chapters 4-6**
- [ ] **Step 2: Check clean-room and source-reference constraints**

Run: `bash book/scripts/check-source-refs.sh`

Expected: no forbidden or unresolved source reference.

### Task 5: Part III - Verification Loop

**Files:**
- Create: `book/src/part3/ch07-static-gates.md`
- Create: `book/src/part3/ch08-test-layers.md`
- Create: `book/src/part3/ch09-differential-testing.md`
- Create: `book/src/part3/ch10-fuzz-regression.md`

**Interfaces:**
- Consumes: DEVELOPMENT.md, pre-commit configuration, deny.toml, integration tests, GNU external-suite runner, and uufuzz.
- Produces: a layered verification model and Discover-Minimize-Codify-Repair-Verify loop.

- [ ] **Step 1: Write Chapters 7-10**
- [ ] **Step 2: Validate diagrams and canonical excerpt ownership**

Run: `bash book/scripts/check-mermaid.sh && bash book/scripts/check-book.sh --draft --chapters part3`

Expected: all four chapters pass draft quality checks.

### Task 6: Part IV - Governing AI Changes

**Files:**
- Create: `book/src/part4/ch11-human-owns-change.md`
- Create: `book/src/part4/ch12-change-package.md`
- Create: `book/src/part4/ch13-definition-of-done.md`

**Interfaces:**
- Consumes: AI policy, contribution rules, testing and review requirements.
- Produces: responsibility matrix, Change Package schema, and executable Definition of Done.

- [ ] **Step 1: Write Chapters 11-13**
- [ ] **Step 2: Cross-check every governance claim against current source**

Expected: later AI policy is labeled E2 and never attributed to the paper.

### Task 7: Part V - Production Migration

**Files:**
- Create: `book/src/part5/ch14-rollout-rollback.md`
- Create: `book/src/part5/ch15-ubuntu-boundaries.md`
- Create: `book/src/part5/ch16-pipeline.md`

**Interfaces:**
- Consumes: paper operating-system integration section, Ubuntu 25.10 migration documents, 2025 date incident, 2026 audit update, and rollback packaging design.
- Produces: staged rollout model, counterexample-aware case analysis, and the complete migration pipeline.

- [ ] **Step 1: Write Chapters 14-16**
- [ ] **Step 2: Verify chronological and version separation**

Expected: the paper's success assessment, later audit findings, and current deployment state are all dated and not collapsed into one claim.

### Task 8: Appendices and Cross-Chapter Synthesis

**Files:**
- Create: `book/src/appendices/e2e-traces.md`
- Create: `book/src/appendices/task-contract.md`
- Create: `book/src/appendices/context-permissions.md`
- Create: `book/src/appendices/rust-safety-profile.md`
- Create: `book/src/appendices/dod-checklist.md`
- Complete: `book/src/appendices/evidence-index.md`

**Interfaces:**
- Consumes: all 16 chapters.
- Produces: three sequence-diagram E2E traces and reusable operational templates.

- [ ] **Step 1: Write three traces spanning three or more chapters each**
- [ ] **Step 2: Write the four reusable templates/checklists**
- [ ] **Step 3: Complete evidence index, glossary, and bibliography**

### Task 9: Automatic Quality Gate and mdBook Build

**Files:**
- Modify: any `book/**` file implicated by a gate failure.
- Create: `book/reviews/automatic-gate.txt`

**Interfaces:**
- Consumes: complete draft.
- Produces: machine-verifiable evidence that the draft is ready for human-style reviews.

- [ ] **Step 1: Run all contract tests**

Run: `bash book/tests/test_book_quality.sh`

- [ ] **Step 2: Run the complete automatic gate**

Run: `bash book/scripts/check-book.sh`

- [ ] **Step 3: Build mdBook**

Run: `mdbook build book`

Expected: all commands exit 0; record exact outputs in `reviews/automatic-gate.txt`.

### Task 10: Three-Role Review and Revision

**Files:**
- Create: `book/reviews/fact-checker.md`
- Create: `book/reviews/tech-reviewer.md`
- Create: `book/reviews/structure-editor.md`
- Create: `book/reviews/review-summary.md`
- Modify: affected manuscript files.

**Interfaces:**
- Consumes: draft after automatic gate.
- Produces: three independent read-only reports and resolved revision record.

- [ ] **Step 1: Spawn exactly three review agents in parallel**
- [ ] **Step 2: Prioritize and apply P0 factual, P1 technical, P2 structural, then P3 wording fixes**
- [ ] **Step 3: Write the review summary with issue counts and resolutions**
- [ ] **Step 4: Re-run the complete automatic gate and mdBook build**

### Task 11: Render Inspection and Completion Audit

**Files:**
- Modify: layout or content files implicated by inspection.

**Interfaces:**
- Consumes: final rendered site and project contract.
- Produces: requirement-by-requirement completion evidence.

- [ ] **Step 1: Inspect rendered homepage and at least five representative pages**
- [ ] **Step 2: Audit every requirement in `specs/book.spec.md` against current files and command output**
- [ ] **Step 3: Run fresh final verification**

Run: `bash book/tests/test_book_quality.sh && bash book/scripts/check-book.sh && mdbook build book`

Expected: exit 0 with no warnings that affect correctness or navigation.
