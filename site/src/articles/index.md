---
title: 文章
---

# 📝 文章

> 真实记录，不定时更新。写 AI 工作流、终端安全、职业成长里的**真事**——包括失败的。

---

<div class="article-grid">
  <a href="/articles/2026-09-13-ai-workflow-postmortem" class="article-card">
    <div class="article-card-header">
      <span class="article-card-icon">🩺</span>
      <span class="article-card-date">2026-09-13</span>
    </div>
    <h2 class="article-card-title">我的 AI 工作流跑了 2 个月，然后全部停摆了</h2>
    <p class="article-card-summary">一名终端安全工程师的自查：装了 25 个 Skills、5 个自动化脚本、1 个网站，然后 8 月一整月零产出。用真实数据给自己做的一次尸检。</p>
    <div class="article-card-tags">
      <span class="article-tag">AI</span>
      <span class="article-tag">工作流</span>
      <span class="article-tag">复盘</span>
      <span class="article-tag">效率</span>
    </div>
    <div class="article-card-footer">
      <span>3400 字符</span>
      <div class="article-card-platforms">
        <span class="platform-icon" title="掘金">⛏️</span>
        <span class="platform-icon" title="知乎">📚</span>
        <span class="platform-icon" title="小红书">📱</span>
        <span class="platform-icon" title="头条">📰</span>
      </div>
    </div>
  </a>

  <a href="/articles/2026-07-16-25-skills" class="article-card">
    <div class="article-card-header">
      <span class="article-card-icon">🛠️</span>
      <span class="article-card-date">2026-07-16</span>
    </div>
    <h2 class="article-card-title">我装了 25 个 AI Skills 后，明白了一件事</h2>
    <p class="article-card-summary">一名终端安全工程师的实测：单个 AI Skill 改变不了什么，但 25 个 Skills 组成的工作流，真的能替代一个团队。</p>
    <div class="article-card-tags">
      <span class="article-tag">AI</span>
      <span class="article-tag">Skills</span>
      <span class="article-tag">效率</span>
      <span class="article-tag">工具</span>
      <span class="article-tag">程序员</span>
    </div>
    <div class="article-card-footer">
      <span>1339 中文字</span>
      <div class="article-card-platforms">
        <span class="platform-icon" title="掘金">⛏️</span>
        <span class="platform-icon" title="知乎">📚</span>
        <span class="platform-icon" title="小红书">📱</span>
        <span class="platform-icon" title="头条">📰</span>
      </div>
    </div>
  </a>

  <a href="/articles/2026-07-15-harness-era" class="article-card">
    <div class="article-card-header">
      <span class="article-card-icon">🔮</span>
      <span class="article-card-date">2026-07-15</span>
    </div>
    <h2 class="article-card-title">未来 3 年，软件工程师最值钱的技能不是写代码</h2>
    <p class="article-card-summary">一名终端安全工程师的 AI 时代顿悟：从"会写代码"到"会设计 Harness"，这是接下来 3-5 年软件工程最大的变革。</p>
    <div class="article-card-tags">
      <span class="article-tag">AI</span>
      <span class="article-tag">编程</span>
      <span class="article-tag">工程师</span>
      <span class="article-tag">Harness</span>
      <span class="article-tag">职业</span>
    </div>
    <div class="article-card-footer">
      <span>1532 中文字</span>
      <div class="article-card-platforms">
        <span class="platform-icon" title="掘金">⛏️</span>
        <span class="platform-icon" title="知乎">📚</span>
        <span class="platform-icon" title="小红书">📱</span>
        <span class="platform-icon" title="头条">📰</span>
      </div>
    </div>
  </a>
</div>

---

## 🚀 写新文章的流程

```bash
# 1. 写 markdown（放 articles/ 目录）
~/.hermes/longxia/articles/2026-XX-XX-slug.md

# 2. 一键分发成多平台版本
~/.hermes/longxia/scripts/publish-article.sh ~/.hermes/longxia/articles/2026-XX-XX-slug.md

# 3. 拷贝到网站 + 加卡片，然后部署
~/.hermes/longxia/daily-deploy.sh

# 4. 各平台版本在 articles/dist/ 下
```

## 📌 发布平台（2026-09 起）

| 优先级 | 平台 | 说明 |
|--------|------|------|
| 🥇 | **掘金 / CSDN / 博客园** | 技术向，支持 markdown 直接粘贴，冷启动快 |
| 🥈 | **知乎 / 今日头条** | 流量池大 |
| 🥉 | **小红书** | 拉新导流 |
| ❌ | ~~公众号~~ | 账号已被封，停用 |

> **发布纪律**：发出一篇 → 立刻把链接记进 `notes/output-tracker.md`。没记链接 = 没完成。
