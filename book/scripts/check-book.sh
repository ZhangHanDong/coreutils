#!/bin/sh
set -eu

BOOK_ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
CHAPTER_CHECK="$SCRIPT_DIR/check-chapter.sh"
MODE=full
PART_FILTER=

while [ "$#" -gt 0 ]; do
    case "$1" in
        --root) BOOK_ROOT=$2; shift 2 ;;
        --draft) MODE=draft; shift ;;
        --pre-review) MODE=pre-review; shift ;;
        --chapters) PART_FILTER=$2; shift 2 ;;
        *) echo "book quality error: unknown argument: $1" >&2; exit 2 ;;
    esac
done

SRC_DIR="$BOOK_ROOT/src"
SUMMARY="$SRC_DIR/SUMMARY.md"

fail() {
    echo "book quality error: $*" >&2
    exit 1
}

[ -f "$SUMMARY" ] || fail "missing SUMMARY.md"
[ -x "$CHAPTER_CHECK" ] || fail "missing executable chapter quality gate: $CHAPTER_CHECK"

summary_targets() {
    sed -n 's/.*](\([^)]*\.md\)).*/\1/p' "$SUMMARY"
}

if [ "$MODE" != draft ]; then
    chapter_count=$(grep -Eo '\([^)]*ch[0-9][0-9][^)]*\.md\)' "$SUMMARY" | wc -l | tr -d ' ')
    [ "$chapter_count" -eq 16 ] || fail "expected 16 numbered chapters, found $chapter_count"
    appendix_count=$(grep -c '^- \[附录 ' "$SUMMARY" || true)
    [ "$appendix_count" -eq 6 ] || fail "expected 6 appendices, found $appendix_count"
    preface_count=$(grep -c '^- \[前言\]' "$SUMMARY" || true)
    [ "$preface_count" -eq 1 ] || fail "expected one preface, found $preface_count"

    summary_targets | while IFS= read -r target; do
        [ -f "$SRC_DIR/$target" ] || fail "missing SUMMARY target: $target"
    done
fi

chapters=$(summary_targets | grep -E '(^|/)ch[0-9][0-9][^/]*\.md$' || true)
[ -n "$chapters" ] || fail "no numbered chapters in SUMMARY"

echo "$chapters" | while IFS= read -r target; do
    if [ -n "$PART_FILTER" ]; then
        case "$target" in
            *"$PART_FILTER"*) ;;
            *) continue ;;
        esac
    fi
    file="$SRC_DIR/$target"
    [ -f "$file" ] || {
        [ "$MODE" = draft ] && continue
        fail "missing SUMMARY target: $target"
    }
    BOOK_CHAPTER_SPEC_ROOT="$SCRIPT_DIR/../specs" "$CHAPTER_CHECK" "$file" >/dev/null
done

if grep -R -n -E '(^|[^A-Za-z])(TODO|TBD)([^A-Za-z]|$)|待补|占位文本' "$SRC_DIR" --include='*.md' >/tmp/ai-rust-book-placeholders.$$ 2>/dev/null; then
    sed 's/^/placeholder content: /' /tmp/ai-rust-book-placeholders.$$ >&2
    rm -f /tmp/ai-rust-book-placeholders.$$
    exit 1
fi
rm -f /tmp/ai-rust-book-placeholders.$$

"$(dirname "$0")/check-source-refs.sh" --root "$BOOK_ROOT" >/dev/null
"$(dirname "$0")/check-mermaid.sh" --root "$BOOK_ROOT" >/dev/null

if [ "$MODE" = full ]; then
    for artifact in automatic-gate.txt fact-checker.md tech-reviewer.md structure-editor.md review-summary.md; do
        [ -f "$BOOK_ROOT/reviews/$artifact" ] || fail "missing review artifact: $artifact"
    done
fi

echo "PASS: book quality gate ($MODE)"
