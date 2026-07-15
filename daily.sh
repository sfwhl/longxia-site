#!/bin/bash
# ===================================================================
#  小龙的个人网站 - 每日自动同步脚本  v2.0
# ===================================================================
#
#  功能：
#    1. 拉取今天微信读书新增的笔记（如果有）
#    2. 生成今日 index.md（自动追加到 journal/）
#    3. 同步 journal/ 和 skills-registry/ 到 site/src/
#    4. 重新构建站点（输出到 .vitepress/dist/）
#    5. 5 问自检（费曼方法，每天强制执行）
#    6. 上班训练记录（提醒：今天学了什么 skill）
#    7. 今日感悟录入（互动式追加）
#    8. （可选）git push 触发 Vercel 自动部署
#
#  用法：
#    ./daily.sh                  # 完整流程
#    ./daily.sh --no-weread      # 跳过微信读书步骤
#    ./daily.sh --push           # 完成后自动 git push
#    ./daily.sh --stats          # 只看今天的产出
#    ./daily.sh --evening        # 晚间模式（5 问自检 + 感悟录入）
#    ./daily.sh --interactive    # 交互模式（录入今日感悟）
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
EVENING_MODE=false
INTERACTIVE_MODE=false
for arg in "$@"; do
  case $arg in
    --no-weread) SKIP_WEREAD=true ;;
    --push) DO_PUSH=true ;;
    --stats) STATS_ONLY=true ;;
    --evening) EVENING_MODE=true ;;
    --interactive) INTERACTIVE_MODE=true ;;
    --help|-h)
      echo "用法: ./daily.sh [选项]"
      echo "  --no-weread    跳过微信读书步骤"
      echo "  --push         完成后自动 git push"
      echo "  --stats        只看统计"
      echo "  --evening      晚间模式（5 问自检 + 上班训练记录）"
      echo "  --interactive  交互模式（录入今日感悟）"
      exit 0
      ;;
  esac
done

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  小龙的小站 - 每日自动同步  v2.0${NC}"
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
TOTAL_THOUGHTS=$(find "$SITE_DIR/src/thoughts" -name "index.md" 2>/dev/null | wc -l)
echo ""
echo "  📚 journal/ 总文件数: $TOTAL_JOURNAL"
echo "  🛠️  skills-registry/ 总 skill 数: $TOTAL_SKILLS"
echo "  💡 thoughts/ 总感悟数: $TOTAL_THOUGHTS"
echo ""

# ========== 第 5.5 步：5 问自检（费曼方法，每天强制执行） ==========
echo -e "${YELLOW}🧠 第 5.5 步：5 问自检（费曼方法 - 顾一问）${NC}"
echo "----------------------------------------"
echo -e "${BLUE}每天结束前，对今天学的任何东西问自己 5 个问题：${NC}"
echo ""
echo "  ${YELLOW}1.${NC} 🎯 能下定义吗？  → 一句话说清楚是什么"
echo "  ${YELLOW}2.${NC} 📚 能举例吗？      → 至少一个具体例子"
echo "  ${YELLOW}3.${NC} 🔍 能说明原因吗？  → 为什么是这样"
echo "  ${YELLOW}4.${NC} ⚠️  能处理例外吗？  → 哪些情况下不适用"
echo "  ${YELLOW}5.${NC} 👥 能讲给外行听吗？→ 用大白话讲一遍"
echo ""
echo -e "${RED}任意一个答不上 → 今天没真懂，回去再看一遍${NC}"
echo ""

# 自动追加到今日 index
TODAY_INDEX="$LONGXIA_DIR/journal/$TODAY/README.md"
if [ -f "$TODAY_INDEX" ] && ! grep -q "## 🧠 5 问自检" "$TODAY_INDEX"; then
  cat >> "$TODAY_INDEX" << 'EOF'

## 🧠 5 问自检（费曼方法 - 顾一问）

> 今天学的任何东西，能通过 5 问自检吗？

| # | 问题 | 答案 |
|---|------|------|
| 1 | 🎯 能下定义吗？ |  |
| 2 | 📚 能举例吗？ |  |
| 3 | 🔍 能说明原因吗？ |  |
| 4 | ⚠️  能处理例外吗？ |  |
| 5 | 👥 能讲给外行听吗？ |  |

**任意一个空着 = 今天这部分没真懂**

EOF
  echo -e "  ${GREEN}✅${NC} 5 问自检表已追加到 journal/$TODAY/README.md"
fi
echo ""

# ========== 第 5.6 步：上班训练记录（人 = LLM） ==========
echo -e "${YELLOW}🏋️  第 5.6 步：上班训练记录（上班 = 给自己训练）${NC}"
echo "----------------------------------------"
echo -e "${BLUE}今天上班，训练了哪些 skill？（把自己当 LLM）${NC}"
echo ""
echo "  📌 完成的任务（用 AI 杠杆了吗？）："
echo ""
echo "  🎯 今天学到 / 打磨的新 skill："
echo "     1. "
echo "     2. "
echo ""
echo "  🤖 用 AI 帮做的（基础杠杆）："
echo "     - "
echo ""
echo "  🧠 让 AI 当陪练的（技能放大）："
echo "     - "
echo ""

if [ -f "$TODAY_INDEX" ] && ! grep -q "## 🏋️ 上班训练记录" "$TODAY_INDEX"; then
  cat >> "$TODAY_INDEX" << 'EOF'

## 🏋️ 上班训练记录（上班 = 给自己训练）

> 把自己当 LLM：今天上班就是训练自己的 skill 系统。

### 📌 完成的任务
- [ ]

### 🎯 今天学到 / 打磨的 skill
- [ ]

### 🤖 用 AI 帮做的（基础杠杆）
- [ ]

### 🧠 让 AI 当陪练的（技能放大）
- [ ]

### 📈 自我评估
- 今日新增 skill 数：
- 用 AI 杠杆率（AI 帮做的 / 总任务）：
- 5 问自检通过率：

EOF
  echo -e "  ${GREEN}✅${NC} 上班训练记录已追加到 journal/$TODAY/README.md"
fi
echo ""

# ========== 第 5.7 步：交互式录入今日感悟 ==========
if [ "$INTERACTIVE_MODE" = true ] || [ "$EVENING_MODE" = true ]; then
  echo -e "${YELLOW}💡 第 5.7 步：录入今日感悟${NC}"
  echo "----------------------------------------"

  THOUGHT_FILE="$SITE_DIR/src/thoughts/$TODAY"
  mkdir -p "$THOUGHT_FILE/morning" "$THOUGHT_FILE/afternoon" "$THOUGHT_FILE/evening"

  echo -e "${BLUE}今天有什么感悟？(留空跳过)${NC}"
  read -p "  📝 今日感悟 > " THOUGHT
  if [ -n "$THOUGHT" ]; then
    read -p "  🎯 触发原因（为什么这么想）> " REASON
    read -p "  ⏰ 时段（早/中/晚，留空默认傍晚）> " PERIOD
    PERIOD=${PERIOD:-evening}

    OUT_FILE="$THOUGHT_FILE/$PERIOD/index.md"
    cat > "$OUT_FILE" << EOF
---
title: $THOUGHT
date: $TODAY
time: $(date '+%H:%M')
---

# 💡 $THOUGHT

> **感悟**：$THOUGHT

## 📍 背景

- **日期**：$TODAY
- **触发**：$REASON

EOF
    echo ""
    echo -e "  ${GREEN}✅${NC} 感悟已写入: $OUT_FILE"
    echo "  💡 立即 build 让网站更新..."
  fi
  echo ""
fi

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