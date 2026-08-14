#!/bin/sh
set -eu

BOOK_ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
CHECK="$BOOK_ROOT/scripts/check-book.sh"
CHAPTER_CHECK="$BOOK_ROOT/scripts/check-chapter.sh"

if [ ! -x "$CHECK" ]; then
    echo "RED: missing executable quality gate: $CHECK" >&2
    exit 1
fi

TMP_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/ai-rust-book-test.XXXXXX")
trap 'rm -rf "$TMP_ROOT"' EXIT HUP INT TERM

make_fixture() {
    fixture=$1
    mkdir -p "$fixture/src/chapters" "$fixture/src/appendices" "$fixture/reviews" "$fixture/source-repo" "$fixture/specs"
    cp "$BOOK_ROOT"/specs/ch*.spec.md "$fixture/specs/"
    : > "$fixture/source-repo/AGENTS.md"
    {
        echo '# Summary'
        echo
        echo '- [前言](preface.md)'
        i=1
        while [ "$i" -le 16 ]; do
            printf '%s\n' "- [第 $i 章](chapters/ch$(printf '%02d' "$i").md)"
            i=$((i + 1))
        done
        i=1
        while [ "$i" -le 6 ]; do
            printf '%s\n' "- [附录 $i](appendices/app$i.md)"
            i=$((i + 1))
        done
    } > "$fixture/src/SUMMARY.md"
    {
        echo '# 前言'
        awk 'BEGIN { for (n = 0; n < 9000; n++) printf "x"; print "" }'
    } > "$fixture/src/preface.md"
    i=1
    while [ "$i" -le 16 ]; do
        chapter="$fixture/src/chapters/ch$(printf '%02d' "$i").md"
        {
            printf '# 第 %s 章\n\n' "$i"
            echo '> **定位**：测试章节。前置依赖：无。适用场景：质量门禁测试。'
            echo
            echo '```mermaid'
            echo 'flowchart LR'
            echo '    A --> B'
            echo '```'
            echo
            echo '[E1-PAPER] [E2-SOURCE] [E2-TEST] [E4-SYNTHESIS]'
            echo '<!-- source: AGENTS.md -->'
            echo
            echo '## 模式提炼'
            echo '模式名：测试模式；问题：质量门禁；前提：夹具有效；失效边界：不证明正文事实。'
            echo
            echo '## 完整工程案例'
            echo '输入、契约、决策、失败诊断和验证结果构成一个可复查的案例。'
            echo
            echo '## 反例'
            echo '该反例说明只通过静态检查不能证明行为兼容。'
            echo
            echo '## 可复用工件'
            echo '工件：可复制的行为契约模板。'
            echo
            echo '## 练习'
            echo '- 设计一个最小行为验证。'
            echo '- 为反例添加回归证据。'
            echo '- 说明验证的环境边界。'
            echo
            echo '## 能证明什么／不能证明什么'
            echo '| 能证明什么 | 不能证明什么 |'
            echo '| --- | --- |'
            echo '| 门禁夹具结构完整 | 正文事实真实 |'
            echo
            echo '## 局限'
            echo '这是门禁夹具。'
            echo
            echo '## 实践清单'
            echo '- [ ] 检查。'
            echo
            echo '### 版本演化说明'
            echo '论文：arXiv:2608.07135；源码：d8bee62c1ddc227d5e4385d80bbf6d7dee266a41；核验日期：2026-08-14。'
            case "$i" in
                1|4|6|11|12) filler=10500 ;;
                2|5|9|16) filler=13500 ;;
                3|7|8|10|14) filler=12500 ;;
                13) filler=11500 ;;
                15) filler=14500 ;;
            esac
            awk -v count="$filler" 'BEGIN { for (n = 0; n < count; n++) printf "x"; print "" }'
        } > "$chapter"
        i=$((i + 1))
    done
    i=1
    while [ "$i" -le 6 ]; do
        {
            printf '# 附录 %s\n' "$i"
            awk 'BEGIN { for (n = 0; n < 8500; n++) printf "x"; print "" }'
        } > "$fixture/src/appendices/app$i.md"
        i=$((i + 1))
    done
    : > "$fixture/reviews/automatic-gate.txt"
    : > "$fixture/reviews/fact-checker.md"
    : > "$fixture/reviews/tech-reviewer.md"
    : > "$fixture/reviews/structure-editor.md"
    : > "$fixture/reviews/review-summary.md"
}

expect_fail() {
    name=$1
    pattern=$2
    fixture=$3
    stdout="$TMP_ROOT/$name.stdout"
    stderr="$TMP_ROOT/$name.stderr"
    if BOOK_SOURCE_ROOT="$fixture/source-repo" BOOK_MIN_CHARS=1 BOOK_MAX_CHARS=20000 "$CHECK" --root "$fixture" >"$stdout" 2>"$stderr"; then
        echo "FAIL: $name unexpectedly passed" >&2
        exit 1
    fi
    if ! grep -F "$pattern" "$stderr" >/dev/null; then
        echo "FAIL: $name did not report expected pattern: $pattern" >&2
        sed -n '1,120p' "$stderr" >&2
        exit 1
    fi
}

expect_chapter_fail() {
    name=$1
    pattern=$2
    chapter=$3
    stderr="$TMP_ROOT/$name.stderr"
    if "$CHAPTER_CHECK" "$chapter" >/dev/null 2>"$stderr"; then
        echo "FAIL: $name unexpectedly passed" >&2
        exit 1
    fi
    if ! grep -F "$pattern" "$stderr" >/dev/null; then
        echo "FAIL: $name did not report expected pattern: $pattern" >&2
        sed -n '1,120p' "$stderr" >&2
        exit 1
    fi
}

valid="$TMP_ROOT/valid"
make_fixture "$valid"
BOOK_SOURCE_ROOT="$valid/source-repo" BOOK_MIN_CHARS=1 BOOK_MAX_CHARS=20000 "$CHECK" --root "$valid" >/dev/null

expect_chapter_fail relative-gnu-patches 'refusing prohibited chapter path' 'util/gnu-patches/not-a-chapter.md'
expect_chapter_fail relative-gnu-directory 'refusing prohibited chapter path' 'gnu/not-a-chapter.md'
expect_chapter_fail absolute-gnu-patches 'refusing prohibited chapter path' '/tmp/util/gnu-patches/not-a-chapter.md'
expect_chapter_fail absolute-gnu-directory 'refusing prohibited chapter path' '/tmp/gnu/not-a-chapter.md'

root_specs="$TMP_ROOT/root-specs"
make_fixture "$root_specs"
sed -i '' 's/10,000–12,000/1–2/' "$root_specs/specs/ch01-behavior-reconstruction.spec.md"
expect_fail root-specific-spec 'chapter above configured character budget' "$root_specs"

pre_review="$TMP_ROOT/pre-review"
make_fixture "$pre_review"
rm "$pre_review/reviews/automatic-gate.txt"
rm "$pre_review/reviews/fact-checker.md"
rm "$pre_review/reviews/tech-reviewer.md"
rm "$pre_review/reviews/structure-editor.md"
rm "$pre_review/reviews/review-summary.md"
BOOK_SOURCE_ROOT="$pre_review/source-repo" BOOK_MIN_CHARS=1 BOOK_MAX_CHARS=20000 "$CHECK" --root "$pre_review" --pre-review >/dev/null

missing="$TMP_ROOT/missing"
make_fixture "$missing"
rm "$missing/src/chapters/ch08.md"
expect_fail missing-chapter 'missing SUMMARY target' "$missing"

forbidden="$TMP_ROOT/forbidden"
make_fixture "$forbidden"
echo 'util/gnu-patches/example.patch' >> "$forbidden/src/chapters/ch04.md"
expect_fail forbidden-source 'forbidden GNU implementation source' "$forbidden"

forbidden_url="$TMP_ROOT/forbidden-url"
make_fixture "$forbidden_url"
echo 'https://github.com/coreutils/coreutils/blob/master/src/cp.c' >> "$forbidden_url/src/chapters/ch04.md"
expect_fail forbidden-source-url 'forbidden GNU implementation source' "$forbidden_url"

placeholder="$TMP_ROOT/placeholder"
make_fixture "$placeholder"
echo 'TODO: write later' >> "$placeholder/src/chapters/ch07.md"
expect_fail placeholder 'placeholder content' "$placeholder"

missing_pattern="$TMP_ROOT/missing-pattern"
make_fixture "$missing_pattern"
sed -i '' '/^## 模式提炼$/,/^## 局限$/{ /^## 局限$/!d; }' "$missing_pattern/src/chapters/ch06.md"
expect_fail missing-pattern 'missing pattern extraction section' "$missing_pattern"

invalid_ref="$TMP_ROOT/invalid-ref"
make_fixture "$invalid_ref"
echo '<!-- source: src/does-not-exist.rs -->' >> "$invalid_ref/src/chapters/ch09.md"
expect_fail invalid-source-reference 'invalid source reference' "$invalid_ref"

below_budget="$TMP_ROOT/below-budget"
make_fixture "$below_budget"
sed -i '' 's/x//g' "$below_budget/src/chapters/ch01.md"
expect_fail below-budget 'chapter below configured character budget' "$below_budget"

missing_worked_case="$TMP_ROOT/missing-worked-case"
make_fixture "$missing_worked_case"
sed -i '' '/^## 完整工程案例$/,/^## 反例$/{ /^## 反例$/!d; }' "$missing_worked_case/src/chapters/ch02.md"
expect_fail missing-worked-case 'missing worked case section' "$missing_worked_case"

too_few_exercises="$TMP_ROOT/too-few-exercises"
make_fixture "$too_few_exercises"
sed -i '' '/^- 为反例添加回归证据。$/d; /^- 说明验证的环境边界。$/d' "$too_few_exercises/src/chapters/ch03.md"
expect_fail too-few-exercises 'fewer than 3 exercises' "$too_few_exercises"

missing_proof_boundary="$TMP_ROOT/missing-proof-boundary"
make_fixture "$missing_proof_boundary"
sed -i '' '/^## 能证明什么／不能证明什么$/,/^## 局限$/{ /^## 局限$/!d; }' "$missing_proof_boundary/src/chapters/ch04.md"
expect_fail missing-proof-boundary 'missing proof boundary section' "$missing_proof_boundary"

missing_artifact="$TMP_ROOT/missing-artifact"
make_fixture "$missing_artifact"
sed -i '' '/^## 可复用工件$/,/^## 练习$/{ /^## 练习$/!d; }' "$missing_artifact/src/chapters/ch05.md"
expect_fail missing-artifact 'missing reusable artifact section' "$missing_artifact"

missing_counterexample="$TMP_ROOT/missing-counterexample"
make_fixture "$missing_counterexample"
sed -i '' '/^## 反例$/,/^## 可复用工件$/{ /^## 可复用工件$/!d; }' "$missing_counterexample/src/chapters/ch06.md"
expect_fail missing-counterexample 'missing counterexample section' "$missing_counterexample"

missing_evidence_comment="$TMP_ROOT/missing-evidence-comment"
make_fixture "$missing_evidence_comment"
sed -i '' '/^<!-- source: AGENTS.md -->$/d' "$missing_evidence_comment/src/chapters/ch07.md"
expect_fail missing-evidence-comment 'missing evidence comment' "$missing_evidence_comment"

missing_proof_table_row="$TMP_ROOT/missing-proof-table-row"
make_fixture "$missing_proof_table_row"
sed -i '' '/^| 门禁夹具结构完整 | 正文事实真实 |$/d' "$missing_proof_table_row/src/chapters/ch08.md"
expect_fail missing-proof-table-row 'missing substantive proof boundary row' "$missing_proof_table_row"

too_few_primary_evidence="$TMP_ROOT/too-few-primary-evidence"
make_fixture "$too_few_primary_evidence"
sed -i '' 's/\[E2-TEST\] //' "$too_few_primary_evidence/src/chapters/ch09.md"
expect_fail too-few-primary-evidence 'fewer than 3 primary evidence references' "$too_few_primary_evidence"

e4_only_evidence="$TMP_ROOT/e4-only-evidence"
make_fixture "$e4_only_evidence"
sed -i '' 's/\[E1-PAPER\] \[E2-SOURCE\] \[E2-TEST\] \[E4-SYNTHESIS\]/[E4-ONE] [E4-TWO] [E4-THREE]/' "$e4_only_evidence/src/chapters/ch10.md"
expect_fail e4-only-evidence 'fewer than 3 primary evidence references' "$e4_only_evidence"

too_many_primary_evidence="$TMP_ROOT/too-many-primary-evidence"
make_fixture "$too_many_primary_evidence"
sed -i '' 's/\[E1-PAPER\] \[E2-SOURCE\] \[E2-TEST\] \[E4-SYNTHESIS\]/[E1-PAPER] [E1-SECOND] [E1-THIRD] [E2-SOURCE] [E2-TEST] [E2-THIRD] [E3-PRODUCTION]/' "$too_many_primary_evidence/src/chapters/ch11.md"
expect_fail too-many-primary-evidence 'more than 6 primary evidence references' "$too_many_primary_evidence"

whole_book_under_budget="$TMP_ROOT/whole-book-under-budget"
make_fixture "$whole_book_under_budget"
sed -i '' 's/x//g' "$whole_book_under_budget/src/preface.md" "$whole_book_under_budget/src/appendices"/*.md
expect_fail whole-book-under-budget 'book below configured character budget' "$whole_book_under_budget"

whole_book_over_budget="$TMP_ROOT/whole-book-over-budget"
make_fixture "$whole_book_over_budget"
awk 'BEGIN { for (n = 0; n < 60000; n++) printf "x"; print "" }' >> "$whole_book_over_budget/src/preface.md"
expect_fail whole-book-over-budget 'book above configured character budget' "$whole_book_over_budget"

reviews="$TMP_ROOT/reviews"
make_fixture "$reviews"
rm "$reviews/reviews/tech-reviewer.md"
expect_fail incomplete-reviews 'missing review artifact' "$reviews"

echo 'PASS: book quality gate rejects all contract violations'
