#!/bin/sh
set -eu

BOOK_ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
if [ "${1:-}" = "--root" ]; then
    BOOK_ROOT=$2
fi

fail() {
    echo "mermaid error: $*" >&2
    exit 1
}

find "$BOOK_ROOT/src" -type f -name '*.md' -print | while IFS= read -r file; do
    awk -v file="$file" '
        /^```mermaid[[:space:]]*$/ { if (inside) { print "nested Mermaid fence: " file > "/dev/stderr"; exit 2 } inside=1; diagrams++; next }
        /^```[[:space:]]*$/ && inside { inside=0; next }
        END { if (inside) { print "unclosed Mermaid fence: " file > "/dev/stderr"; exit 3 } }
    ' "$file" || fail "invalid Mermaid fence in $file"
done

echo 'PASS: Mermaid fences are balanced'
