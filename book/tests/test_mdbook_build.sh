#!/bin/sh
set -eu

BOOK_ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
BUILD_DIR=$(mktemp -d "${TMPDIR:-/tmp}/ai-rust-mdbook-build.XXXXXX")
trap 'rm -rf "$BUILD_DIR"' EXIT HUP INT TERM

mdbook build "$BOOK_ROOT" --dest-dir "$BUILD_DIR"

test -f "$BUILD_DIR/index.html"
test -f "$BUILD_DIR/part5/ch16-pipeline.html"
test -f "$BUILD_DIR/appendices/evidence-index.html"
grep -F 'AI Coding 时代的 Rust 软件迁移工程' "$BUILD_DIR/index.html" >/dev/null
grep -F 'class="mermaid"' "$BUILD_DIR/index.html" >/dev/null
grep -E 'mermaid-[[:xdigit:]]+\.min\.js' "$BUILD_DIR/index.html" >/dev/null
grep -F '?.addEventListener' "$BOOK_ROOT/mermaid-init.js" >/dev/null

echo 'PASS: mdBook renders the complete manuscript'
