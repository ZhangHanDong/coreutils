#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
SPEC_ROOT=${BOOK_CHAPTER_SPEC_ROOT:-"$SCRIPT_DIR/../specs"}

fail() {
    echo "chapter quality error: $*" >&2
    exit 1
}

[ "$#" -eq 1 ] || {
    echo "usage: $0 <chapter-path>" >&2
    exit 2
}

chapter=$1
case "$chapter" in
    util/gnu-patches/*|./util/gnu-patches/*|*/util/gnu-patches/*|gnu/*|./gnu/*|*/gnu/*)
        fail "refusing prohibited chapter path: $chapter"
        ;;
esac
[ -f "$chapter" ] || fail "missing chapter: $chapter"

chapter_name=$(basename "$chapter")
chapter_id=$(printf '%s\n' "$chapter_name" | sed -n 's/^ch\([0-9][0-9]\)\([-.].*\)\{0,1\}\.md$/\1/p')
[ -n "$chapter_id" ] || fail "cannot determine chapter number: $chapter"

set -- "$SPEC_ROOT"/ch"$chapter_id"-*.spec.md
[ "$#" -eq 1 ] && [ -f "$1" ] || fail "missing unique chapter spec for $chapter_name"
spec=$1

budget=$(sed -n 's/.*正文为 \([0-9,][0-9,]*\)–\([0-9,][0-9,]*\) 个中文字符.*/\1 \2/p' "$spec")
set -- $budget
[ "$#" -eq 2 ] || fail "missing character budget in $spec"
min_chars=$(printf '%s' "$1" | tr -d ',')
max_chars=$(printf '%s' "$2" | tr -d ',')

require_line() {
    marker=$1
    description=$2
    grep -Fqx "$marker" "$chapter" >/dev/null || fail "missing $description: $chapter"
}

grep -F '> **定位**' "$chapter" >/dev/null || fail "missing positioning anchor: $chapter"
grep -F '```mermaid' "$chapter" >/dev/null || fail "missing Mermaid diagram: $chapter"
primary_evidence_count=$(grep -Eo '\[E[1-3]-[A-Z0-9._-]+\]' "$chapter" | sort -u | wc -l | tr -d ' ')
[ "$primary_evidence_count" -ge 3 ] || fail "fewer than 3 primary evidence references: $chapter"
[ "$primary_evidence_count" -le 6 ] || fail "more than 6 primary evidence references: $chapter"
grep -F '<!-- source:' "$chapter" >/dev/null || fail "missing evidence comment: $chapter"
require_line '### 版本演化说明' 'version evolution note'
require_line '## 模式提炼' 'pattern extraction section'
require_line '## 局限' 'limitation section'
require_line '## 实践清单' 'actionable checklist'
grep -F 'arXiv:2608.07135' "$chapter" >/dev/null || fail "missing paper baseline: $chapter"
grep -F 'd8bee62c1ddc227d5e4385d80bbf6d7dee266a41' "$chapter" >/dev/null || fail "missing source baseline: $chapter"
grep -F '2026-08-14' "$chapter" >/dev/null || fail "missing verification date: $chapter"
require_line '## 完整工程案例' 'worked case section'
require_line '## 反例' 'counterexample section'
require_line '## 可复用工件' 'reusable artifact section'

exercise_count=$(awk '
    $0 == "## 练习" { inside = 1; next }
    inside && /^## / { exit }
    inside && /^[-*] / { count++ }
    END { print count + 0 }
' "$chapter")
[ "$exercise_count" -ge 3 ] || fail "fewer than 3 exercises: $chapter"

require_line '## 能证明什么／不能证明什么' 'proof boundary section'
grep -F '| 能证明什么 | 不能证明什么 |' "$chapter" >/dev/null || fail "missing proof boundary table: $chapter"
proof_boundary_rows=$(awk '
    $0 == "| 能证明什么 | 不能证明什么 |" { inside = 1; next }
    inside && /^## / { exit }
    inside && /^\|/ {
        row = $0
        gsub(/[|[:space:]:-]/, "", row)
        if (row != "") count++
    }
    END { print count + 0 }
' "$chapter")
[ "$proof_boundary_rows" -ge 1 ] || fail "missing substantive proof boundary row: $chapter"

chars=$(wc -m < "$chapter" | tr -d ' ')
[ "$chars" -ge "$min_chars" ] || fail "chapter below configured character budget ($chars < $min_chars): $chapter"
[ "$chars" -le "$max_chars" ] || fail "chapter above configured character budget ($chars > $max_chars): $chapter"

echo "PASS: chapter quality gate ($chapter_name, $min_chars-$max_chars)"
