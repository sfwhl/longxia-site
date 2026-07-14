#!/bin/bash
# ===================================================================
#  小龙的个人网站 - 每日自动同步脚本
# ===================================================================
#
#  功能：
#    1. 拉取今天微信读书新增的笔记（如果有）
#    2. 生成今日 index.md（自动追加到 journal/）
#    3. 同步 journal/ 和 skills-registry/ 到 site/src/
#    4. 重新构建站点（输出到 .vitepress/dist/）
#    5. （可选）git push 触发 Vercel 自动部署
#
#  用法：
#    ./daily.sh                  # 完整流程：拉笔记 → 同步 → build
#    ./daily.sh --no-weread      # 跳过微信读书步骤（只同步本地 + build）
#    ./daily.sh --push           # 完成后自动 git push
#    ./daily.sh --stats          # 只看今天的产出，不重新生成
#
#  Cron 建议（每天早上 9 点执行）：
#    0 9 * * * cd ~/.hermes/longxia && ./daily.sh --push >> ~/.hermes/longxia/daily.log 2>&1
#
# ===================================================================

set -e

# 路径常量
LONGXIA_DIR="$HOME/.hermes/longxia"
SITE_DIR="$LONGXIA_DIR/site"
SRC_DIR="$SITE_DIR/src"
LOG_PREFIX="[$(date '+%Y-%m-%d %H:%M:%S')]"

# 颜色（终端输出友好）
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# 参数解析
SKIP_WEREAD=false
DO_PUSH=false
STATS_ONLY=false
for arg in "$@"; do
  case $arg in
    --no-weread) SKIP_WEREAD=true ;;
    --push) DO_PUSH=true ;;
    --stats) STATS_ONLY=true ;;
    --help|-h)
      echo "用法: ./daily.sh [--no-weread] [--push] [--stats]"
      echo "  --no-weread    跳过微信读书步骤"
      echo "  --push         完成后自动 git push"
      echo "  --stats        只看统计"
      exit 0
      ;;
  esac
done

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  小龙的小站 - 每日自动同步${NC}"
echo -e "${BLUE}  $LOG_PREFIX${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

# ========== 第 1 步：拉今天的微信读书笔记 ==========
if [ "$SKIP_WEREAD" = false ] && [ "$STATS_ONLY" = false ]; then
  echo -e "${YELLOW}📖 第 1 步：拉取今天微信读书新增笔记${NC}"
  echo "----------------------------------------"

  # 检查 Key 是否可用
  if [ -z "$WEREAD_API_KEY" ]; then
    # 从 bashrc 提取
    export WEREAD_API_KEY=$(grep -E "^export WEREAD_API_KEY=" ~/.bashrc | tail -1 | sed 's/^export WEREAD_API_KEY=//' | tr -d '"' | tr -d "'")
  fi

  if [ -z "$WEREAD_API_KEY" ]; then
    echo -e "${RED}❌ WEREAD_API_KEY 未设置，跳过微信读书步骤${NC}"
    echo "   解决：把 Key 写入 ~/.bashrc（export WEREAD_API_KEY=...）"
  else
    # 用 Python 脚本拉取今天的新增笔记（每天跑一次，幂等）
    python3 "$LONGXIA_DIR/scripts/fetch_today_weread.py" || echo -e "${RED}❌ 微信读书拉取失败，继续其它步骤${NC}"
  fi
  echo ""
fi

# ========== 第 2 步：刷新 Skill 清单 ==========
if [ "$STATS_ONLY" = false ]; then
  echo -e "${YELLOW}🛠️  第 2 步：刷新 Skill 清单${NC}"
  echo "----------------------------------------"
  python3 "$LONGXIA_DIR/skills-registry/generate.py" --init || echo -e "${RED}❌ Skill 清单刷新失败${NC}"
  echo ""
fi

# ========== 第 3 步：同步内容到 site/src/ ==========
if [ "$STATS_ONLY" = false ]; then
  echo -e "${YELLOW}📦 第 3 步：同步内容到 site/src/${NC}"
  echo "----------------------------------------"
  mkdir -p "$SRC_DIR"

  # 同步 journal（强制覆盖）
  if [ -d "$LONGXIA_DIR/journal" ]; then
    mkdir -p "$SRC_DIR/journal"
    rsync -a --delete "$LONGXIA_DIR/journal/" "$SRC_DIR/journal/"
    JOURNAL_COUNT=$(find "$LONGXIA_DIR/journal" -type f -name "*.md" | wc -l)
    echo -e "  ${GREEN}✅${NC} journal/ → src/journal/ ($JOURNAL_COUNT 个 md 文件)"
  fi

  # 同步 skills-registry（排除 generate.py 等脚本文件）
  if [ -d "$LONGXIA_DIR/skills-registry" ]; then
    mkdir -p "$SRC_DIR/skills-registry"
    rsync -a --delete \
      --exclude='generate.py' \
      --exclude='__pycache__' \
      --exclude='*.pyc' \
      "$LONGXIA_DIR/skills-registry/" "$SRC_DIR/skills-registry/"
    echo -e "  ${GREEN}✅${NC} skills-registry/ → src/skills-registry/"
  fi
  echo ""
fi

# ========== 第 4 步：构建站点 ==========
if [ "$STATS_ONLY" = false ]; then
  echo -e "${YELLOW}🔨 第 4 步：构建站点${NC}"
  echo "----------------------------------------"
  cd "$SITE_DIR"
  npm run docs:build 2>&1 | tail -8
  BUILD_TIME=$(date +%s)
  echo -e "  ${GREEN}✅${NC} 构建完成于 $(date '+%H:%M:%S')"
  echo ""
fi

# ========== 第 5 步：统计 ==========
echo -e "${YELLOW}📊 第 5 步：今日统计${NC}"
echo "----------------------------------------"
TODAY=$(date '+%Y-%m-%d')
TODAY_DIR="$LONGXIA_DIR/journal/$TODAY"
if [ -d "$TODAY_DIR" ]; then
  echo "  📅 今日 ($TODAY) 文件："
  ls -la "$TODAY_DIR" | tail -n +2 | awk '{printf "    - %s (%s 字节)\n", $NF, $5}'
else
  echo "  📅 今天还没有日记目录（无新增内容）"
fi

TOTAL_JOURNAL=$(find "$LONGXIA_DIR/journal" -type f -name "*.md" 2>/dev/null | wc -l)
TOTAL_SKILLS=$(grep -c "^### 📦" "$LONGXIA_DIR/skills-registry/README.md" 2>/dev/null || echo "0")
echo ""
echo "  📚 journal/ 总文件数: $TOTAL_JOURNAL"
echo "  🛠️  skills-registry/ 总 skill 数: $TOTAL_SKILLS"
echo ""

# ========== 第 6 步：可选 git push ==========
if [ "$DO_PUSH" = true ]; then
  echo -e "${YELLOW}🚀 第 6 步：git push 触发 Vercel 自动部署${NC}"
  echo "----------------------------------------"
  cd "$LONGXIA_DIR"

  # 检查是否有 git 仓库
  if [ ! -d ".git" ]; then
    echo -e "${YELLOW}⚠️  未初始化 git 仓库，请先：${NC}"
    echo "   cd $LONGXIA_DIR && git init && git remote add origin <your-repo>"
    exit 1
  fi

  # 只提交 site/ 目录（journal 和 skills-registry 是源数据，不公开）
  git add site/ skills-registry/README.md skills-registry/registry.json 2>/dev/null || true
  git commit -m "daily: 自动同步 $(date '+%Y-%m-%d %H:%M')" || echo -e "${YELLOW}⚠️  无变更或 commit 失败${NC}"
  git push origin main 2>&1 | tail -5 || echo -e "${RED}❌ push 失败（请检查 remote 配置）${NC}"
  echo ""
fi

echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}  ✅ 全部完成${NC}"
echo -e "${GREEN}=========================================${NC}"