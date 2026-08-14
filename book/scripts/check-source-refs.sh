#!/bin/sh
set -eu

BOOK_ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
if [ "${1:-}" = "--root" ]; then
    BOOK_ROOT=$2
    shift 2
fi
SOURCE_ROOT=${BOOK_SOURCE_ROOT:-$(CDPATH= cd -- "$BOOK_ROOT/.." && pwd)}
SRC_DIR="$BOOK_ROOT/src"

fail() {
    echo "source-ref error: $*" >&2
    exit 1
}

[ -d "$SRC_DIR" ] || fail "missing src directory: $SRC_DIR"

if grep -R -n -E 'util/gnu-patches/|git\.savannah\.gnu\.org/(cgit|git)/coreutils|github\.com/coreutils/coreutils/(blob|raw)/|raw\.githubusercontent\.com/coreutils/coreutils/' "$SRC_DIR" --include='*.md' >/tmp/ai-rust-book-forbidden.$$ 2>/dev/null; then
    sed 's/^/forbidden GNU implementation source: /' /tmp/ai-rust-book-forbidden.$$ >&2
    rm -f /tmp/ai-rust-book-forbidden.$$
    exit 1
fi
rm -f /tmp/ai-rust-book-forbidden.$$

find "$SRC_DIR" -type f -name '*.md' -print | while IFS= read -r file; do
    sed -n 's/.*<!-- source: \([^ ][^ ]*\) -->.*/\1/p' "$file" | while IFS= read -r ref; do
        case "$ref" in
            /*|*..*) fail "invalid source reference in $file: $ref" ;;
        esac
        [ -f "$SOURCE_ROOT/$ref" ] || fail "invalid source reference in $file: $ref"
    done
done

echo 'PASS: publication source-reference scan'
