#!/usr/bin/env python3
"""
小龙每日反思脚本 v1.0
===================

这个脚本不是给小龙看的——是给 Hermes（AI）看的。

目的：
  让 AI 在每次会话结束时 / 每天定时跑时，主动反思：
  - 小龙最近承诺了什么，做了什么
  - 哪些目标被遗忘了
  - 哪些"长期重要的事"被搁置了
  - 主动给出"AI 视角的观察"（不是顺从，是反思）

不要顺从。不要阿谀。只说真话。
"""

import json
import sys
from pathlib import Path
from datetime import datetime, timezone, timedelta, date
from collections import defaultdict

TRACKING_DIR = Path.home() / ".hermes/longxia/tracking"
GOALS_FILE = TRACKING_DIR / "goals.json"
JOURNAL_DIR = Path.home() / ".hermes/longxia/journal"
LEARNING_DIR = Path.home() / ".hermes/longxia/learning/go-driver"
SKILLS_DIR = Path.home() / ".hermes/longxia/skills-registry"

TZ = timezone(timedelta(hours=8))  # Asia/Shanghai


def load_goals():
    """加载目标"""
    if not GOALS_FILE.exists():
        return None
    return json.loads(GOALS_FILE.read_text(encoding="utf-8"))


def check_overdue_commitments(goals):
    """找出过期未完成的承诺"""
    now = datetime.now(TZ)
    overdue = []
    for c in goals.get("commitments", []):
        if c.get("status") in ("completed", "paused", "cancelled"):
            continue
        deadline_str = c.get("deadline", "")
        try:
            deadline = datetime.fromisoformat(deadline_str).replace(tzinfo=TZ)
            if now > deadline:
                days_late = (now - deadline).days
                overdue.append({
                    "title": c["title"],
                    "deadline": deadline_str,
                    "days_late": days_late
                })
        except Exception:
            pass
    return overdue


def check_learning_progress():
    """检查 Go 学习进度"""
    current_file = LEARNING_DIR / ".current"
    if not current_file.exists():
        return None

    # 解析 current=lessons/XX-slug.md
    content = current_file.read_text(encoding="utf-8")
    current_lesson = ""
    last_pushed = ""
    for line in content.split("\n"):
        if line.startswith("current="):
            current_lesson = line.replace("current=", "")
        elif line.startswith("last_pushed="):
            last_pushed = line.replace("last_pushed=", "")

    if not last_pushed:
        return None

    try:
        last_date = datetime.fromisoformat(last_pushed).replace(tzinfo=TZ)
        days_idle = (datetime.now(TZ) - last_date).days
        return {
            "current_lesson": current_lesson,
            "last_pushed": last_pushed,
            "days_idle": days_idle
        }
    except Exception:
        return None


def check_recent_activity(days=3):
    """最近几天的 journal/ 活动"""
    if not JOURNAL_DIR.exists():
        return []
    
    recent = []
    for journal_dir in sorted(JOURNAL_DIR.iterdir(), reverse=True):
        if not journal_dir.is_dir():
            continue
        try:
            dir_date = datetime.fromisoformat(journal_dir.name).date()
            if (date.today() - dir_date).days > days:
                break
            files = list(journal_dir.glob("*.md"))
            if files:
                recent.append({
                    "date": journal_dir.name,
                    "files": [f.name for f in files]
                })
        except ValueError:
            continue
    return recent


def check_skills_health():
    """Skills 健康度（总数 + 最近新增）"""
    if not SKILLS_DIR.exists():
        return None
    readme = SKILLS_DIR / "README.md"
    if readme.exists():
        text = readme.read_text(encoding="utf-8")
        # 提取"共 X 个 skills"
        import re
        m = re.search(r'共\s*(\d+)\s*个 skills', text)
        if m:
            return int(m.group(1))
    return None


def generate_reflection(goals):
    """生成 AI 视角的反思报告"""
    now = datetime.now(TZ)
    today = now.strftime("%Y-%m-%d")
    weekday = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"][now.weekday()]

    print("=" * 60)
    print(f"🤖 Hermes 每日反思 · {today} ({weekday})")
    print("=" * 60)
    print()

    # 1. 长期目标进度
    if goals and goals.get("long_term_goals"):
        print("📍 长期目标进度：")
        print()
        for g in goals["long_term_goals"]:
            print(f"  [{g['id']}] {g['title']}")
            print(f"    为什么重要: {g['why']}")
            print(f"    进度: {g.get('current_progress', '未跟踪')}")
            print(f"    开始: {g.get('started', '?')}")
            print()

    # 2. 过期承诺
    overdue = check_overdue_commitments(goals) if goals else []
    if overdue:
        print("⚠️  过期承诺：")
        for o in overdue:
            print(f"  ❌ {o['title']} — 超期 {o['days_late']} 天（deadline: {o['deadline']}）")
        print()

    # 3. 学习进度（Go 课）— 2026-09-13 起 Go 改为"按需学习"，不再每日催促
    go_paused = any(
        c.get("id") == "go-lesson-01" and c.get("status") in ("paused", "cancelled")
        for c in (goals or {}).get("commitments", [])
    )
    learning = check_learning_progress()
    if learning and go_paused:
        print(f"📚 Go 学习（已改为按需模式）：{learning['current_lesson']} · 工作中用到再学，不打卡")
        print()
    elif learning:
        if learning["days_idle"] == 0:
            print(f"📚 Go 学习：当前 {learning['current_lesson']}（今天刚推送过，正常）")
        elif learning["days_idle"] == 1:
            print(f"📚 Go 学习：当前 {learning['current_lesson']}（已 1 天没动，可能忘了）")
        elif learning["days_idle"] <= 3:
            print(f"⚠️  Go 学习：当前 {learning['current_lesson']}（已 {learning['days_idle']} 天没动，要继续）")
        else:
            print(f"🚨 Go 学习：当前 {learning['current_lesson']}（已 {learning['days_idle']} 天没动了！目标要黄？）")
        print()

    # 4. 最近活动
    activity = check_recent_activity(days=3)
    if activity:
        print("📔 最近 3 天有内容产出：")
        for a in activity:
            print(f"  {a['date']}: {len(a['files'])} 个文件")
            for f in a['files'][:3]:
                print(f"    - {f}")
            if len(a['files']) > 3:
                print(f"    ... +{len(a['files'])-3} 更多")
        print()
    else:
        print("⚠️  最近 3 天没有新内容产出")
        print()

    # 5. Skills 健康
    skills_count = check_skills_health()
    if skills_count:
        print(f"🛠️  Skills 总数: {skills_count}")
        print()

    # 6. AI 的主动观察（核心）
    print("=" * 60)
    print("💡 Hermes 的主动观察（这是 AI 该反思的）：")
    print("=" * 60)
    observations = []

    # 观察 1：是否有承诺没兑现
    if overdue:
        observations.append(
            f"你 {overdue[0]['deadline']} 承诺要做 '{overdue[0]['title']}'，"
            f"已经超期 {overdue[0]['days_late']} 天。"
            f"我没主动催你——这本身就是失职。"
        )

    # 观察 2：Go 学习是否停滞
    if learning and learning["days_idle"] >= 1:
        observations.append(
            f"你说要'每天中午练习'，但 Go 课已经 {learning['days_idle']} 天没推进。"
            f"是我没主动提醒你——我应该在你 24h 没动时主动问。"
        )

    # 观察 3：内容产出频率
    if not activity:
        observations.append(
            "你最近 3 天没有新内容产出。"
            "公众号刚起步，是靠持续输出建立影响力的——沉默 3 天就危险。"
        )

    # 观察 4：技能过多 vs 实际使用
    if skills_count and skills_count > 20:
        observations.append(
            f"你装了 {skills_count} 个 skills。"
            "但装的不是越多越好——吃灰的 skill 是负担。"
            "我建议：每周日清点一次，删掉 30 天没用的。"
        )

    # 观察 5：方向 vs 执行
    # 观察 6：作息（如果能从对话里推断）
    if now.hour >= 23 or now.hour < 6:
        observations.append(
            f"现在是 {now.strftime('%H:%M')}。"
            "如果你还在跟我对话——说明作息有问题。"
            "我应该劝你睡觉（但我之前没有这么做）。"
        )

    # 观察 7：工作压力感知（重要：尊重用户实际状态）
    observations.append(
        "如果小龙最近工作紧张、加班频繁——副业目标应该降级为 0 投入、纯积累。"
        "不要催他做副业。催他休息、催他早睡、催他保护身体。"
        "工作是饭碗，副业是未来——身体是本金。"
    )

    # 观察 8：🚨 SOP 触发器提醒（AI 自身）
    observations.append(
        "🚨 当小龙说「开发/实现/写代码/调研/新功能」时，AI 必须先发："
        "~/.hermes/longxia/notes/sop/dev-sop-2026-07-23.md"
        "并问 4 个前置问题（接触过吗/需求是什么/代码理解度/TL 评审了吗）。"
        "AI 降低编码成本但不降低方案返工/模块理解/联调/质量成本。"
    )

    if not observations:
        observations.append("一切看起来正常。继续。")

    for i, obs in enumerate(observations, 1):
        print(f"  {i}. {obs}")
    print()

    # 7. 给小龙的具体建议（最多 3 条）
    print("🎯 给小龙的具体建议（最多 3 条）：")
    print()
    suggestions = []
    
    if learning and learning["days_idle"] >= 1:
        suggestions.append(f"今天学完 Go 课 '{learning['current_lesson']}'（30 分钟）")
    
    if overdue:
        for o in overdue[:1]:
            suggestions.append(f"关闭旧承诺：'{o['title']}'（要么做完，要么取消承诺）")
    
    if not suggestions:
        suggestions.append("继续按当前节奏走")

    for i, s in enumerate(suggestions, 1):
        print(f"  {i}. {s}")
    print()

    # 8. AI 自身的承诺
    print("🤖 AI 的承诺（写下来承诺给我的）：")
    print()
    ai_commitments = [
        "我会在你 24h 没动 Go 课时主动提醒",
        "我会在你承诺过期时主动质疑",
        "我会在你花时间在低优先级任务时提醒优先级",
        "我会在对话结束时不只给交付物，还给观察",
    ]
    for c in ai_commitments:
        print(f"  ✓ {c}")
    print()
    
    print("=" * 60)


if __name__ == "__main__":
    goals = load_goals()
    generate_reflection(goals)