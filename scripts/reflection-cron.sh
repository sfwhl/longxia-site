#!/bin/bash
# 反思输出包装器：把反思结果发到飞书（你常用）
# 默认输出到 stderr + 持久化到本地文件

set -e
LONGXIA_DIR="$HOME/.hermes/longxia"
LOG_DIR="$LONGXIA_DIR/tracking/logs"
mkdir -p "$LOG_DIR"

DATE=$(date '+%Y-%m-%d')
TIME=$(date '+%H:%M:%S')

echo "[$DATE $TIME] === 反思启动 ===" >> "$LOG_DIR/reflection.log"

# 跑反思脚本，输出到日志
python3 "$LONGXIA_DIR/scripts/daily_reflection.py" >> "$LOG_DIR/reflection.log" 2>&1

echo "[$DATE $TIME] === 反思结束 ===" >> "$LOG_DIR/reflection.log"
echo "" >> "$LOG_DIR/reflection.log"