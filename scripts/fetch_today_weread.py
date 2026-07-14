#!/usr/bin/env python3
"""
小龙每日微信读书笔记拉取脚本

功能：
  1. 拉取今天有笔记活动的书（按 sort 时间戳筛选）
  2. 对每本书拉取所有划线 + 想法
  3. 按章节聚合，生成结构化 Markdown
  4. 保存到 ~/.hermes/longxia/journal/<今天>/

幂等：重复运行不会重复生成（已有文件跳过）
"""

import json
import os
import subprocess
import sys
import time
from collections import defaultdict
from datetime import datetime, timezone, timedelta
from pathlib import Path

TZ = timezone(timedelta(hours=8))
LONGXIA_DIR = Path.home() / ".hermes/longxia"
JOURNAL_DIR = LONGXIA_DIR / "journal"


def api_call(api_name: str, **params) -> dict:
    """调用微信读书 Agent Gateway"""
    api_key = os.environ.get("WEREAD_API_KEY")
    if not api_key:
        # 从 bashrc 提取
        bashrc = Path.home() / ".bashrc"
        if bashrc.exists():
            import re
            m = re.search(r'^export WEREAD_API_KEY="?([^"\n]+)"?', bashrc.read_text(), re.MULTILINE)
            if m:
                api_key = m.group(1)
                os.environ["WEREAD_API_KEY"] = api_key
    if not api_key:
        raise RuntimeError("WEREAD_API_KEY 未设置")

    body = {"api_name": api_name, "skill_version": "1.0.4", **params}
    result = subprocess.run([
        "curl", "-s", "-X", "POST",
        "https://i.weread.qq.com/api/agent/gateway",
        "-H", f"Authorization: Bearer {api_key}",
        "-H", "Content-Type: application/json",
        "-d", json.dumps(body)
    ], capture_output=True, text=True, timeout=30)

    data = json.loads(result.stdout)
    if "errcode" in data:
        raise RuntimeError(f"接口报错: {data.get('errmsg')} (errcode={data.get('errcode')})")
    return data


def fetch_all_notebooks() -> list[dict]:
    """分页拉完整 notebooks 列表"""
    all_books = []
    last_sort = None

    while True:
        params = {"count": 100}
        if last_sort is not None:
            params["lastSort"] = last_sort
        data = api_call("/user/notebooks", **params)
        books = data.get("books", [])
        all_books.extend(books)
        if not data.get("hasMore") or not books:
            break
        last_sort = books[-1].get("sort")
        time.sleep(0.3)

    return all_books


def fetch_bookmarks(book_id: str) -> dict:
    """拉单本书的划线"""
    return api_call("/book/bookmarklist", bookId=book_id)


def fetch_reviews(book_id: str) -> list[dict]:
    """拉单本书的想法"""
    # 注意：官方文档用 bookid（小写），bookmarklist 用 bookId
    data = api_call("/review/list/mine", bookid=book_id, count=50)
    return data.get("reviews", [])


def render_book_md(book_info: dict, chapters: list, bookmarks: list, reviews: list, today: str) -> str:
    """生成单本书的笔记 Markdown"""
    book = book_info
    book_id = book_info["bookId"]

    # 按章节分组
    ch_map = {ch["chapterUid"]: ch for ch in chapters}
    by_chapter = defaultdict(list)
    for bm in bookmarks:
        by_chapter[bm["chapterUid"]].append(bm)

    now = datetime.now(TZ).strftime("%Y-%m-%d %H:%M:%S")
    L = []
    L.append(f"# 📖 《{book['title']}》— 划线笔记")
    L.append("")
    L.append(f"> **作者**：{book['author']}")
    L.append(f"> **数据来源**：微信读书")
    L.append(f"> **拉取时间**：{now}")
    L.append(f"> **划线**：{len(bookmarks)} 条 / **想法**：{len(reviews)} 条")
    L.append(f"> **进度**：{book_info.get('readingProgress', 0)}%")
    L.append("")
    L.append("---")
    L.append("")

    # 章节概览
    if by_chapter:
        L.append("## 📑 章节概览")
        L.append("")
        for ch_uid in sorted(by_chapter.keys()):
            ch = ch_map.get(ch_uid, {})
            L.append(f"- **{ch.get('title', '?')}** — {len(by_chapter[ch_uid])} 条划线")
        L.append("")

    L.append("---")
    L.append("")

    # 划线详情
    if by_chapter:
        L.append("## 📚 全部划线")
        L.append("")
        for ch_uid in sorted(by_chapter.keys(), reverse=True):
            ch = ch_map.get(ch_uid, {})
            chapter_bms = sorted(by_chapter[ch_uid], key=lambda x: x["createTime"], reverse=True)
            L.append(f"### 📂 {ch.get('title', '未知章节')}")
            L.append("")
            for i, bm in enumerate(chapter_bms, 1):
                ts = datetime.fromtimestamp(bm["createTime"], TZ).strftime("%Y-%m-%d %H:%M:%S")
                jump = f"weread://bestbookmark?bookId={book_id}&chapterUid={ch_uid}&rangeStart={bm['range'].split('-')[0]}&rangeEnd={bm['range'].split('-')[1]}"
                L.append(f"**{i}. {ts}**")
                L.append("")
                L.append(f"> {bm['markText']}")
                L.append("")
                L.append(f"[📍 跳转原文]({jump})")
                L.append("")
            L.append("---")
            L.append("")

    # 想法
    L.append("## 💭 个人想法")
    L.append("")
    if reviews:
        for r in reviews:
            ts = datetime.fromtimestamp(r.get("createTime", 0), TZ).strftime("%Y-%m-%d %H:%M:%S")
            review_obj = r.get("review", {})
            content = review_obj.get("content", "") if isinstance(review_obj, dict) else r.get("content", "")
            L.append(f"**{ts}**")
            L.append("")
            L.append(f"> {content}")
            L.append("")
    else:
        L.append("_（这本书暂时没有个人想法）_")
        L.append("")

    L.append("---")
    L.append("")
    L.append(f"_本文件由 Hermes Agent 自动生成 · {now}_")
    L.append("")

    return "\n".join(L)


def main():
    today = datetime.now(TZ).strftime("%Y-%m-%d")
    today_start = datetime.now(TZ).replace(hour=0, minute=0, second=0, microsecond=0).timestamp()

    print(f"📅 今天是 {today}")
    print(f"🔑 Key 前缀: {os.environ.get('WEREAD_API_KEY', '?')[:4]}***")

    # 拉所有有笔记的书
    print("📚 拉取 notebooks 列表...")
    all_books = fetch_all_notebooks()
    print(f"   共 {len(all_books)} 本")

    # 筛选今天有活动的
    today_books = [
        b for b in all_books
        if b.get("sort", 0) >= today_start
    ]
    print(f"   今天有活动的: {len(today_books)} 本")

    if not today_books:
        print("✨ 今天没有新增笔记活动，无需拉取")
        return

    # 创建今日目录
    today_dir = JOURNAL_DIR / today
    today_dir.mkdir(parents=True, exist_ok=True)

    # 处理每本书
    for book_info in today_books:
        book = book_info.get("book", {})
        title = book.get("title", "?")
        book_id = book_info["bookId"]
        author = book.get("author", "未知作者")

        # 文件名：去掉特殊字符
        safe_title = "".join(c if c.isalnum() or c in "-_（）()《》" else "-" for c in title)
        out_file = today_dir / f"weread-{safe_title}.md"

        if out_file.exists() and out_file.stat().st_size > 500:
            print(f"  ⏭️  跳过（已存在）: {title}")
            continue

        print(f"  📖 拉取: 《{title}》 - {author}")

        try:
            bm_data = fetch_bookmarks(book_id)
            bookmarks = bm_data.get("updated", [])
            chapters = bm_data.get("chapters", [])

            reviews = fetch_reviews(book_id)

            content = render_book_md(book_info, chapters, bookmarks, reviews, today)
            out_file.write_text(content, encoding="utf-8")
            print(f"     ✅ {len(bookmarks)} 条划线 → {out_file.name}")

            time.sleep(0.5)  # 避免触发限流
        except Exception as e:
            print(f"     ❌ 失败: {e}")

    # 更新今日 index
    update_today_index(today, today_dir)

    print(f"\n🎉 完成！今日文件: {today_dir}")


def update_today_index(today: str, today_dir: Path):
    """更新或创建今日 index.md"""
    index_file = today_dir / "README.md"

    # 收集今日已有的笔记文件
    note_files = sorted(today_dir.glob("weread-*.md"))

    L = []
    L.append(f"# 📅 {today}")
    L.append("")
    L.append(f"> 自动生成的今日索引 · {datetime.now(TZ).strftime('%H:%M:%S')}")
    L.append("")
    L.append("## 📚 今日读书笔记")
    L.append("")
    if note_files:
        for f in note_files:
            # 提取书名（去掉前缀和后缀）
            name = f.stem.replace("weread-", "")
            L.append(f"- [{name}]({f.name})")
    else:
        L.append("_（今天还没有读书笔记）_")
    L.append("")

    # 保留已有内容
    if index_file.exists():
        existing = index_file.read_text(encoding="utf-8")
        # 简单粗暴：直接拼接（手动维护的部分用 HTML 注释分隔也行）
        # 这里用更安全的方式：保留 ## 之后的自定义内容
        import re
        m = re.search(r"## 🛠️.*", existing, re.DOTALL)
        if m:
            L.append(m.group())
    else:
        L.append("## 🛠️ 今日工作")
        L.append("")
        L.append("_（可手动补充）_")
        L.append("")

    L.append("---")
    L.append("")
    L.append("_本文件由 daily.sh 自动维护_")
    L.append("")

    index_file.write_text("\n".join(L), encoding="utf-8")
    print(f"  ✅ 今日 index: {index_file.name}")


if __name__ == "__main__":
    main()