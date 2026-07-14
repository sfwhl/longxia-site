#!/bin/bash
# 同步 journal 和 skills-registry 到 src/ 目录
# 这个脚本确保 site/src/ 总是最新的，VitePress 不直接读 symlink 避免解析问题

set -e
SITE_DIR="$(cd "$(dirname "$0")" && pwd)"
LONGXIA_DIR="$(dirname "$SITE_DIR")"

echo "📦 同步内容..."

# 同步 journal
if [ -d "$LONGXIA_DIR/journal" ]; then
  mkdir -p "$SITE_DIR/src/journal"
  rsync -a --delete "$LONGXIA_DIR/journal/" "$SITE_DIR/src/journal/"
  echo "  ✅ journal/ → src/journal/ ($(find "$LONGXIA_DIR/journal" -type f | wc -l) 个文件)"
fi

# 同步 skills-registry
if [ -d "$LONGXIA_DIR/skills-registry" ]; then
  mkdir -p "$SITE_DIR/src/skills-registry"
  rsync -a --delete \
    --exclude='generate.py' \
    --exclude='__pycache__' \
    "$LONGXIA_DIR/skills-registry/" "$SITE_DIR/src/skills-registry/"
  echo "  ✅ skills-registry/ → src/skills-registry/"
fi

echo ""
echo "🚀 现在可以:"
echo "   npm run docs:dev      # 开发模式"
echo "   npm run docs:build    # 构建生产版本（输出到 .vitepress/dist/）"
