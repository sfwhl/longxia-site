#!/usr/bin/env python3
"""
小龙个人 Skill 技能库 - 增量更新脚本

功能：
  1. 扫描 ~/.hermes/skills/ 和 ~/.agents/skills/ 下所有 SKILL.md
  2. 对比 registry.json 中的已有记录
  3. 新增的 skill 追加到 README.md 末尾
  4. 已存在的 skill（按 slug 去重）跳过
  5. 保留你已手动填写的「安装原因」

用法：
  python3 generate.py           # 增量更新
  python3 generate.py --init    # 强制重新全量生成（覆盖）
  python3 generate.py --stats   # 只看统计，不生成文件

设计：
  - 你的「安装原因」存在 README.md 的 Markdown 中（人类可读、可手改）
  - 程序可读的元数据存 registry.json
  - 脚本永远不会覆盖你手动编辑过的内容
"""

import json
import re
import sys
from pathlib import Path
from datetime import datetime
from collections import Counter


SKILLS_DIRS = [
    Path.home() / ".hermes/skills",
    Path.home() / ".agents/skills",
]
OUT_DIR = Path.home() / ".hermes/longxia/skills-registry"
README = OUT_DIR / "README.md"
REGISTRY = OUT_DIR / "registry.json"

EXCLUDE_PATTERNS = [
    re.compile(r"\.\w"),       # 隐藏文件
    re.compile(r".*\.bak.*"),  # 备份目录
]

USER_REASON_MARKER = "**🎯 安装原因**："


def parse_frontmatter(content: str) -> dict:
    """解析 YAML frontmatter"""
    if not content.startswith("---"):
        return {}
    parts = content.split("---", 2)
    if len(parts) < 3:
        return {}
    result = {}
    for line in parts[1].strip().split("\n"):
        if ":" in line and not line.startswith(" "):
            key, val = line.split(":", 1)
            result[key.strip()] = val.strip().strip('"').strip("'")
    return result


def should_exclude(path: Path) -> bool:
    return any(p.match(path.name) for p in EXCLUDE_PATTERNS)


def scan_skills() -> list[dict]:
    """扫描所有 skills，返回元数据列表"""
    skills = []
    seen = set()
    for base_dir in SKILLS_DIRS:
        if not base_dir.exists():
            continue
        for skill_md in base_dir.rglob("SKILL.md"):
            if should_exclude(skill_md):
                continue
            skill_dir = skill_md.resolve().parent
            if skill_dir in seen:
                continue
            seen.add(skill_dir)

            content = skill_md.read_text(encoding="utf-8", errors="replace")
            fm = parse_frontmatter(content)
            stat = skill_dir.stat()
            install_time = datetime.fromtimestamp(stat.st_mtime)

            try:
                rel = skill_dir.relative_to(base_dir.resolve())
                # 一级分类 = 路径的第一段（例如 software-development/plan → software-development）
                # 顶层 skill 没有父分类，归为 general
                parts = rel.parts
                if len(parts) <= 1:
                    category = "general"
                else:
                    category = parts[0]
            except ValueError:
                category = "external"

            file_count = sum(1 for _ in skill_dir.rglob("*") if _.is_file())
            total_size = sum(f.stat().st_size for f in skill_dir.rglob("*") if f.is_file())

            skills.append({
                "slug": skill_dir.name,
                "name": fm.get("name", skill_dir.name),
                "version": fm.get("version", "?"),
                "description": fm.get("description", ""),
                "category": category,
                "install_date": install_time.strftime("%Y-%m-%d %H:%M:%S"),
                "install_date_iso": install_time.isoformat(),
                "local_path": str(skill_dir),
                "file_count": file_count,
                "total_size_bytes": total_size,
                "source": "bundled" if base_dir == Path.home() / ".hermes/skills" else "external",
            })
    return sorted(skills, key=lambda x: x["install_date"], reverse=True)


def extract_existing_reasons(readme_text: str) -> dict[str, str]:
    """从现有 README.md 里提取你已手动填写的安装原因"""
    reasons = {}
    pattern = re.compile(
        r"### 📦 (.+?)\n.*?" + re.escape(USER_REASON_MARKER) + r" (.+?)(?=\n\n|\n---)",
        re.DOTALL
    )
    for m in pattern.finditer(readme_text):
        name = m.group(1).strip()
        reason = m.group(2).strip()
        reasons[name] = reason
    return reasons


def auto_suggest_reason(slug: str, name: str) -> str:
    """根据 slug/name 推断安装原因（启发式）"""
    heuristics = [
        (r"weread|wechat.?read|读书", "提取微信读书的划线/笔记/想法，整理成个人知识库"),
        (r"humanizer", "把 AI 生成的文本改得更像人话，去除 AI 痕迹"),
        (r"pdf|ocr", "处理 PDF / OCR 文档相关"),
        (r"powerpoint|pptx", "创建 / 编辑 PPT 演示文稿"),
        (r"arxiv|paper|research", "学术论文检索 / 文献调研"),
        (r"plan", "进入计划模式，把任务拆成可执行步骤"),
        (r"tdd|test.driven", "测试驱动开发，强制 RED-GREEN-REFACTOR"),
        (r"debugpy|debugger", "Python / Node.js 代码调试"),
        (r"codebase|inspection", "代码库规模 / 语言分布扫描"),
        (r"architecture|diagram", "生成架构图 / 系统设计图"),
        (r"spike", "动手前先做 spike 验证想法"),
        (r"code.?review|requesting", "提交前代码审查"),
        (r"systematic.?debug", "系统化调试（4 阶段）"),
        (r"dogfood", "对 web app 做探索性 QA 找 bug"),
        (r"api.key|safety", "处理可疑凭证时的安全探针"),
        (r"find.?skill", "在 SkillHub 检索 / 发现 skills"),
        (r"hermes", "配置 / 扩展 Hermes Agent"),
        (r"map|geo|osrm", "地理编码 / 路径规划 / 时区"),
        (r"authoring", "编写 / 校验 SKILL.md 文档"),
    ]
    for pattern, reason in heuristics:
        if re.search(pattern, slug, re.IGNORECASE) or re.search(pattern, name, re.IGNORECASE):
            return reason
    return "（待补充：你装这个 skill 是为了做什么？）"


def render_skill_card(skill: dict, reason: str) -> str:
    """渲染单个 skill 的 Markdown 卡片"""
    lines = []
    lines.append(f"### 📦 {skill['name']}")
    lines.append("")
    lines.append("| 字段 | 值 |")
    lines.append("|------|----|")
    lines.append(f"| **Slug** | `{skill['slug']}` |")
    lines.append(f"| **显示名** | {skill['name']} |")
    lines.append(f"| **版本** | {skill['version']} |")
    lines.append(f"| **一级分类** | `{skill['category']}` |")
    lines.append(f"| **安装日期** | {skill['install_date']} |")
    lines.append(f"| **本地路径** | `{skill['local_path']}` |")
    lines.append(f"| **文件数** | {skill['file_count']} |")
    lines.append(f"| **大小** | {skill['total_size_bytes']:,} 字节 ({skill['total_size_bytes']/1024:.1f} KB) |")
    lines.append(f"| **来源** | {skill['source']} |")
    lines.append("")
    lines.append(f"**简介**：{skill['description']}")
    lines.append("")
    lines.append(f"{USER_REASON_MARKER} {reason}")
    lines.append("")
    lines.append("---")
    lines.append("")
    return "\n".join(lines)


def generate_full_readme(skills: list[dict], existing_reasons: dict[str, str], force: bool = False) -> str:
    """生成完整 README.md"""
    now = datetime.now()
    real = [s for s in skills if not s["slug"].endswith(".bak.v1.0.3")]
    backups = [s for s in skills if s["slug"].endswith(".bak.v1.0.3")]

    L = []
    L.append("# 🛠️ 小龙的个人 Skill 技能库")
    L.append("")
    L.append("> 本仓库记录我（小龙）安装到 Hermes Agent 的所有 skills，作为个人 Skill 技能库的种子数据。")
    L.append(f"> 最后更新：{now.strftime('%Y-%m-%d %H:%M:%S')} · 共 **{len(real)}** 个 skills（另含 {len(backups)} 个备份）")
    L.append("")
    L.append("---")
    L.append("")

    # 概览
    L.append("## 📊 概览")
    L.append("")
    cat_count = Counter(s["category"] for s in real)
    L.append("| 一级分类 | 数量 |")
    L.append("|----------|------|")
    for cat, cnt in cat_count.most_common():
        L.append(f"| `{cat}` | {cnt} |")
    L.append(f"| **总计** | **{len(real)}** |")
    L.append("")

    # 最近安装
    L.append("### 🆕 最近安装")
    L.append("")
    for s in real[:5]:
        L.append(f"- **{s['install_date'][:10]}** — `{s['slug']}` ({s['name']})")
    L.append("")

    # 增量更新说明
    L.append("> 💡 **关于「安装原因」**：首次生成时我帮你自动推断一条（基于 skill 名称/功能），")
    L.append("> 其它需要你手动补充。你可以直接编辑这个 Markdown 文件，")
    L.append("> 下次跑 `python3 generate.py`（不带 `--init`）会自动保留你已填写的。")
    L.append("")

    L.append("---")
    L.append("")
    L.append("## 📝 全部 Skills（含安装原因）")
    L.append("")

    for s in real:
        reason = existing_reasons.get(s["name"]) or existing_reasons.get(s["slug"])
        if not reason or force:
            reason = auto_suggest_reason(s["slug"], s["name"])
        L.append(render_skill_card(s, reason))

    if backups:
        L.append("## 🗄️ 备份")
        L.append("")
        for s in backups:
            L.append(f"- `{s['slug']}` — {s['install_date']}（如需回滚可直接拷贝回原路径）")
        L.append("")

    L.append("## 🌐 个人网站（计划）")
    L.append("")
    L.append("打算用这份 Markdown 渲染成轻量级个人博客风格的网站：")
    L.append("- **静态站**：VitePress / Hugo / Hexo 任选")
    L.append("- **统计**：Utterances（评论区）+ busuanzi（阅读量）+ 自建 KV（下载量）")
    L.append("- **部署**：GitHub Pages / Vercel / Cloudflare Pages（免费）")
    L.append("")
    L.append("**（先不急做站，先把清单维护好，网站只是渲染）**")
    L.append("")

    L.append("## 🔄 增量更新")
    L.append("")
    L.append("以后每装一个新 skill，重新跑：")
    L.append("")
    L.append("```bash")
    L.append("python3 ~/.hermes/longxia/skills-registry/generate.py")
    L.append("```")
    L.append("")
    L.append("脚本会自动：")
    L.append("- 扫描 `~/.hermes/skills/` 和 `~/.agents/skills/`")
    L.append("- 跳过已存在的 skill（按 slug 去重）")
    L.append("- 只追加新增的条目到 README.md 末尾")
    L.append("- 保留你已手动填写的「安装原因」")
    L.append("")
    L.append("---")
    L.append("")
    L.append(f"📅 本次生成：{now.strftime('%Y-%m-%d %H:%M:%S')} · 数据源：`~/.hermes/skills/` + `~/.agents/skills/`")
    L.append("")

    return "\n".join(L)


def main():
    OUT_DIR.mkdir(parents=True, exist_ok=True)

    force_init = "--init" in sys.argv
    stats_only = "--stats" in sys.argv

    # 扫描
    skills = scan_skills()

    if stats_only:
        real = [s for s in skills if not s["slug"].endswith(".bak.v1.0.3")]
        backups = [s for s in skills if s["slug"].endswith(".bak.v1.0.3")]
        print(f"📊 总计：{len(real)} 个 skills（{len(backups)} 个备份）\n")
        # 分类用一级标签
        cat_count = Counter(s["category"] for s in real)
        for cat, cnt in cat_count.most_common():
            print(f"  {cat:30s} {cnt}")
        return

    # 提取已有的"安装原因"
    existing_reasons = {}
    if README.exists() and not force_init:
        existing_reasons = extract_existing_reasons(README.read_text(encoding="utf-8"))
        print(f"📋 已读取 {len(existing_reasons)} 条历史安装原因")

    # 写 registry.json
    REGISTRY.write_text(json.dumps({
        "generated_at": datetime.now().isoformat(),
        "total_count": len(skills),
        "skills": skills,
    }, ensure_ascii=False, indent=2), encoding="utf-8")

    # 写 README.md
    if force_init:
        print("🔄 强制全量重新生成（覆盖模式）")
    else:
        print("➕ 增量更新模式（保留你已填写的安装原因）")
    new_content = generate_full_readme(skills, existing_reasons, force=force_init)
    README.write_text(new_content, encoding="utf-8")

    print(f"✅ 已生成: {README}")
    print(f"   {len(skills)} 个 skills · {len(new_content):,} 字符")


if __name__ == "__main__":
    main()