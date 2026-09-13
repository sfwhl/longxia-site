#!/bin/bash
# ============================================
#  本地部署脚本：build → 同步到 /var/www/
# ============================================
# 用法：~/.hermes/longxia/deploy-local.sh
#
# 流程：
#   1. cd site && npm run build
#   2. 同步到 /var/www/longxia-site/（caddy 服务目录）
#   3. （可选） git push 触发 GitHub 更新

set -e

LONGXIA_DIR="$HOME/.hermes/longxia"
SITE_DIR="$LONGXIA_DIR/site"
DEPLOY_DIR="/var/www/longxia-site"

echo "=========================================="
echo "  本地部署"
echo "  $(date '+%Y-%m-%d %H:%M:%S')"
echo "=========================================="
echo ""

# 第 1 步：build
echo "🔨 第 1 步：构建站点"
echo "----------------------------------------"
cd "$SITE_DIR"
# 用临时文件捕获 build 输出和退出码（避免 pipe 吞掉）
BUILD_LOG=$(mktemp)
if ! npm run docs:build > "$BUILD_LOG" 2>&1; then
  echo ""
  echo "  ❌ build 失败！跳过部署，保护现有网站不被清空"
  echo ""
  echo "  Build 输出（最后 8 行）:"
  tail -8 "$BUILD_LOG" | sed 's/^/    /'
  echo ""
  echo "  提示：先修 build 错误再重跑"
  rm -f "$BUILD_LOG"
  exit 1
fi
tail -8 "$BUILD_LOG"
rm -f "$BUILD_LOG"
echo ""

# 第 2 步：同步（build 成功后才执行）
echo "📦 第 2 步：同步到 $DEPLOY_DIR"
echo "----------------------------------------"
sudo rsync -a --delete \
  "$SITE_DIR/.vitepress/dist/" \
  "$DEPLOY_DIR/"

# 补全子目录的 index.html（VitePress 对子目录的 README.md 只生成 README.html，不生成 index.html）
# 这样 /skills-registry/ 这种路径才能直接访问
echo ""
echo "🔗 补全子目录 index.html（让 /foo/ 路径可访问）"
for readme in $(find "$DEPLOY_DIR" -name "README.html" -type f 2>/dev/null); do
  dir=$(dirname "$readme")
  if [ ! -f "$dir/index.html" ]; then
    sudo cp "$readme" "$dir/index.html"
    echo "  ✅ $dir/index.html"
  fi
done

FILE_COUNT=$(find "$DEPLOY_DIR" -type f | wc -l)
TOTAL_SIZE=$(du -sh "$DEPLOY_DIR" | awk '{print $1}')
echo "  ✅ $FILE_COUNT 个文件, 总大小 $TOTAL_SIZE"
echo ""

# 第 3 步：重启 Caddy（保险起见）
echo "🔄 第 3 步：通知 Caddy 重载配置"
echo "----------------------------------------"
sudo systemctl reload caddy 2>&1 | head -3
sleep 1
echo "  ✅ Caddy 已 reload"
echo ""

# 第 4 步：测试
echo "🌐 第 4 步：测试访问"
echo "----------------------------------------"
LOCAL_HTTP=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 http://localhost/)
PUB_HTTP=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 http://43.136.30.57/)
echo "  localhost     → HTTP $LOCAL_HTTP"
echo "  43.136.30.57  → HTTP $PUB_HTTP"
echo ""

echo "=========================================="
echo "  ✅ 部署完成"
echo "  🌐 访问: http://43.136.30.57/"
echo "=========================================="
