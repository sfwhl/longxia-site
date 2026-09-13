---
layout: home

hero:
  name: "小龙"
  text: "终端安全开发工程师"
  tagline: |
    持续学习 Go + Windows 驱动 + 软件逆向。
    每天一本书、每天一条感悟、每天一行代码。
  actions:
    - theme: brand
      text: 查看感悟
      link: /thoughts/
    - theme: alt
      text: 25 个 Skills
      link: /skills/
    - theme: alt
      text: 公众号文章
      link: /articles/
    - theme: alt
      text: Go 学习计划
      link: /learning/

features:
  - title: 💡 每日感悟
    details: 6 条感悟 — 从"早起做自己"到"未来是 Harness 时代"，组成完整个人 OS
    link: /thoughts/
    linkText: 进入
  - title: 📚 读书笔记
    details: 2 本书 + 63 条划线 + 5 大主题归类。读完立刻可做的 3 件事
    link: /journal/2026-07-15/
    linkText: 进入
  - title: 📝 公众号文章
    details: 2 篇文章自动生成 4 平台版本（公众号 / 小红书 / 头条 / 知乎）
    link: /articles/
    linkText: 进入
  - title: 🛠️ Skills 库
    details: 25 个 AI Skills，按 11 个场景分类。最新的 5 个已专门展示
    link: /skills/
    linkText: 进入
---

<style>
:root {
  /* 终端机美学配色 - 重写 VitePress 默认 */
  --vp-c-brand-1: #FFB000;
  --vp-c-brand-2: #FFB000;
  --vp-c-brand-3: #B37D00;
  --vp-c-brand-soft: rgba(255, 176, 0, 0.14);

  --vp-home-hero-name-color: transparent;
  --vp-home-hero-name-background: linear-gradient(
    120deg,
    #FFB000 30%,
    #FFD566 70%
  );

  --vp-button-brand-bg: #FFB000;
  --vp-button-brand-hover-bg: #FFD566;
  --vp-button-brand-active-bg: #B37D00;
  --vp-button-brand-text: #0E0E12;

  --vp-button-alt-bg: transparent;
  --vp-button-alt-border: #FFB000;
  --vp-button-alt-text: #FFB000;
  --vp-button-alt-hover-bg: rgba(255, 176, 0, 0.1);
  --vp-button-alt-hover-text: #FFD566;
}

.VPHero .name,
.VPHero .text {
  background: linear-gradient(120deg, #FFB000 30%, #FFD566 70%);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  font-family: 'JetBrains Mono', monospace !important;
  font-weight: 700;
  letter-spacing: -0.02em;
}

.VPHero .tagline {
  font-family: 'IBM Plex Sans', sans-serif !important;
  color: #A8A6A0 !important;
  font-size: 1.1rem !important;
  line-height: 1.7 !important;
}

.VPButton {
  font-family: 'JetBrains Mono', monospace !important;
  letter-spacing: 0.05em !important;
  border-radius: 2px !important;
  font-weight: 500 !important;
}

.VPButton::before {
  content: "→ ";
  margin-right: 4px;
  opacity: 0.7;
}

.VPFeatures {
  margin-top: 64px !important;
}

.VPFeature {
  background: var(--bg-panel, #15151B);
  border: 1px solid var(--border-dim, #2A2A35);
  border-left: 3px solid #FFB000;
  padding: 24px !important;
  transition: all 200ms ease;
  border-radius: 0 4px 4px 0 !important;
}

.VPFeature:hover {
  background: var(--bg-elevated, #1C1C24);
  transform: translateX(2px);
  box-shadow: 0 0 24px rgba(255, 176, 0, 0.08);
}

.VPFeature .title {
  font-family: 'JetBrains Mono', monospace !important;
  color: #FFB000 !important;
  font-weight: 700 !important;
}

.VPFeature .details {
  color: #A8A6A0 !important;
  font-size: 14px !important;
  line-height: 1.7 !important;
}

.VPFeature .link-text {
  color: #FFB000 !important;
  font-family: 'JetBrains Mono', monospace !important;
  font-size: 12px !important;
}

/* === Hero 装饰：终端机启动 === */
.VPHero::before {
  content: "$ whoami";
  position: absolute;
  top: 20px;
  left: 50%;
  transform: translateX(-50%);
  font-family: 'JetBrains Mono', monospace;
  color: #FFB000;
  font-size: 13px;
  opacity: 0.4;
  letter-spacing: 0.1em;
}

/* === 数据概览 (写在 layout 后) === */
.terminal-stats-block {
  max-width: 800px;
  margin: 64px auto 0;
  padding: 24px;
  background: #15151B;
  border: 1px solid #2A2A35;
  border-left: 3px solid #FFB000;
}

.terminal-stats-title {
  font-family: 'JetBrains Mono', monospace;
  color: #FFB000;
  font-size: 12px;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  margin-bottom: 16px;
}

.terminal-stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
  gap: 16px;
}

.terminal-stat {
  border-left: 2px solid #3D3D4A;
  padding-left: 12px;
}

.terminal-stat-label {
  font-family: 'JetBrains Mono', monospace;
  font-size: 10px;
  color: #6B6B70;
  text-transform: uppercase;
  letter-spacing: 0.1em;
}

.terminal-stat-value {
  font-family: 'JetBrains Mono', monospace;
  font-size: 1.5rem;
  color: #FFB000;
  font-weight: 700;
  margin-top: 4px;
}

.terminal-stat-suffix {
  font-size: 0.8rem;
  color: #A8A6A0;
  margin-left: 4px;
  font-weight: 400;
}

/* === 最新感悟（homepage footer） === */
.home-recent {
  max-width: 960px;
  margin: 80px auto 0;
  padding: 0 24px;
}

.home-recent h2 {
  font-family: 'JetBrains Mono', monospace !important;
  font-size: 1.3rem;
  color: #E8E6E0;
  margin-bottom: 16px;
  padding-bottom: 8px;
  border-bottom: 1px solid #3D3D4A;
  display: flex;
  align-items: center;
  gap: 8px;
}

.home-recent h2::before {
  content: "▍";
  color: #FFB000;
  font-size: 1.5rem;
}

.home-recent-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.home-recent-item {
  padding: 12px 0;
  border-bottom: 1px dashed #2A2A35;
  display: flex;
  align-items: baseline;
  gap: 16px;
}

.home-recent-item:last-child { border-bottom: none; }

.home-recent-date {
  font-family: 'JetBrains Mono', monospace;
  color: #6B6B70;
  font-size: 12px;
  min-width: 100px;
  flex-shrink: 0;
}

.home-recent-item a {
  color: #E8E6E0;
  text-decoration: none;
  flex: 1;
  border-bottom: 1px dotted transparent;
  transition: all 200ms;
}

.home-recent-item a:hover {
  color: #FFB000;
  border-bottom-color: #FFB000;
}

/* === 扫描线（CRT 效果） === */
.VPDoc::before {
  content: "";
  position: fixed;
  top: 0; left: 0; right: 0; bottom: 0;
  pointer-events: none;
  background: repeating-linear-gradient(
    0deg,
    transparent,
    transparent 2px,
    rgba(255, 176, 0, 0.015) 2px,
    rgba(255, 176, 0, 0.015) 4px
  );
  z-index: 9999;
}
</style>

<div class="terminal-stats-block">
  <div class="terminal-stats-title">// 系统状态 (2026-07-16)</div>
  <div class="terminal-stats-grid">
    <div class="terminal-stat">
      <div class="terminal-stat-label">Skills</div>
      <div class="terminal-stat-value">25<span class="terminal-stat-suffix">个</span></div>
    </div>
    <div class="terminal-stat">
      <div class="terminal-stat-label">感悟</div>
      <div class="terminal-stat-value">6<span class="terminal-stat-suffix">条</span></div>
    </div>
    <div class="terminal-stat">
      <div class="terminal-stat-label">划线</div>
      <div class="terminal-stat-value">63<span class="terminal-stat-suffix">条</span></div>
    </div>
    <div class="terminal-stat">
      <div class="terminal-stat-label">文章</div>
      <div class="terminal-stat-value">2<span class="terminal-stat-suffix">篇</span></div>
    </div>
    <div class="terminal-stat">
      <div class="terminal-stat-label">学习进度</div>
      <div class="terminal-stat-value">1<span class="terminal-stat-suffix">/30</span></div>
    </div>
  </div>
</div>

<div class="home-recent">
  <h2>最新感悟</h2>
  <ul class="home-recent-list">
    <li class="home-recent-item">
      <span class="home-recent-date">2026-07-15</span>
      <a href="/thoughts/2026-07-15/evening/">未来 3-5 年软件工程最大变化：瓶颈从"写代码"转向"Self-verifying Harness"</a>
    </li>
    <li class="home-recent-item">
      <span class="home-recent-date">2026-07-15</span>
      <a href="/thoughts/2026-07-15/afternoon/">上班 = 训练自己的 LLM，用 AI 做杠杆</a>
    </li>
    <li class="home-recent-item">
      <span class="home-recent-date">2026-07-15</span>
      <a href="/thoughts/2026-07-15/morning/">人和 AI 一样，是个可增量训练的系统</a>
    </li>
    <li class="home-recent-item">
      <span class="home-recent-date">2026-07-14</span>
      <a href="/thoughts/2026-07-14/midday/">费曼 + 自我对话 + 思维导图 + 刨根问底（"把任何事都搞透"的方法论）</a>
    </li>
    <li class="home-recent-item">
      <span class="home-recent-date">2026-07-14</span>
      <a href="/thoughts/2026-07-14/early/">早点起床，精神满满，内心做真正的自己</a>
    </li>
    <li class="home-recent-item">
      <span class="home-recent-date">2026-07-13</span>
      <a href="/thoughts/2026-07-13/">早起，才能做自己</a>
    </li>
  </ul>
</div>