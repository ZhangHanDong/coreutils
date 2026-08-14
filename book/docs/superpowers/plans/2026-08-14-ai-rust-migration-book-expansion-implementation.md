# AI Rust Migration Book Expansion Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Expand every chapter of the mdBook from a concise engineering handbook into a 25–30万-character, source-backed technical book, then verify and deploy the expanded edition.

**Architecture:** Keep the existing 16-chapter/five-part/six-appendix information architecture. Each chapter becomes a self-contained evidence unit with a concrete problem scene, source walkthrough, worked case, reusable artifact, AI task boundary, proof limits, exercises, and version note; shared definitions and long source excerpts stay canonical in one chapter and are cross-linked elsewhere.

**Tech Stack:** Markdown, mdBook 0.5.3, mdbook-mermaid 0.17.0, Bash quality gates, GitHub Actions, GitHub Pages.

## Global Constraints

- Output remains `/Users/zhangalex/Work/Projects/consult/coreutils/book`.
- Main text contains exactly 16 numbered chapters; no new numbered chapter is added.
- Total target is 25–30万 Chinese characters; chapter budgets are copied from `book/docs/superpowers/specs/2026-08-14-ai-rust-migration-book-expansion-design.md`.
- Evidence baseline remains arXiv:2608.07135 and uutils commit `d8bee62c1ddc227d5e4385d80bbf6d7dee266a41`; currentness cutoff is 2026-08-14.
- Read only permitted uutils source, tests, project documents, the supplied paper, and primary public sources.
- Never read, quote, or derive from GNU implementation source or `util/gnu-patches/**`.
- Do not modify uutils source, tests, Cargo manifests, or the supplied PDF.
- Every chapter must have 3–6 primary evidence references, a worked case, a counterexample, a reusable artifact, three exercises, at least one Mermaid diagram, a proof-boundary table, and a version evolution note.
- Every chapter must pass its isolated chapter gate before the next chapter is accepted.
- Full automatic gates run before the three read-only editorial reviews.
- `book/build/` remains generated and untracked.

## File Responsibility Map

- `book/docs/book-outline.md`: approved information architecture, chapter budgets, canonical evidence ownership, and cross-chapter case map.
- `book/specs/book.spec.md`: project-wide BDD acceptance contract.
- `book/specs/ch01-*.spec.md` … `book/specs/ch16-*.spec.md`: per-chapter budget and content contract.
- `book/scripts/check-chapter.sh`: isolated validation for a single chapter.
- `book/scripts/check-book.sh`: whole-book validation and review sequencing.
- `book/tests/test_book_quality.sh`: negative tests proving invalid books are rejected.
- `book/src/part*/ch*.md`: expanded chapter manuscripts.
- `book/src/preface.md`: reader preparation, reading paths, knowledge map, and book contract.
- `book/src/appendices/*.md`: reusable artifacts, three E2E traces, evidence index, glossary, and checklists.
- `book/reviews/*.md`: read-only review reports and issue disposition.
- `.github/workflows/deploy-ai-rust-book.yml`: build, gate, artifact upload, and Pages deployment.

---

### Task 1: Raise the writing contract and add an isolated chapter gate

**Files:**
- Modify: `book/docs/book-outline.md`
- Modify: `book/specs/book.spec.md`
- Modify: `book/specs/ch01-behavior-reconstruction.spec.md` through `book/specs/ch16-pipeline.spec.md`
- Create: `book/scripts/check-chapter.sh`
- Modify: `book/scripts/check-book.sh`
- Modify: `book/tests/test_book_quality.sh`

**Interfaces:**
- Consumes: approved budgets and chapter schema from the expansion design.
- Produces: `bash book/scripts/check-chapter.sh <chapter-path>` and a whole-book gate that enforces the expanded edition.

- [ ] **Step 1: Add negative tests for the expanded contract**

Add fixtures that reject a chapter below its configured minimum, a missing worked-case marker, fewer than three exercises, a missing proof-boundary section, and a missing reusable artifact.

- [ ] **Step 2: Run the quality test to verify the new tests fail**

Run: `bash book/tests/test_book_quality.sh`

Expected: non-zero until `check-chapter.sh` and the new checks exist.

- [ ] **Step 3: Implement the isolated chapter gate**

The script must accept exactly one chapter path, resolve that chapter's min/max budget from its spec, and validate positioning, evidence comments, Mermaid, worked case, counterexample, artifact, three exercises, proof boundary, and version note. It must never inspect prohibited paths.

- [ ] **Step 4: Update the book and chapter specs**

Copy every min/max budget exactly from the expansion design and add BDD scenarios for the new structural requirements. Update the outline's total target to 25–30万 characters and add the cross-chapter canonical evidence map.

- [ ] **Step 5: Run contract tests**

Run: `bash book/tests/test_book_quality.sh`

Expected: PASS for all negative gate cases.

- [ ] **Step 6: Commit the contract change**

Run: `git add book/docs/book-outline.md book/specs book/scripts/check-chapter.sh book/scripts/check-book.sh book/tests/test_book_quality.sh && git commit -m "docs: raise book expansion quality contract"`

### Task 2: Expand Chapter 1 — behavior reconstruction

**Files:**
- Modify: `book/src/part1/ch01-behavior-reconstruction.md`

**Interfaces:**
- Consumes: E2 goals, AI ownership rules, the paper's problem framing, and Chapter 1 budget 10,000–12,000 characters.
- Produces: canonical definitions for behavior reconstruction, compatibility surface, and migration failure taxonomy used by Chapters 3, 6, 13, and 16.

- [ ] **Step 1: Build the chapter evidence ledger**

Verify every existing source link at the fixed commit; assign canonical ownership to the behavior-surface model and failure taxonomy.

- [ ] **Step 2: Expand the manuscript**

Add a concrete translation-failure opening, a seven-dimension observable behavior model, five migration failure classes, a behavior inventory walkthrough, a Behavior Surface Worksheet artifact, proof limits, three exercises, and cross-links to Chapters 3 and 9.

- [ ] **Step 3: Validate Chapter 1**

Run: `bash book/scripts/check-chapter.sh book/src/part1/ch01-behavior-reconstruction.md`

Expected: PASS and 10,000–12,000 characters.

- [ ] **Step 4: Commit Chapter 1**

Run: `git add book/src/part1/ch01-behavior-reconstruction.md && git commit -m "docs: expand behavior reconstruction chapter"`

### Task 3: Expand Chapter 2 — uutils as evidence

**Files:**
- Modify: `book/src/part1/ch02-uutils-case.md`

**Interfaces:**
- Consumes: the supplied paper, workspace metadata, `src/uucore/src/lib/lib.rs`, multicall entry points, and fuzz layout.
- Produces: canonical uutils architecture and evidence-limit explanation referenced by the rest of the book.

- [ ] **Step 1: Re-verify paper and source claims**

Separate paper measurement facts from current repository facts; confirm workspace, utility, uucore, multicall, test, and fuzz paths without reading prohibited material.

- [ ] **Step 2: Expand the manuscript**

Add research-question framing, measurement-baseline interpretation, architecture tour, four utility difficulty classes, repository navigation walkthrough, evidence matrix, extrapolation counterexample, Repository Orientation Map artifact, exercises, and proof limits.

- [ ] **Step 3: Validate Chapter 2**

Run: `bash book/scripts/check-chapter.sh book/src/part1/ch02-uutils-case.md`

Expected: PASS and 13,000–15,000 characters.

- [ ] **Step 4: Commit Chapter 2**

Run: `git add book/src/part1/ch02-uutils-case.md && git commit -m "docs: deepen uutils evidence chapter"`

### Task 4: Expand Chapter 3 — executable behavior contracts

**Files:**
- Modify: `book/src/part1/ch03-behavior-contract.md`

**Interfaces:**
- Consumes: Chapter 1 behavior surface and uucore error compatibility evidence.
- Produces: canonical Behavior Contract schema used by Chapters 4, 8, 9, 12, and Appendix B.

- [ ] **Step 1: Verify contract-related evidence**

Confirm exit-status, diagnostic, path, environment, platform, and non-determinism claims against permitted source and primary specifications.

- [ ] **Step 2: Expand the manuscript**

Add a contract-miss incident, seven-field schema, stdout/stderr and byte/text distinctions, file-system side effects, locale/timezone handling, unknown-behavior risk ledger, contract review meeting, YAML contract artifact, counterexample, exercises, and proof limits.

- [ ] **Step 3: Validate and commit Chapter 3**

Run: `bash book/scripts/check-chapter.sh book/src/part1/ch03-behavior-contract.md`

Expected: PASS and 12,000–14,000 characters.

Run: `git add book/src/part1/ch03-behavior-contract.md && git commit -m "docs: expand executable behavior contracts"`

### Task 5: Expand Chapter 4 — clean-room context boundaries

**Files:**
- Modify: `book/src/part2/ch04-clean-room.md`

**Interfaces:**
- Consumes: `AGENTS.md`, `CONTRIBUTING.md`, and Chapter 3 contracts.
- Produces: canonical Context Manifest and provenance rules used by Chapters 6, 11, 12, and Appendix C.

- [ ] **Step 1: Verify policy evidence**

Re-read only allowed policy sections and confirm the difference among licensing, provenance, and Agent visibility boundaries.

- [ ] **Step 2: Expand the manuscript**

Add context-pollution scenarios, allowed/forbidden/derived/cache fields, task start/pause/close lifecycle, provenance ledger, leakage counterexample, Context Manifest artifact, human legal-review boundary, exercises, and proof limits.

- [ ] **Step 3: Validate and commit Chapter 4**

Run: `bash book/scripts/check-chapter.sh book/src/part2/ch04-clean-room.md`

Expected: PASS and 10,000–12,000 characters.

Run: `git add book/src/part2/ch04-clean-room.md && git commit -m "docs: expand clean-room context boundaries"`

### Task 6: Expand Chapter 5 — Rust migration skeleton

**Files:**
- Modify: `book/src/part2/ch05-rust-skeleton.md`

**Interfaces:**
- Consumes: workspace structure, uucore module boundaries, `UResult`, `UError`, `OsStr`, `Path`, cfg, and safety policy.
- Produces: canonical Rust skeleton and error-path model used by Chapters 7–10 and Appendix D.

- [ ] **Step 1: Verify source paths and snippets**

Confirm CLI entry flow, shared-library exports, error-to-exit mapping, path handling, feature gates, conditional compilation, and unsafe constraints at the fixed commit.

- [ ] **Step 2: Expand the manuscript**

Add shared-layer decision tree, CLI-to-exit control flow, non-UTF-8 path case, platform branch case, error text compatibility case, safe abstraction counterexample, Rust Skeleton Decision Record artifact, exercises, and proof limits.

- [ ] **Step 3: Validate and commit Chapter 5**

Run: `bash book/scripts/check-chapter.sh book/src/part2/ch05-rust-skeleton.md`

Expected: PASS and 13,000–15,000 characters.

Run: `git add book/src/part2/ch05-rust-skeleton.md && git commit -m "docs: deepen Rust migration skeleton"`

### Task 7: Expand Chapter 6 — Agent atomicity

**Files:**
- Modify: `book/src/part2/ch06-agent-atomicity.md`

**Interfaces:**
- Consumes: Chapter 3 contracts, Chapter 4 manifests, Chapter 5 skeleton, and repository contribution rules.
- Produces: canonical task-slicing and patch-atomicity rules used by Chapters 11–13 and Appendix B.

- [ ] **Step 1: Verify atomicity evidence**

Confirm small-patch, atomic-commit, AI contribution, and test requirements from allowed project documents.

- [ ] **Step 2: Expand the manuscript**

Add dependency-graph slicing, three slicing alternatives, a mixed mechanical/behavior change failure, task budgets, allowed-path selectors, stop conditions, cross-layer exception strategy, Atomic Change Card artifact, exercises, and proof limits.

- [ ] **Step 3: Validate and commit Chapter 6**

Run: `bash book/scripts/check-chapter.sh book/src/part2/ch06-agent-atomicity.md`

Expected: PASS and 10,000–12,000 characters.

Run: `git add book/src/part2/ch06-agent-atomicity.md && git commit -m "docs: expand Agent atomicity chapter"`

### Task 8: Expand Chapter 7 — static gates

**Files:**
- Modify: `book/src/part3/ch07-static-gates.md`

**Interfaces:**
- Consumes: Chapter 5 Rust skeleton and actual workspace tool configuration.
- Produces: canonical static-gate responsibility matrix used by Chapters 12, 13, and 16.

- [ ] **Step 1: Verify gate configuration**

Confirm rustfmt, rustc, Clippy, dependency policy, and security-scan entry points and do not claim a gate exists unless it is present at the baseline.

- [ ] **Step 2: Expand the manuscript**

Add gate layering, local-versus-workspace sequencing, cost model, conditional-code gap, lint exception lifecycle, dependency exception example, Static Gate Selector artifact, counterexample, exercises, and proof limits.

- [ ] **Step 3: Validate and commit Chapter 7**

Run: `bash book/scripts/check-chapter.sh book/src/part3/ch07-static-gates.md`

Expected: PASS and 12,000–14,000 characters.

Run: `git add book/src/part3/ch07-static-gates.md && git commit -m "docs: expand layered static gates"`

### Task 9: Expand Chapter 8 — test layers

**Files:**
- Modify: `book/src/part3/ch08-test-layers.md`

**Interfaces:**
- Consumes: Chapter 3 contracts, Chapter 7 static gates, utility tests, and external-suite policy.
- Produces: canonical test-layer model used by Chapters 9, 10, 13, and 14.

- [ ] **Step 1: Verify test architecture**

Confirm unit, process, integration, platform, and external compatibility test locations at the baseline.

- [ ] **Step 2: Expand the manuscript**

Add one behavior tested at multiple layers, fixture and temp-directory design, environment isolation, locale/permission/platform matrix, flaky-test triage, ownership rules, Test Layer Map artifact, counterexample, exercises, and proof limits.

- [ ] **Step 3: Validate and commit Chapter 8**

Run: `bash book/scripts/check-chapter.sh book/src/part3/ch08-test-layers.md`

Expected: PASS and 12,000–14,000 characters.

Run: `git add book/src/part3/ch08-test-layers.md && git commit -m "docs: expand migration test layers"`

### Task 10: Expand Chapter 9 — differential testing

**Files:**
- Modify: `book/src/part3/ch09-differential-testing.md`

**Interfaces:**
- Consumes: Chapter 3 contracts, Chapter 8 test isolation, and `fuzz/uufuzz/src/lib.rs` result model.
- Produces: canonical differential harness and normalization policy used by Chapters 10, 12, 13, and Appendix A.

- [ ] **Step 1: Verify uufuzz flow**

Confirm command execution, result capture, stdout/stderr/exit comparison, and allowed comparison modes at the fixed commit.

- [ ] **Step 2: Expand the manuscript**

Add oracle selection, filesystem outcome comparison, normalization danger, non-determinism ledger, allowed-difference review, end-to-end mismatch triage, Differential Run Record artifact, oracle-bug counterexample, exercises, and proof limits.

- [ ] **Step 3: Validate and commit Chapter 9**

Run: `bash book/scripts/check-chapter.sh book/src/part3/ch09-differential-testing.md`

Expected: PASS and 13,000–15,000 characters.

Run: `git add book/src/part3/ch09-differential-testing.md && git commit -m "docs: deepen differential testing chapter"`

### Task 11: Expand Chapter 10 — fuzz and regression assets

**Files:**
- Modify: `book/src/part3/ch10-fuzz-regression.md`

**Interfaces:**
- Consumes: Chapter 9 differential records and project rules requiring durable regression tests.
- Produces: canonical failure-lifecycle and regression-asset model used by Chapters 12, 13, and Appendix A.

- [ ] **Step 1: Verify fuzz and regression evidence**

Confirm input generation, comparison entry points, and regression-test requirements without claiming unsupported coverage.

- [ ] **Step 2: Expand the manuscript**

Add random versus grammar-aware generation, seed control, shrink strategy, environment capture, regression naming, Discover–Minimize–Codify–Repair–Verify ledger, missing-regression counterexample, Fuzz Failure Package artifact, exercises, and proof limits.

- [ ] **Step 3: Validate and commit Chapter 10**

Run: `bash book/scripts/check-chapter.sh book/src/part3/ch10-fuzz-regression.md`

Expected: PASS and 12,000–14,000 characters.

Run: `git add book/src/part3/ch10-fuzz-regression.md && git commit -m "docs: expand fuzz regression lifecycle"`

### Task 12: Expand Chapter 11 — human ownership

**Files:**
- Modify: `book/src/part4/ch11-human-owns-change.md`

**Interfaces:**
- Consumes: repository AI policy and Chapters 4, 6, 7–10.
- Produces: canonical responsibility matrix used by Chapters 12–16.

- [ ] **Step 1: Verify governance evidence**

Confirm human understanding, explanation, source, review, testing, and patch-scope requirements from allowed policy files.

- [ ] **Step 2: Expand the manuscript**

Add lifecycle RACI, same-model review blind spot, explain-back protocol, rejection criteria for incomprehensible patches, AI contribution statement, Review Ownership Record artifact, signature-without-evidence counterexample, exercises, and proof limits.

- [ ] **Step 3: Validate and commit Chapter 11**

Run: `bash book/scripts/check-chapter.sh book/src/part4/ch11-human-owns-change.md`

Expected: PASS and 10,000–12,000 characters.

Run: `git add book/src/part4/ch11-human-owns-change.md && git commit -m "docs: expand human ownership chapter"`

### Task 13: Expand Chapter 12 — Change Packages

**Files:**
- Modify: `book/src/part4/ch12-change-package.md`

**Interfaces:**
- Consumes: Chapters 3, 4, 6–11.
- Produces: canonical Change Package schema used by Chapters 13–16 and Appendix B.

- [ ] **Step 1: Define the complete package schema**

Map contract, provenance, diff, test evidence, differential evidence, risk, unexecuted checks, rollback, and human decision fields to their canonical chapters.

- [ ] **Step 2: Expand the manuscript**

Add human-readable and machine-readable layers, command receipts, log summaries, missing-check representation, review trace, a patch-only failure case, full Change Package artifact, exercises, and proof limits.

- [ ] **Step 3: Validate and commit Chapter 12**

Run: `bash book/scripts/check-chapter.sh book/src/part4/ch12-change-package.md`

Expected: PASS and 10,000–12,000 characters.

Run: `git add book/src/part4/ch12-change-package.md && git commit -m "docs: expand Change Package chapter"`

### Task 14: Expand Chapter 13 — Definition of Done

**Files:**
- Modify: `book/src/part4/ch13-definition-of-done.md`

**Interfaces:**
- Consumes: Chapters 7–12.
- Produces: canonical risk-tiered completion matrix used by Chapters 14–16 and Appendix E.

- [ ] **Step 1: Build the risk-to-gate matrix**

Define low, medium, and high risk using behavior surface, data mutation, platform spread, privilege, and rollback cost.

- [ ] **Step 2: Expand the manuscript**

Add three DoD profiles, machine versus human decisions, failure and exception lifecycle, compensating controls, expiry, evidence linkage, checklist-compliance counterexample, DoD Decision Record artifact, exercises, and proof limits.

- [ ] **Step 3: Validate and commit Chapter 13**

Run: `bash book/scripts/check-chapter.sh book/src/part4/ch13-definition-of-done.md`

Expected: PASS and 11,000–13,000 characters.

Run: `git add book/src/part4/ch13-definition-of-done.md && git commit -m "docs: expand migration Definition of Done"`

### Task 15: Expand Chapter 14 — staged rollout and rollback

**Files:**
- Modify: `book/src/part5/ch14-rollout-rollback.md`

**Interfaces:**
- Consumes: Chapter 13 risk gates and test evidence.
- Produces: canonical rollout state machine and rollback-readiness model used by Chapters 15, 16, and Appendix A.

- [ ] **Step 1: Verify deployment facts separately from method synthesis**

Keep sourced production facts in E3 and label rollout design as E4 unless directly supported by a primary source.

- [ ] **Step 2: Expand the manuscript**

Add shadow/canary/ramp/default states, read-only versus mutating-command strategies, compatibility/error/latency/resource metrics, kill switch, dual routing, rollback drill, direct-full-rollout counterexample, Rollout Readiness Record artifact, exercises, and proof limits.

- [ ] **Step 3: Validate and commit Chapter 14**

Run: `bash book/scripts/check-chapter.sh book/src/part5/ch14-rollout-rollback.md`

Expected: PASS and 12,000–14,000 characters.

Run: `git add book/src/part5/ch14-rollout-rollback.md && git commit -m "docs: expand rollout and rollback chapter"`

### Task 16: Expand Chapter 15 — Ubuntu production boundaries

**Files:**
- Modify: `book/src/part5/ch15-ubuntu-boundaries.md`

**Interfaces:**
- Consumes: the paper's historical baseline and verified primary Ubuntu/uutils production sources.
- Produces: canonical production timeline and method-correction analysis used by Chapter 16.

- [ ] **Step 1: Re-verify every production claim**

Use primary sources for dates, release status, audit findings, defaults, exceptions, and fallback decisions; explicitly separate event date from publication date.

- [ ] **Step 2: Expand the manuscript**

Add a dated timeline, paper-versus-production evidence table, `cp`/`mv`/`rm` risk analysis, memory-safety versus semantic-correctness distinction, production-feedback loop, overgeneralization counterexample, Production Evidence Ledger artifact, exercises, and proof limits.

- [ ] **Step 3: Validate and commit Chapter 15**

Run: `bash book/scripts/check-chapter.sh book/src/part5/ch15-ubuntu-boundaries.md`

Expected: PASS and 14,000–16,000 characters.

Run: `git add book/src/part5/ch15-ubuntu-boundaries.md && git commit -m "docs: deepen Ubuntu production boundaries"`

### Task 17: Expand Chapter 16 — executable migration pipeline

**Files:**
- Modify: `book/src/part5/ch16-pipeline.md`

**Interfaces:**
- Consumes: all canonical models from Chapters 1–15.
- Produces: ten-stage adoption pipeline, organizational roadmap, and final end-to-end case.

- [ ] **Step 1: Map every stage to canonical inputs and outputs**

For each stage identify owner, contract, artifact, gate, failure route, and next-stage entry condition without redefining earlier concepts.

- [ ] **Step 2: Expand the manuscript**

Add utility selection, migration ordering, shared-layer evolution, parallel work design, 30/60/90-day roadmap, team roles, compatibility/escape/rework/rollback metrics, full end-to-end migration case, pipeline-shortcut counterexample, Program Adoption Canvas artifact, exercises, and proof limits.

- [ ] **Step 3: Validate and commit Chapter 16**

Run: `bash book/scripts/check-chapter.sh book/src/part5/ch16-pipeline.md`

Expected: PASS and 13,000–15,000 characters.

Run: `git add book/src/part5/ch16-pipeline.md && git commit -m "docs: expand AI-native migration pipeline"`

### Task 18: Expand the preface and all six appendices

**Files:**
- Modify: `book/src/preface.md`
- Modify: `book/src/appendices/e2e-traces.md`
- Modify: `book/src/appendices/task-contract.md`
- Modify: `book/src/appendices/context-permissions.md`
- Modify: `book/src/appendices/rust-safety-profile.md`
- Modify: `book/src/appendices/dod-checklist.md`
- Modify: `book/src/appendices/evidence-index.md`

**Interfaces:**
- Consumes: final canonical definitions and artifacts from all 16 chapters.
- Produces: reader onboarding, three complete E2E traces, copyable templates, glossary, and bidirectional evidence index.

- [ ] **Step 1: Expand the preface**

Reach 8,000–10,000 characters with prerequisites, exclusions, three reading paths, knowledge map, evidence notation, source baseline, exercise conventions, and maintenance policy.

- [ ] **Step 2: Expand the E2E traces**

Each of three traces must span at least three chapters, include normal and failure branches, a Mermaid sequence diagram, artifact ledger, rollback point, and 4,000–5,000 characters.

- [ ] **Step 3: Expand reusable appendices**

Add low/medium/high-risk Task Contracts, a full Context Manifest lifecycle, path/error/unsafe/concurrency/platform safety profiles, three DoD levels with exception records, and a complete glossary/evidence/chapter reverse index.

- [ ] **Step 4: Validate appendices and build**

Run: `BOOK_SOURCE_ROOT=/Users/zhangalex/Work/Projects/consult/coreutils bash book/scripts/check-book.sh --root book`

Expected: full structural and evidence checks pass.

Run: `mdbook build book`

Expected: exit 0 and `book/build/index.html` exists.

- [ ] **Step 5: Commit the synthesis layer**

Run: `git add book/src/preface.md book/src/appendices && git commit -m "docs: expand preface and migration appendices"`

### Task 19: Cross-chapter deduplication and automated quality gate

**Files:**
- Modify: any `book/src/**/*.md` that fails the cross-chapter audit
- Modify: `book/reviews/automatic-gate.txt`

**Interfaces:**
- Consumes: the complete expanded manuscript.
- Produces: a mechanically clean candidate ready for independent review.

- [ ] **Step 1: Run the full gate**

Run: `bash book/tests/test_book_quality.sh`

Run: `bash book/tests/test_mdbook_build.sh`

Run: `BOOK_SOURCE_ROOT=/Users/zhangalex/Work/Projects/consult/coreutils bash book/scripts/check-book.sh --root book`

Expected: all commands exit 0.

- [ ] **Step 2: Audit duplication and cross-links**

Search long source excerpts, canonical definitions, and “详见第 N 章” links. Replace repeated explanations with chapter-specific cases or cross-links; verify every forward reference has a useful return path.

- [ ] **Step 3: Record the automatic gate**

Write exact commands, exit codes, manuscript character totals, per-chapter totals, Mermaid count, evidence reference count, and timestamp to `book/reviews/automatic-gate.txt`.

- [ ] **Step 4: Commit gate fixes**

Run: `git add book && git commit -m "docs: pass expanded book quality gate"`

### Task 20: Three-role read-only review and revision

**Files:**
- Modify: `book/reviews/fact-checker.md`
- Modify: `book/reviews/tech-reviewer.md`
- Modify: `book/reviews/structure-editor.md`
- Modify: `book/reviews/review-summary.md`
- Modify: manuscript files only when resolving reported issues

**Interfaces:**
- Consumes: automatic-gate-passing candidate.
- Produces: fact-checked, technically fair, structurally coherent manuscript with an issue disposition ledger.

- [ ] **Step 1: Launch exactly three read-only reviews in parallel**

Fact checker verifies every source claim and causal chain; technical reviewer checks Rust and production constraints; structure editor checks budget, repetition, chapter flow, artifacts, and exercises. Reviewers report only and do not edit the manuscript.

- [ ] **Step 2: Resolve findings by severity**

Fix P0 facts, P1 technical boundaries, P2 structure, then P3 wording. Record each finding, fix location, and disposition in `review-summary.md`.

- [ ] **Step 3: Re-run all gates**

Run the three Task 19 commands again after revisions.

Expected: all exit 0 and review summary reports no unresolved critical issue.

- [ ] **Step 4: Commit reviewed manuscript**

Run: `git add book && git commit -m "docs: finalize reviewed expanded edition"`

### Task 21: Visual QA, push, and GitHub Pages deployment

**Files:**
- Modify: `book/theme/book.css` only if visual defects require a scoped fix
- Modify: `.github/workflows/deploy-ai-rust-book.yml` only if the verified remote runner requires a compatibility fix

**Interfaces:**
- Consumes: reviewed manuscript and passing local build.
- Produces: public expanded edition on `https://zhanghandong.github.io/coreutils/`.

- [ ] **Step 1: Serve and inspect the book**

Run: `mdbook serve book --hostname 127.0.0.1 --port 3001`

Inspect the homepage, one chapter from each part, Appendix A, search, table of contents, Mermaid, code blocks, wide tables, dark theme, and print view. Record and fix only reproducible defects.

- [ ] **Step 2: Perform final local verification**

Run all Task 19 commands and `git status --short`.

Expected: gates pass; only the user-owned `docs/rust-coreutils.pdf` may remain untracked.

- [ ] **Step 3: Rebase or fast-forward safely against the target**

Run: `git fetch zhanghandong main`

Expected: local history can be pushed without force. If the target advanced, integrate with a normal rebase or merge after preserving all user changes.

- [ ] **Step 4: Push the expanded edition**

Run: `git push zhanghandong HEAD:main`

Expected: fast-forward push succeeds.

- [ ] **Step 5: Enable Pages and watch the deployment**

Set the repository Pages source to GitHub Actions using an authenticated GitHub session, then monitor `Deploy AI Rust Migration Book` through build and deploy jobs.

Expected: workflow conclusion `success`; Pages reports build type `workflow`.

- [ ] **Step 6: Verify the public site**

Request `https://zhanghandong.github.io/coreutils/` and representative chapter URLs.

Expected: HTTP 200, expanded title page, working navigation, and rendered Mermaid diagrams.
