#!/usr/bin/env python3
"""
把单篇 markdown 文章转成多平台发布版本 + 检查清单。

平台（v2.0，2026-09 起）：
  1. 网站（原文 full）
  2. 掘金 / CSDN / 博客园（技术向，支持 markdown 全文）
  3. 知乎（长文）
  4. 小红书（短文 + 话题标签）
  5. 今日头条（短摘要 + 引导）
  ❌ 公众号（已停用——账号被封）

用法：
  python3 article_distribute.py <markdown 文件>
"""

import re
import sys
from pathlib import Path

# 站点公开地址（用于各平台导流）
SITE_URL = "http://43.136.30.57"
# 发布目标平台（决定生成哪些 dist 文件）
PLATFORMS = ["full", "juejin", "zhihu", "xiaohongshu", "toutiao"]


def parse_frontmatter(text):
    fm = {}
    m = re.search(r"^---\n(.*?)\n---\n", text, re.DOTALL)
    if m:
        for line in m.group(1).split("\n"):
            if ":" in line:
                k, v = line.split(":", 1)
                fm[k.strip()] = v.strip()
        text = text[m.end():]
    return fm, text


def extract_abstract(text, limit=200):
    """从正文提取有钩子的摘要"""
    clean = re.sub(r"```.*?```", "", text, flags=re.DOTALL)
    clean = re.sub(r"`[^`]+`", "", clean)
    clean = re.sub(r"\[([^\]]+)\]\([^)]+\)", r"\1", clean)
    clean = re.sub(r"[#*>]", "", clean)
    clean = re.sub(r"\|.*?\|", "", clean)          # 表格行
    clean = re.sub(r"^[-\s]+$", "", clean, flags=re.MULTILINE)
    clean = re.sub(r"\n{3,}", "\n\n", clean)
    clean = re.sub(r"  +", " ", clean)

    paras = [p.strip() for p in clean.split("\n\n") if p.strip()]
    # 跳过标题类短句 / 代码残留长句
    paras = [p for p in paras if 30 <= len(p) <= 500]
    # 优先挑含 "我" 的段落（更像人话、更有钩子）
    paras.sort(key=lambda p: (0 if "我" in p else 1))

    out, n = [], 0
    for p in paras:
        if n + len(p) > limit:
            rest = limit - n
            if rest > 30:
                out.append(p[:rest] + "...")
            break
        out.append(p)
        n += len(p)
        if n >= limit - 50:
            break
    return (" ".join(out).strip()) or (clean.replace("\n", " ").strip()[:limit] + "...")


def main():
    if len(sys.argv) < 2:
        print("用法: python3 article_distribute.py <markdown 文件>")
        sys.exit(1)

    md_path = Path(sys.argv[1])
    if not md_path.exists():
        print(f"❌ 文件不存在: {md_path}")
        sys.exit(1)

    dist_dir = Path.home() / ".hermes/longxia/articles" / "dist"
    dist_dir.mkdir(parents=True, exist_ok=True)

    basename = md_path.stem
    fm, text = parse_frontmatter(md_path.read_text(encoding="utf-8"))

    h1 = re.search(r"^# (.+)$", text, re.MULTILINE)
    title = h1.group(1) if h1 else fm.get("title", basename)
    if h1:
        text = text[h1.end():].strip()

    abstract = extract_abstract(text)
    tags = [t.strip() for t in fm.get("tags", "[]").strip("[]").split(",") if t.strip()]
    hash_tags = " ".join(f"#{t}" for t in tags)

    print("=" * 60)
    print("  📤 多平台分发 v2.0")
    print(f"  标题: {title}")
    print(f"  摘要: {abstract[:70]}...")
    print(f"  正文: {len(text)} 字符 · 标签 {len(tags)} 个")
    print("=" * 60)

    written = []

    # ── 1. 网站原文（原样保留 markdown，VitePress 直接渲染）
    p = dist_dir / f"{basename}-full.md"
    p.write_text(f"# {title}\n\n{text}\n", encoding="utf-8")
    written.append(("网站原文", p))

    # ── 2. 掘金 / CSDN / 博客园（技术向，支持 markdown，保留正文）
    juejin = f"""> {abstract}

---

{text}

---

> 📌 本文首发于我的个人网站：[{SITE_URL}]({SITE_URL})
> 持续更新 AI 工作流 / 终端安全 / EDR 相关的真实实践。
"""
    p = dist_dir / f"{basename}-juejin.md"
    p.write_text(juejin, encoding="utf-8")
    written.append(("掘金/CSDN/博客园", p))

    # ── 3. 知乎（长文，带作者栏）
    zhihu = f"""# {title}

> 作者：{fm.get("author", "小龙")} · 终端安全工程师

{text}

---

> 完整版见个人网站：[{SITE_URL}]({SITE_URL})

{hash_tags}
"""
    p = dist_dir / f"{basename}-zhihu.md"
    p.write_text(zhihu, encoding="utf-8")
    written.append(("知乎", p))

    # ── 4. 小红书（短文 + emoji + 话题）
    xhs = f"""# {title}

{abstract[:150]}

{hash_tags}

👆 完整版在我网站（见主页）
"""
    p = dist_dir / f"{basename}-xiaohongshu.txt"
    p.write_text(xhs, encoding="utf-8")
    written.append(("小红书", p))

    # ── 5. 今日头条（短摘要 + 引导）
    toutiao = f"""【小龙原创】{title}

{abstract}

{hash_tags}

📖 完整长文 → {SITE_URL}
"""
    p = dist_dir / f"{basename}-toutiao.txt"
    p.write_text(toutiao, encoding="utf-8")
    written.append(("今日头条", p))

    for name, path in written:
        print(f"✅ {name}: dist/{path.name}")

    # ── 6. 检查清单
    checklist = f"""# 发布检查清单 - {title}

> 生成时间：自动 · 发布状态：⬜ 未发布

## 发布前
- [ ] 通读全文，无错别字
- [ ] 所有链接可访问（`{SITE_URL}` 是否在线）
- [ ] 封面图（900×500）

## 平台清单（按优先级）

### 🥇 第一优先（技术向 · 支持 markdown · 冷启动快）
- [ ] **掘金**：复制 `dist/{basename}-juejin.md` → 掘金编辑器（支持 md 粘贴）
- [ ] **CSDN**：同上，`dist/{basename}-juejin.md`
- [ ] **博客园**：同上，`dist/{basename}-juejin.md`

### 🥈 第二优先（流量池大 · 需要养号）
- [ ] **知乎**：复制 `dist/{basename}-zhihu.md`
- [ ] **今日头条**：复制 `dist/{basename}-toutiao.txt`

### 🥉 第三优先（拉新/导流）
- [ ] **小红书**：复制 `dist/{basename}-xiaohongshu.txt`

### ❌ 已停用
- [x] ~~公众号~~（账号被封，不再发布）

## 发布后（必做，否则不算完成）
- [ ] 每发一个平台 → 把链接记到 `notes/output-tracker.md`
- [ ] 网站文章页 `/articles/` 加上新卡片
- [ ] 至少转发给 1 个真人（前同事/群里）

---
_由 article_distribute.py v2.0 生成_
"""
    p = dist_dir / f"{basename}-CHECKLIST.md"
    p.write_text(checklist, encoding="utf-8")
    print(f"✅ 清单: dist/{p.name}")

    print()
    print(f"🎉 完成！{len(written)} 个平台版本 + 1 个清单")
    print(f"📁 {dist_dir}/")


if __name__ == "__main__":
    main()
