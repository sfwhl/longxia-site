#!/bin/bash
# ===================================================================
#  小龙的个人网站 - daily + deploy 一体化脚本
# ===================================================================
#
#  把 daily.sh + deploy-local.sh 串起来：
#    1. 拉微信读书笔记
#    2. 同步内容
#    3. 重新 build
#    4. 部署到本地
#    5. （可选）push 到 GitHub
#    6. （可选）跑健康检查
#
#  用法：
#    ~/.hermes/longxia/daily-deploy.sh              # 完整流程
#    ~/.hermes/longxia/daily-deploy.sh --no-git     # 不 push
#    ~/.hermes/longxia/daily-deploy.sh --check     # 部署后跑健康检查
#    ~/.hermes/longxia/daily-deploy.sh --deploy-only # 只部署（不拉不 build）
#
#  推荐 Cron（每天早上 8 点 + 晚上 8 点各一次）：
#    0 8,20 * * * cd ~/.hermes/longxia && ./daily-deploy.sh --check >> daily.log 2>&1
#
# ===================================================================

set -e

LONGXIA_DIR="$HOME/.hermes/longxia"
SITE_DIR="$LONGXIA_DIR/site"
LOG_PREFIX="[$(date '+%Y-%m-%d %H:%M:%S')]"

# 颜色
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# 参数解析
DO_GIT=true
DO_CHECK=false
DEPLOY_ONLY=false
for arg in "$@"; do
  case $arg in
    --no-git) DO_GIT=false ;;
    --check) DO_CHECK=true ;;
    --deploy-only) DEPLOY_ONLY=true ;;
    --help|-h)
      echo "用法: ./daily-deploy.sh [选项]"
      echo "  --no-git      不 push 到 GitHub"
      echo "  --check       部署后跑健康检查"
      echo "  --deploy-only 只部署（跳过 daily + build）"
      exit 0
      ;;
  esac
done

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  小龙的小站 - daily + deploy 一体化${NC}"
echo -e "${BLUE}  $LOG_PREFIX${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

# ========== 阶段 1: daily 同步 ==========
if [ "$DEPLOY_ONLY" = false ]; then
  echo -e "${YELLOW}📖 阶段 1: daily 同步（拉笔记 + 同步内容）${NC}"
  echo "----------------------------------------"
  "$LONGXIA_DIR/daily.sh" --no-weread 2>&1 | tail -15 || {
    echo -e "${RED}❌ daily 阶段失败，继续 deploy${NC}"
  }
  echo ""
fi

# ========== 阶段 2: build + 部署 ==========
echo -e "${YELLOW}🔨 阶段 2: build + 部署${NC}"
echo "----------------------------------------"
"$LONGXIA_DIR/deploy-local.sh" 2>&1 | tail -10 || {
  echo -e "${RED}❌ 部署失败${NC}"
  exit 1
}
echo ""

# ========== 阶段 3: GitHub push（可选）==========
if [ "$DO_GIT" = true ] && [ "$DEPLOY_ONLY" = false ]; then
  echo -e "${YELLOW}🚀 阶段 3: GitHub push${NC}"
  echo "----------------------------------------"
  cd "$LONGXIA_DIR"
  git add -A
  if git diff --cached --quiet; then
    echo "  无变更，跳过 commit"
  else
    git commit -m "daily-deploy: $(date '+%Y-%m-%d %H:%M:%S')" 2>&1 | tail -3
    git push origin main 2>&1 | tail -5 || echo -e "${RED}❌ push 失败${NC}"
  fi
  echo ""
fi

# ========== 阶段 4: 健康检查（可选）==========
if [ "$DO_CHECK" = true ]; then
  echo -e "${YELLOW}🏥 阶段 4: 网站健康检查${NC}"
  echo "----------------------------------------"
  if [ -x "$LONGXIA_DIR/scripts/site-health-check.sh" ]; then
    "$LONGXIA_DIR/scripts/site-health-check.sh" 2>&1 | tail -30
  else
    echo "  ⚠️  健康检查脚本未找到，跳过"
  fi
  echo ""
fi

echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}  ✅ 全部完成${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo "🌐 访问: http://43.136.30.57/"