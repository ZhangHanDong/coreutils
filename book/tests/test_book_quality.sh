#!/bin/sh
set -eu

BOOK_ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
CHECK="$BOOK_ROOT/scripts/check-book.sh"

if [ ! -x "$CHECK" ]; then
    echo "RED: missing executable quality gate: $CHECK" >&2
    exit 1
fi

TMP_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/ai-rust-book-test.XXXXXX")
trap 'rm -rf "$TMP_ROOT"' EXIT HUP INT TERM

make_fixture() {
    fixture=$1
    mkdir -p "$fixture/src/chapters" "$fixture/src/appendices" "$fixture/reviews" "$fixture/source-repo"
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
    echo '# 前言' > "$fixture/src/preface.md"
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
            echo '[E1-PAPER] [E2-SOURCE] [E4-SYNTHESIS]'
            echo '<!-- source: AGENTS.md -->'
            echo
            echo '## 模式提炼'
            echo '模式名：测试模式；问题：质量门禁；前提：夹具有效；失效边界：不证明正文事实。'
            echo
            echo '## 局限'
            echo '这是门禁夹具。'
            echo
            echo '## 实践清单'
            echo '- [ ] 检查。'
            echo
            echo '### 版本演化说明'
            echo '论文：arXiv:2608.07135；源码：d8bee62c1ddc227d5e4385d80bbf6d7dee266a41；核验日期：2026-08-14。'
        } > "$chapter"
        i=$((i + 1))
    done
    i=1
    while [ "$i" -le 6 ]; do
        printf '# 附录 %s\n' "$i" > "$fixture/src/appendices/app$i.md"
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
    if BOOK_SOURCE_ROOT="$fixture/source-repo" BOOK_MIN_CHARS=1 "$CHECK" --root "$fixture" >"$stdout" 2>"$stderr"; then
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
BOOK_SOURCE_ROOT="$valid/source-repo" BOOK_MIN_CHARS=1 "$CHECK" --root "$valid" >/dev/null

pre_review="$TMP_ROOT/pre-review"
make_fixture "$pre_review"
rm "$pre_review/reviews/automatic-gate.txt"
rm "$pre_review/reviews/fact-checker.md"
rm "$pre_review/reviews/tech-reviewer.md"
rm "$pre_review/reviews/structure-editor.md"
rm "$pre_review/reviews/review-summary.md"
BOOK_SOURCE_ROOT="$pre_review/source-repo" BOOK_MIN_CHARS=1 "$CHECK" --root "$pre_review" --pre-review >/dev/null

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

reviews="$TMP_ROOT/reviews"
make_fixture "$reviews"
rm "$reviews/reviews/tech-reviewer.md"
expect_fail incomplete-reviews 'missing review artifact' "$reviews"

echo 'PASS: book quality gate rejects all contract violations'
