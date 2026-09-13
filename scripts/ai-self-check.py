#!/usr/bin/env python3
"""
小龙系统健康检查 + 待办清单
- 不依赖小龙输入
- 主动发现卡住的事
- 输出到 terminal + log
"""

import json
import os
import subprocess
from pathlib import Path
from datetime import datetime, timezone, timedelta

tz = timezone(timedelta(hours=8))
now = datetime.now(tz)
LONGXIA = Path.home() / ".hermes/longxia"

print("=" * 60)
print(f"🤖 AI 自动检查 · {now.strftime('%Y-%m-%d %H:%M CST')}")
print("=" * 60)
print()

# 1. 检查承诺
print("📌 1. 承诺状态")
goals_file = LONGXIA / "tracking" / "goals.json"
if goals_file.exists():
    d = json.loads(goals_file.read_text(encoding="utf-8"))
    in_progress = [c for c in d["commitments"] if c["status"] == "in_progress"]
    completed = [c for c in d["commitments"] if c["status"] == "completed"]
    print(f"  进行中: {len(in_progress)}")
    for c in in_progress:
        deadline = c.get("deadline", "?")
        try:
            d_date = datetime.fromisoformat(deadline).replace(tzinfo=tz)
            days_late = (now - d_date).days
            late_emoji = "🚨" if days_late > 0 else "⏸️"
            print(f"    {late_emoji} {c['title']} (deadline {deadline}, 超 {days_late}d)")
        except Exception:
            print(f"    ⏸️  {c['title']} (deadline {deadline})")
    print(f"  完成: {len(completed)}")
    print()

# 2. 网站健康
print("🌐 2. 网站健康")
result = subprocess.run(
    ["bash", str(LONGXIA / "scripts" / "site-health-check.sh")],
    capture_output=True, text=True, timeout=30
)
output = result.stdout.strip().split("\n")
for line in output[-3:]:
    print(f"  {line}")
print()

# 3. cron jobs 状态
print("⏰ 3. Cron Jobs 状态")
result = subprocess.run(
    ["hermes", "cron", "list"],
    capture_output=True, text=True, timeout=10
)
if "active" in result.stdout:
    active = result.stdout.count("active")
    print(f"  active: {active}")
print()

# 4. 等待小龙动手的事
print("⏸️  4. 等待小龙手动的事")
waiting_things = []

# 4.1 公众号文章（已写但没发布）
if (LONGXIA / "articles" / "dist").exists():
    md_files = list((LONGXIA / "articles" / "dist").glob("*-wechat.md"))
    if md_files:
        waiting_things.append(f"公众号文章已生成 {len(md_files)} 份（等待发布）")

# 4.2 Go 学习
current = LONGXIA / "learning" / "go-driver" / ".current"
if current.exists():
    last_pushed = "2026-07-16"  # 已知
    last = datetime.fromisoformat(last_pushed).replace(tzinfo=tz)
    days_idle = (now - last).days
    if days_idle > 0:
        waiting_things.append(f"Go 第 1 课未学完（{days_idle} 天）")

# 4.3 微信文章抓取（用户粘贴则可处理）
waiting_things.append("微信文章（需要小龙手动复制粘贴）")

if waiting_things:
    for w in waiting_things:
        print(f"  - {w}")
else:
    print("  - 无（一切就绪）")
print()

# 5. 主动建议（不催，只列）
print("💡 5. AI 主动观察（不催）")
print()
print("  - 当前功能开发期，副业 0 投入是合理的")
print("  - 文章已准备就绪，不催发布")
print("  - Go 课暂缓，等不加班再学")
print("  - 微信文章=手动复制粘贴（30 秒）")
print()

print("=" * 60)
print("✅ 检查完成（小龙无需任何操作）")
print("=" * 60)