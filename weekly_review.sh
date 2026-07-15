#!/bin/bash
# ===================================================================
#  小龙的个人网站 - 每周复盘脚本
# ===================================================================
#
#  功能（每周日跑一次，30 分钟完成本周总结）：
#    1. 统计本周新增的：日记 / 读书笔记 / 感悟 / Skills
#    2. 5 问自检通过率统计（看你真正"学会"了多少）
#    3. AI 杠杆率统计（看 AI 帮你做了多少）
#    4. 找本周最值得复盘的 3 件事
#    5. 生成 weekly-review-<日期>.md
#    6. 系统 Prompt 升级提示
#
#  用法：
#    ./weekly_review.sh                  # 复盘本周
#    ./weekly_review.sh --last-7-days    # 复盘过去 7 天（任意一天都可跑）
#
#  Cron 建议（每周日 21:00 执行）：
#    0 21 * * 0 cd ~/.hermes/longxia && ./weekly_review.sh >> ~/.hermes/longxia/weekly.log 2>&1
#
# ===================================================================

set -e

LONGXIA_DIR="$HOME/.hermes/longxia"
SITE_DIR="$LONGXIA_DIR/site"

# 颜色
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# 解析参数
LOOKBACK_DAYS=7
for arg in "$@"; do
  case $arg in
    --last-7-days) LOOKBACK_DAYS=7 ;;
    --last-14-days) LOOKBACK_DAYS=14 ;;
    --help|-h)
      echo "用法: ./weekly_review.sh [--last-7-days|--last-14-days]"
      exit 0
      ;;
  esac
done

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  小龙的每周复盘  ·  过去 $LOOKBACK_DAYS 天${NC}"
echo -e "${BLUE}  $(date '+%Y-%m-%d %H:%M:%S')${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

# 计算日期范围
START_DATE=$(date -d "$LOOKBACK_DAYS days ago" '+%Y-%m-%d' 2>/dev/null || date -v-${LOOKBACK_DAYS}d '+%Y-%m-%d')
END_DATE=$(date '+%Y-%m-%d')
WEEK_NUM=$(date '+%Y-W%V')

echo -e "${YELLOW}📅 复盘范围${NC}: $START_DATE → $END_DATE (第 $WEEK_NUM 周)"
echo ""

# ========== 第 1 步：基础统计 ==========
echo -e "${YELLOW}📊 第 1 步：本周统计${NC}"
echo "----------------------------------------"

# 找过去 N 天的日记目录
WEEK_DIRS=$(find "$LONGXIA_DIR/journal" -maxdepth 1 -type d -name "20*" -newer "$LONGXIA_DIR/daily.sh" 2>/dev/null || \
            find "$LONGXIA_DIR/journal" -maxdepth 1 -type d -name "20*" -mtime -${LOOKBACK_DAYS} 2>/dev/null)

JOURNAL_COUNT=$(echo "$WEEK_DIRS" | wc -l)
echo "  📚 本周日记目录: $JOURNAL_COUNT 个"

# 本周新生成的 .md 文件
NEW_NOTES=$(find "$LONGXIA_DIR/journal" -name "*.md" -mtime -${LOOKBACK_DAYS} 2>/dev/null | wc -l)
echo "  📝 本周新增笔记: $NEW_NOTES 个"

# 感悟数量
NEW_THOUGHTS=$(find "$SITE_DIR/src/thoughts" -name "index.md" -mtime -${LOOKBACK_DAYS} 2>/dev/null | wc -l)
echo "  💡 本周新感悟: $NEW_THOUGHTS 条"

# Skills 增量
TOTAL_SKILLS=$(grep -c "^### 📦" "$LONGXIA_DIR/skills-registry/README.md" 2>/dev/null || echo "0")
echo "  🛠️  当前总 skills: $TOTAL_SKILLS 个"

echo ""

# ========== 第 2 步：5 问自检通过率 ==========
echo -e "${YELLOW}🧠 第 2 步：5 问自检通过率（你真正学会的）${NC}"
echo "----------------------------------------"

# 检查本周有 5 问自检的 README
TOTAL_CHECKS=0
PASSED_CHECKS=0
for dir in $WEEK_DIRS; do
  if [ -f "$dir/README.md" ] && grep -q "## 🧠 5 问自检" "$dir/README.md"; then
    # 数一下答案列里填了的数量（简单检查：有没有非空行）
    ANSWERED=$(awk '/## 🧠 5 问自检/,/^---$/' "$dir/README.md" | grep -E "^\| [0-9] \|" | grep -v "|  |" | wc -l)
    TOTAL_CHECKS=$((TOTAL_CHECKS + 5))
    PASSED_CHECKS=$((PASSED_CHECKS + ANSWERED))
    echo "  📅 $(basename $dir): $ANSWERED/5 问已答"
  fi
done

if [ $TOTAL_CHECKS -gt 0 ]; then
  RATE=$(awk "BEGIN {printf \"%.0f\", $PASSED_CHECKS * 100 / $TOTAL_CHECKS}")
  echo ""
  echo "  📈 总通过率: ${PASSED_CHECKS}/${TOTAL_CHECKS} = ${RATE}%"
else
  echo "  ⚠️  本周还没有 5 问自检记录"
fi
echo ""

# ========== 第 3 步：AI 杠杆率 ==========
echo -e "${YELLOW}🤖 第 3 步：AI 杠杆率（用 AI 帮你做了多少）${NC}"
echo "----------------------------------------"
echo "  💡 问自己："
echo "     - 本周 AI 帮你做了哪些事？"
echo "     - 省下来的时间你用来做了什么？"
echo "     - 哪些事你'本可以自己来'但还是让 AI 做了？"
echo ""
echo "  📊 估算杠杆率（自己填）：___%"
echo ""

# ========== 第 4 步：找本周最值得复盘的 3 件事 ==========
echo -e "${YELLOW}🏆 第 4 步：本周 TOP 3 复盘${NC}"
echo "----------------------------------------"
echo "  这周做了很多事，但只有 3 件真正值得写下来。"
echo "  选标准："
echo "    1. 改变了我的认知（顿悟 / 反直觉）"
echo "    2. 让我以后做事方式不同（系统化 / 自动化）"
echo "    3. 让我离'真正的自己'更近（主动权 + 真实）"
echo ""
echo "  🥇 TOP 1: ______________________________"
echo "     为什么: ______________________________"
echo ""
echo "  🥈 TOP 2: ______________________________"
echo "     为什么: ______________________________"
echo ""
echo "  🥉 TOP 3: ______________________________"
echo "     为什么: ______________________________"
echo ""

# ========== 第 5 步：版本迭代检查 ==========
echo -e "${YELLOW}🔄 第 5 步：版本迭代（v1.0 → v1.1）${NC}"
echo "----------------------------------------"
echo "  对比上周，这周我:"
echo "    进步的地方: ______________________________"
echo "    倒退的地方: ______________________________"
echo "    下周要改的: ______________________________"
echo ""

# ========== 第 6 步：生成 weekly-review ==========
WEEKLY_FILE="$LONGXIA_DIR/journal/weekly-review-${WEEK_NUM}.md"
echo -e "${YELLOW}📝 第 6 步：生成周复盘文件${NC}"
echo "----------------------------------------"

cat > "$WEEKLY_FILE" << EOF
# 📅 周复盘 · 第 $WEEK_NUM 周 ($START_DATE → $END_DATE)

## 📊 本周数据

| 维度 | 数量 |
|------|------|
| 日记目录 | $JOURNAL_COUNT 个 |
| 新增笔记 | $NEW_NOTES 个 |
| 新感悟 | $NEW_THOUGHTS 条 |
| 5 问自检通过率 | ${RATE:-0}% |
| AI 杠杆率（自填） | ___% |
| 当前总 skills | $TOTAL_SKILLS 个 |

## 🏆 本周 TOP 3

### 🥇 TOP 1
**事件**: ______________________________

**为什么**: ______________________________

### 🥈 TOP 2
**事件**: ______________________________

**为什么**: ______________________________

### 🥉 TOP 3
**事件**: ______________________________

**为什么**: ______________________________

## 🔄 版本迭代（v1.0 → v1.1）

### 进步的地方
- 

### 倒退的地方
- 

### 下周要改的
- 

## 💡 系统 Prompt 升级

> 这周学到的最重要的一件事，要不要写进 system prompt？

\`\`\`
[ ] 是，已更新
[ ] 否，还在观察
\`\`\`

新版 system prompt（候选）:
> 

---

_由 weekly_review.sh 自动生成 · $(date '+%Y-%m-%d %H:%M:%S')_
EOF

echo -e "  ${GREEN}✅${NC} 周复盘文件已生成: $WEEKLY_FILE"

# 同步到网站
mkdir -p "$SITE_DIR/src/journal/weekly"
cp "$WEEKLY_FILE" "$SITE_DIR/src/journal/weekly/$(basename $WEEKLY_FILE)"
echo -e "  ${GREEN}✅${NC} 已同步到 site/src/journal/weekly/"

echo ""
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}  ✅ 每周复盘完成${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo "📅 下次跑这个脚本：周日 21:00（或直接现在再跑一遍）"
echo "📂 文件位置: $WEEKLY_FILE"