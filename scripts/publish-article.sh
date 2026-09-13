#!/bin/bash
# 一键把 markdown 文章分发成多平台发布版本
# 用法: ./publish-article.sh <markdown 文件>

set -e
LONGXIA_DIR="$HOME/.hermes/longxia"

if [ -z "$1" ]; then
  echo "用法: $0 <markdown 文件>"
  echo ""
  echo "示例:"
  echo "  $0 ~/.hermes/longxia/articles/2026-07-15-harness-era.md"
  exit 1
fi

python3 "$LONGXIA_DIR/scripts/article_distribute.py" "$1"