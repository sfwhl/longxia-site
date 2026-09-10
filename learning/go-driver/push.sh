#!/bin/bash
# ===================================================================
#  小龙的 Go/驱动学习进度推送脚本
# ===================================================================
#
#  用法：
#    ~/.hermes/longxia/learning/go-driver/push.sh           # 推当前课
#    ~/.hermes/longxia/learning/go-driver/push.sh --list   # 列出所有
#    ~/.hermes/longxia/learning/go-driver/push.sh --next   # 切换到下一课
#
#  当你说"学完了"时，AI 跑这个脚本：
#    1. 标记当前课为完成
#    2. 切换到下一课
#    3. 打印下一课链接
#
# ===================================================================

set -e

LEARN_DIR="$HOME/.hermes/longxia/learning/go-driver"
CURRENT_FILE="$LEARN_DIR/.current"
LESSONS_DIR="$LEARN_DIR/lessons"

# 解析参数
LIST_ONLY=false
NEXT_MODE=false
for arg in "$@"; do
  case $arg in
    --list) LIST_ONLY=true ;;
    --next) NEXT_MODE=true ;;
  esac
done

# 列所有课
if [ "$LIST_ONLY" = true ]; then
  echo "=========================================="
  echo "  课程列表"
  echo "=========================================="
  for f in "$LESSONS_DIR"/*.md; do
    name=$(basename "$f" .md)
    # 已完成 vs 当前
    if [ -f "$LEARN_DIR/completed/${name}.done" ]; then
      echo "  ✅ $name"
    else
      echo "  📍 $name  ← 当前"
      break
    fi
  done
  exit 0
fi

# 读当前状态
if [ ! -f "$CURRENT_FILE" ]; then
  echo "❌ 没有 .current 文件"
  exit 1
fi

source "$CURRENT_FILE"
echo "=========================================="
echo "  📘 当前课程"
echo "  $current"
echo "=========================================="

if [ "$NEXT_MODE" = true ]; then
  # 标记完成 + 切换到下一课
  CUR_NAME=$(basename "$current" .md)
  touch "$LEARN_DIR/completed/${CUR_NAME}.done"
  echo "✅ 已标记为完成: $CUR_NAME"

  # 找下一课
  CURRENT_NUM=$(echo "$CUR_NAME" | grep -oE "^[0-9]+" | sed 's/^0*//')
  NEXT_NUM=$((CURRENT_NUM + 1))
  NEXT_FILE=$(ls "$LESSONS_DIR"/$(printf "%02d" $NEXT_NUM)-*.md 2>/dev/null | head -1)

  if [ -z "$NEXT_FILE" ]; then
    echo "🎉 已经是最后一课！全部学完！"
    exit 0
  fi

  NEXT_NAME=$(basename "$NEXT_FILE")
  sed -i "s|^current=.*|current=lessons/$NEXT_NAME|" "$CURRENT_FILE"
  sed -i "s|^last_pushed=.*|last_pushed=$(date +%Y-%m-%d)|" "$CURRENT_FILE"

  echo ""
  echo "=========================================="
  echo "  📘 下一课"
  echo "  $NEXT_NAME"
  echo "=========================================="
  cat "$LESSONS_DIR/$NEXT_NAME" | head -30
  echo ""
  echo "...（完整内容在 $LESSONS_DIR/$NEXT_NAME）"
fi