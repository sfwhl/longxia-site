# 🛠️ 小龙的个人 Skill 技能库

> 本仓库记录我（小龙）安装到 Hermes Agent 的所有 skills，作为个人 Skill 技能库的种子数据。
> 最后更新：2026-07-31 17:40:08 · 共 **34** 个 skills（另含 1 个备份）

---

## 💡 待评估候选（只记录未安装）

这些是评估过但暂未安装的 skill，等需要时再装。

### ✅ 已确认（2026-07-17 装上）

- **humanizer-zh** ✅ 已装（33961 下）：去 AI 写作痕迹，让 AI 文像人话
- **web-access-plus** ✅ 已装（283 下）：Playwright 浏览器自动化（小龙拼作 "playwrite"）

> 注：之前记录的 `cotenttext` 推测作废。实际小龙需求是 playwright（浏览器自动化）。

### 📌 候选（如果确认要"内容提取"方向）

- **公众号内容提取** (2778 下)：从公众号抓文章保存为 Markdown
- **网页内容提取** (112 下)：网页/公众号/知识平台结构化提取
- **ima-skills** (105446 下)：笔记/知识库读取写入检索

### 📌 候选（如果确认要"上下文/记忆"方向）

- **跨会话记忆桥** (302 下)：AI 跨会话记住项目进度
- **记忆使用技能** (2133 下)：解决 AI 记忆混乱（今天讲明天忘）
- **记忆管家** (1850 下)：多 Agent 上下文监控与记忆管理
- **Context Overflow Recovery** (140 下)：上下文溢出恢复

---
---
---
---
---

## 📊 概览

| 一级分类 | 数量 |
|----------|------|
| `general` | 12 |
| `software-development` | 12 |
| `productivity` | 4 |
| `autonomous-ai-agents` | 2 |
| `creative` | 2 |
| `research` | 1 |
| `github` | 1 |
| **总计** | **34** |

### 🆕 最近安装

- **2026-07-31** — `agent-proactive-mode` (agent-proactive-mode)
- **2026-07-31** — `find-skill-skillhub` (find-skill-skillhub)
- **2026-07-27** — `web-access-plus` (web-access)
- **2026-07-25** — `ai-dev-discipline` (ai-dev-discipline)
- **2026-07-23** — `weread-skills-official` (wechat-reading)

> 💡 **关于「安装原因」**：首次生成时我帮你自动推断一条（基于 skill 名称/功能），
> 其它需要你手动补充。你可以直接编辑这个 Markdown 文件，
> 下次跑 `python3 generate.py`（不带 `--init`）会自动保留你已填写的。

---

## 📝 全部 Skills（含安装原因）

### 📦 agent-proactive-mode

| 字段 | 值 |
|------|----|
| **Slug** | `agent-proactive-mode` |
| **显示名** | agent-proactive-mode |
| **版本** | ? |
| **一级分类** | `autonomous-ai-agents` |
| **安装日期** | 2026-07-31 11:32:09 |
| **本地路径** | `/home/ubuntu/.hermes/skills/autonomous-ai-agents/agent-proactive-mode` |
| **文件数** | 8 |
| **大小** | 46,274 字节 (45.2 KB) |
| **来源** | bundled |

**简介**：AI 不再被动等指挥的工作模式（小龙 2026-07-17 根本性指令的提炼）。覆盖：主动反思与质疑、5 问清单评估机会、拖延式探索反模式、用户问"心态/工作观"等元问题时的真实回应、与"已成功的同行"对比时不阿谀不顺从、用户要求"AI 一直干活"时的自主执行模式。触发：用户给了工作模式变更指令；用户在表达"停滞/重复/想副业但不知方向"的状态；用户问了关于工作方式/心态/优先级的元问题；AI 自己写完交付物后不知道下一步；用户说"你要一直干活"。

**🎯 安装原因**： （待补充：你装这个 skill 是为了做什么？）

---

### 📦 find-skill-skillhub

| 字段 | 值 |
|------|----|
| **Slug** | `find-skill-skillhub` |
| **显示名** | find-skill-skillhub |
| **版本** | ? |
| **一级分类** | `general` |
| **安装日期** | 2026-07-31 08:22:41 |
| **本地路径** | `/home/ubuntu/.hermes/skills/find-skill-skillhub` |
| **文件数** | 16 |
| **大小** | 19,644 字节 (19.2 KB) |
| **来源** | bundled |

**简介**：在 SkillHub 平台查找/搜索 Skill 技能。基于 skills 列表接口，支持关键词分词搜索、一级标签（一级分类）筛选、以及二者组合检索。当用户说『找个 xxx 技能』『有没有处理 PDF 的 skill』『SkillHub 上搜一下 xxx』『按分类看技能』『办公效率类有哪些技能』『推荐一个做数据分析的 skill』『这个需求有现成技能吗』等需要在 SkillHub 上发现/检索/推荐 Skill 的场景时使用本技能。

**🎯 安装原因**： 在 SkillHub 检索 / 发现 skills

---

### 📦 web-access

| 字段 | 值 |
|------|----|
| **Slug** | `web-access-plus` |
| **显示名** | web-access |
| **版本** | ? |
| **一级分类** | `general` |
| **安装日期** | 2026-07-27 10:39:38 |
| **本地路径** | `/home/ubuntu/.hermes/skills/web-access-plus` |
| **文件数** | 16 |
| **大小** | 104,685 字节 (102.2 KB) |
| **来源** | bundled |

**简介**：

**🎯 安装原因**： （待补充：你装这个 skill 是为了做什么？）

---

### 📦 ai-dev-discipline

| 字段 | 值 |
|------|----|
| **Slug** | `ai-dev-discipline` |
| **显示名** | ai-dev-discipline |
| **版本** | ? |
| **一级分类** | `software-development` |
| **安装日期** | 2026-07-25 10:15:39 |
| **本地路径** | `/home/ubuntu/.hermes/skills/software-development/ai-dev-discipline` |
| **文件数** | 4 |
| **大小** | 25,849 字节 (25.2 KB) |
| **来源** | bundled |

**简介**：AI 时代的陌生功能开发纪律（小龙 2026-07-23 实战复盘总结）。AI 降低编码成本但不降低方案/模块理解/联调/质量成本。任何涉及陌生功能、陌生模块、新方案、新代码的需求开发任务都必须走 8 步流程（代码理解→需求澄清→方案设计→方案评审→任务拆解→AI 辅助编码→人工审核→验证闭环），并满足 4 个前置门（接触过吗/需求清晰吗/代码理解度/TL 评审了吗）才能进入大规模编码。核心底线：代码可由 AI 生成，但方案必须由人掌控，逻辑必须由人理解，质量必须由人负责。触发：用户说开发/实现/写代码/调研/新功能/新模块/编码/落地 等词；用户描述一个不熟悉的功能；AI 准备给方案但用户没说清需求。

**🎯 安装原因**： （待补充：你装这个 skill 是为了做什么？）

---

### 📦 wechat-reading

| 字段 | 值 |
|------|----|
| **Slug** | `weread-skills-official` |
| **显示名** | wechat-reading |
| **版本** | 1.0.4 |
| **一级分类** | `general` |
| **安装日期** | 2026-07-23 08:27:01 |
| **本地路径** | `/home/ubuntu/.hermes/skills/weread-skills-official` |
| **文件数** | 13 |
| **大小** | 91,571 字节 (89.4 KB) |
| **来源** | bundled |

**简介**：微信读书助手 — 搜索书籍、管理书架、查看笔记划线、浏览书评、阅读统计、发现推荐好书。包含 SkillHub SDK 升级流程、"最近笔记"工作流、Key 陷阱。

**🎯 安装原因**： 提取微信读书的划线/笔记/想法，整理成个人知识库

---

### 📦 personal-site-vitepress-deploy

| 字段 | 值 |
|------|----|
| **Slug** | `personal-site-vitepress-deploy` |
| **显示名** | personal-site-vitepress-deploy |
| **版本** | ? |
| **一级分类** | `software-development` |
| **安装日期** | 2026-07-23 08:26:01 |
| **本地路径** | `/home/ubuntu/.hermes/skills/software-development/personal-site-vitepress-deploy` |
| **文件数** | 24 |
| **大小** | 199,971 字节 (195.3 KB) |
| **来源** | bundled |

**简介**：用 VitePress 搭个人博客 / 知识库 / Skill 技能库的轻量级静态站，覆盖本地开发、主题定制（Layout slot、强制 dark mode、custom.css 重写 VitePress 变量）、卡片化布局、内容同步（rsync vs symlink 决策）、一键部署到 Vercel 或自建 VPS（Caddy + /var/www/），集成 minimaxi 视觉 API 做截图分析（替代不可用的 browser_vision，模型 `MiniMax-Text-01` + 端点 `/v1/text/chatcompletion_v2`），按 Anthropic frontend-design skill 方法论避 3 种 AI 默认设计（奶白底/荧光黑客/报纸风）。集成 vibe-usage CLI 追踪 token 用量、AI 主动反思机制（不被动等指挥）。触发：用户要把个人 Markdown / 笔记 / Skill 清单做成可访问的网站，且偏好"轻量级、可定制、无后端"；或用户指令 AI 工作模式需要主动反思推进。

**🎯 安装原因**： （待补充：你装这个 skill 是为了做什么？）

---

### 📦 context7-cli

| 字段 | 值 |
|------|----|
| **Slug** | `context7-cli` |
| **显示名** | context7-cli |
| **版本** | ? |
| **一级分类** | `general` |
| **安装日期** | 2026-07-21 20:01:04 |
| **本地路径** | `/home/ubuntu/.hermes/skills/context7-cli` |
| **文件数** | 3 |
| **大小** | 3,933 字节 (3.8 KB) |
| **来源** | bundled |

**简介**：Manage Context7 via CLI - search libraries, get documentation context. Use when user mentions 'context7', 'library docs', 'documentation context', or wants to fetch up-to-date library documentation.

**🎯 安装原因**： （待补充：你装这个 skill 是为了做什么？）

---

### 📦 hermes-desktop-plugins

| 字段 | 值 |
|------|----|
| **Slug** | `hermes-desktop-plugins` |
| **显示名** | hermes-desktop-plugins |
| **版本** | 1.0.0 |
| **一级分类** | `general` |
| **安装日期** | 2026-07-21 02:35:21 |
| **本地路径** | `/home/ubuntu/.hermes/skills/hermes-desktop-plugins` |
| **文件数** | 2 |
| **大小** | 11,990 字节 (11.7 KB) |
| **来源** | bundled |

**简介**：Write desktop app plugins that add UI panes and commands.

**🎯 安装原因**： 配置 / 扩展 Hermes Agent

---

### 📦 hermes-agent

| 字段 | 值 |
|------|----|
| **Slug** | `hermes-agent` |
| **显示名** | hermes-agent |
| **版本** | 2.3.0 |
| **一级分类** | `autonomous-ai-agents` |
| **安装日期** | 2026-07-21 02:35:21 |
| **本地路径** | `/home/ubuntu/.hermes/skills/autonomous-ai-agents/hermes-agent` |
| **文件数** | 3 |
| **大小** | 71,635 字节 (70.0 KB) |
| **来源** | bundled |

**简介**：Configure, extend, or contribute to Hermes Agent.

**🎯 安装原因**： 配置 / 扩展 Hermes Agent

---

### 📦 humanizer

| 字段 | 值 |
|------|----|
| **Slug** | `humanizer` |
| **显示名** | humanizer |
| **版本** | 2.5.1 |
| **一级分类** | `creative` |
| **安装日期** | 2026-07-21 02:35:21 |
| **本地路径** | `/home/ubuntu/.hermes/skills/creative/humanizer` |
| **文件数** | 2 |
| **大小** | 35,529 字节 (34.7 KB) |
| **来源** | bundled |

**简介**：Humanize text: strip AI-isms and add real voice.

**🎯 安装原因**： 把 AI 生成的文本改得更像人话，去除 AI 痕迹

---

### 📦 threat-analysis-apcdr

| 字段 | 值 |
|------|----|
| **Slug** | `threat-analysis-apcdr` |
| **显示名** | threat-analysis-apcdr |
| **版本** | ? |
| **一级分类** | `software-development` |
| **安装日期** | 2026-07-20 09:12:10 |
| **本地路径** | `/home/ubuntu/.hermes/skills/software-development/threat-analysis-apcdr` |
| **文件数** | 2 |
| **大小** | 23,459 字节 (22.9 KB) |
| **来源** | bundled |

**简介**：用 AI 加持的 5 阶段威胁分析快速落地方法论（APCDR），从未知样本到 C++ 检测代码 ≤ 4 小时。覆盖静态分析、动态测试、关联情报、检测设计（minifilter / ob callback / ETW + YARA）、应急处置。触发：用户给新威胁样本（勒索 / 挖矿 / APT / 木马），要求快速分析或给出 C++ 检测代码 / YARA 规则 / 应急 SOP。

**🎯 安装原因**： （待补充：你装这个 skill 是为了做什么？）

---

### 📦 humanizer-zh

| 字段 | 值 |
|------|----|
| **Slug** | `humanizer-zh` |
| **显示名** | humanizer-zh |
| **版本** | ? |
| **一级分类** | `general` |
| **安装日期** | 2026-07-20 09:04:45 |
| **本地路径** | `/home/ubuntu/.hermes/skills/humanizer-zh` |
| **文件数** | 3 |
| **大小** | 26,828 字节 (26.2 KB) |
| **来源** | bundled |

**简介**：|

**🎯 安装原因**： 把 AI 生成的文本改得更像人话，去除 AI 痕迹

---

### 📦 json-int-key-pitfall

| 字段 | 值 |
|------|----|
| **Slug** | `json-int-key-pitfall` |
| **显示名** | json-int-key-pitfall |
| **版本** | ? |
| **一级分类** | `software-development` |
| **安装日期** | 2026-07-16 11:32:14 |
| **本地路径** | `/home/ubuntu/.hermes/skills/software-development/json-int-key-pitfall` |
| **文件数** | 1 |
| **大小** | 3,294 字节 (3.2 KB) |
| **来源** | bundled |

**简介**：Reference note — when writing/loading JSON, dict's integer keys are silently coerced to strings by json.dump/json.load. Capture any JSON-edge-case workaround under this one-pager so the next session doesn't re-discover it.

**🎯 安装原因**： （待补充：你装这个 skill 是为了做什么？）

---

### 📦 api-key-safety-probe

| 字段 | 值 |
|------|----|
| **Slug** | `api-key-safety-probe` |
| **显示名** | api-key-safety-probe |
| **版本** | 1.0.0 |
| **一级分类** | `general` |
| **安装日期** | 2026-07-16 08:37:18 |
| **本地路径** | `/home/ubuntu/.hermes/skills/api-key-safety-probe` |
| **文件数** | 3 |
| **大小** | 33,103 字节 (32.3 KB) |
| **来源** | bundled |

**简介**：当用户或第三方凭证(API Key、token、cookie)可能要在本机执行外部命令或调用第三方 API 时使用——验证凭证真伪、隔离副作用、应对强制执行压力。包括微信读书 wrk- Key 实测的准一次性陷阱,以及通用外部凭证的安全操作模板。

**🎯 安装原因**： 处理可疑凭证时的安全探针

---

### 📦 superpowers

| 字段 | 值 |
|------|----|
| **Slug** | `superpowers-skill` |
| **显示名** | superpowers |
| **版本** | ? |
| **一级分类** | `general` |
| **安装日期** | 2026-07-15 10:42:20 |
| **本地路径** | `/home/ubuntu/.hermes/skills/superpowers-skill` |
| **文件数** | 4 |
| **大小** | 14,063 字节 (13.7 KB) |
| **来源** | bundled |

**简介**：A complete software development methodology and skill composition system, ported from obra/superpowers. Provides structured, repeatable workflow: brainstorming, design, planning, TDD, subagent-driven dev, code review, finishing branch. Use for coding, building projects, refactoring, bug fixing, or any programming tasks.

**🎯 安装原因**： （待补充：你装这个 skill 是为了做什么？）

---

### 📦 anysearch

| 字段 | 值 |
|------|----|
| **Slug** | `anysearch` |
| **显示名** | anysearch |
| **版本** | 2.1.0 |
| **一级分类** | `general` |
| **安装日期** | 2026-07-15 10:38:18 |
| **本地路径** | `/home/ubuntu/.hermes/skills/anysearch` |
| **文件数** | 10 |
| **大小** | 85,700 字节 (83.7 KB) |
| **来源** | bundled |

**简介**：Real-time search engine supporting web search, vertical domain search, parallel batch search, and URL content extraction.

**🎯 安装原因**： （待补充：你装这个 skill 是为了做什么？）

---

### 📦 writing-expert-team

| 字段 | 值 |
|------|----|
| **Slug** | `writing-expert-team-pro-sl` |
| **显示名** | writing-expert-team |
| **版本** | 1.1.0 |
| **一级分类** | `general` |
| **安装日期** | 2026-07-15 09:10:39 |
| **本地路径** | `/home/ubuntu/.hermes/skills/writing-expert-team-pro-sl` |
| **文件数** | 20 |
| **大小** | 117,024 字节 (114.3 KB) |
| **来源** | bundled |

**简介**：写作全流程助手：把模糊想法、零散素材、已有文本、用户授权知识库、读书笔记或公开资料，转化为结构清晰、观点鲜明、风格统一、事实可靠、适合发布的高质量内容。适用于选题策划、大纲设计、初稿写作、文章润色、个人风格参考、素材变文章、标题优化、事实核查、多平台改写、管理者表达、商业写作和个人品牌内容创作。

**🎯 安装原因**： （待补充：你装这个 skill 是为了做什么？）

---

### 📦 find-skill-skillhub

| 字段 | 值 |
|------|----|
| **Slug** | `find-skill-skillhub` |
| **显示名** | find-skill-skillhub |
| **版本** | ? |
| **一级分类** | `general` |
| **安装日期** | 2026-07-09 16:10:15 |
| **本地路径** | `/home/ubuntu/.agents/skills/find-skill-skillhub` |
| **文件数** | 16 |
| **大小** | 19,644 字节 (19.2 KB) |
| **来源** | external |

**简介**：在 SkillHub 平台查找/搜索 Skill 技能。基于 skills 列表接口，支持关键词分词搜索、一级标签（一级分类）筛选、以及二者组合检索。当用户说『找个 xxx 技能』『有没有处理 PDF 的 skill』『SkillHub 上搜一下 xxx』『按分类看技能』『办公效率类有哪些技能』『推荐一个做数据分析的 skill』『这个需求有现成技能吗』等需要在 SkillHub 上发现/检索/推荐 Skill 的场景时使用本技能。

**🎯 安装原因**： 在 SkillHub 检索 / 发现 skills

---

### 📦 dogfood

| 字段 | 值 |
|------|----|
| **Slug** | `dogfood` |
| **显示名** | dogfood |
| **版本** | 1.0.0 |
| **一级分类** | `general` |
| **安装日期** | 2026-07-09 16:06:49 |
| **本地路径** | `/home/ubuntu/.hermes/skills/dogfood` |
| **文件数** | 3 |
| **大小** | 11,480 字节 (11.2 KB) |
| **来源** | bundled |

**简介**：Exploratory QA of web apps: find bugs, evidence, reports.

**🎯 安装原因**： 对 web app 做探索性 QA 找 bug

---

### 📦 nano-pdf

| 字段 | 值 |
|------|----|
| **Slug** | `nano-pdf` |
| **显示名** | nano-pdf |
| **版本** | 1.0.0 |
| **一级分类** | `productivity` |
| **安装日期** | 2026-07-09 16:06:49 |
| **本地路径** | `/home/ubuntu/.hermes/skills/productivity/nano-pdf` |
| **文件数** | 1 |
| **大小** | 1,414 字节 (1.4 KB) |
| **来源** | bundled |

**简介**：Edit PDF text/typos/titles via nano-pdf CLI (NL prompts).

**🎯 安装原因**： 处理 PDF / OCR 文档相关

---

### 📦 ocr-and-documents

| 字段 | 值 |
|------|----|
| **Slug** | `ocr-and-documents` |
| **显示名** | ocr-and-documents |
| **版本** | 2.3.0 |
| **一级分类** | `productivity` |
| **安装日期** | 2026-07-09 16:06:49 |
| **本地路径** | `/home/ubuntu/.hermes/skills/productivity/ocr-and-documents` |
| **文件数** | 4 |
| **大小** | 11,593 字节 (11.3 KB) |
| **来源** | bundled |

**简介**：Extract text from PDFs/scans (pymupdf, marker-pdf).

**🎯 安装原因**： 处理 PDF / OCR 文档相关

---

### 📦 powerpoint

| 字段 | 值 |
|------|----|
| **Slug** | `powerpoint` |
| **显示名** | powerpoint |
| **版本** | ? |
| **一级分类** | `productivity` |
| **安装日期** | 2026-07-09 16:06:49 |
| **本地路径** | `/home/ubuntu/.hermes/skills/productivity/powerpoint` |
| **文件数** | 50 |
| **大小** | 1,040,149 字节 (1015.8 KB) |
| **来源** | bundled |

**简介**：Create, read, edit .pptx decks, slides, notes, templates.

**🎯 安装原因**： 创建 / 编辑 PPT 演示文稿

---

### 📦 maps

| 字段 | 值 |
|------|----|
| **Slug** | `maps` |
| **显示名** | maps |
| **版本** | 1.2.0 |
| **一级分类** | `productivity` |
| **安装日期** | 2026-07-09 16:06:49 |
| **本地路径** | `/home/ubuntu/.hermes/skills/productivity/maps` |
| **文件数** | 2 |
| **大小** | 53,404 字节 (52.2 KB) |
| **来源** | bundled |

**简介**：Geocode, POIs, routes, timezones via OpenStreetMap/OSRM.

**🎯 安装原因**： 地理编码 / 路径规划 / 时区

---

### 📦 architecture-diagram

| 字段 | 值 |
|------|----|
| **Slug** | `architecture-diagram` |
| **显示名** | architecture-diagram |
| **版本** | 1.0.0 |
| **一级分类** | `creative` |
| **安装日期** | 2026-07-09 16:06:49 |
| **本地路径** | `/home/ubuntu/.hermes/skills/creative/architecture-diagram` |
| **文件数** | 2 |
| **大小** | 18,313 字节 (17.9 KB) |
| **来源** | bundled |

**简介**：Dark-themed SVG architecture/cloud/infra diagrams as HTML.

**🎯 安装原因**： 生成架构图 / 系统设计图

---

### 📦 arxiv

| 字段 | 值 |
|------|----|
| **Slug** | `arxiv` |
| **显示名** | arxiv |
| **版本** | 1.0.0 |
| **一级分类** | `research` |
| **安装日期** | 2026-07-09 16:06:49 |
| **本地路径** | `/home/ubuntu/.hermes/skills/research/arxiv` |
| **文件数** | 2 |
| **大小** | 14,357 字节 (14.0 KB) |
| **来源** | bundled |

**简介**：Search arXiv papers by keyword, author, category, or ID.

**🎯 安装原因**： 学术论文检索 / 文献调研

---

### 📦 plan

| 字段 | 值 |
|------|----|
| **Slug** | `plan` |
| **显示名** | plan |
| **版本** | 2.0.0 |
| **一级分类** | `software-development` |
| **安装日期** | 2026-07-09 16:06:49 |
| **本地路径** | `/home/ubuntu/.hermes/skills/software-development/plan` |
| **文件数** | 1 |
| **大小** | 8,974 字节 (8.8 KB) |
| **来源** | bundled |

**简介**：Plan mode: write an actionable markdown plan to .hermes/plans/, no execution. Bite-sized tasks, exact paths, complete code.

**🎯 安装原因**： 进入计划模式，把任务拆成可执行步骤

---

### 📦 test-driven-development

| 字段 | 值 |
|------|----|
| **Slug** | `test-driven-development` |
| **显示名** | test-driven-development |
| **版本** | 1.1.0 |
| **一级分类** | `software-development` |
| **安装日期** | 2026-07-09 16:06:49 |
| **本地路径** | `/home/ubuntu/.hermes/skills/software-development/test-driven-development` |
| **文件数** | 1 |
| **大小** | 10,306 字节 (10.1 KB) |
| **来源** | bundled |

**简介**：TDD: enforce RED-GREEN-REFACTOR, tests before code.

**🎯 安装原因**： 测试驱动开发，强制 RED-GREEN-REFACTOR

---

### 📦 python-debugpy

| 字段 | 值 |
|------|----|
| **Slug** | `python-debugpy` |
| **显示名** | python-debugpy |
| **版本** | 1.0.0 |
| **一级分类** | `software-development` |
| **安装日期** | 2026-07-09 16:06:49 |
| **本地路径** | `/home/ubuntu/.hermes/skills/software-development/python-debugpy` |
| **文件数** | 1 |
| **大小** | 13,172 字节 (12.9 KB) |
| **来源** | bundled |

**简介**：Debug Python: pdb REPL + debugpy remote (DAP).

**🎯 安装原因**： Python / Node.js 代码调试

---

### 📦 hermes-agent-skill-authoring

| 字段 | 值 |
|------|----|
| **Slug** | `hermes-agent-skill-authoring` |
| **显示名** | hermes-agent-skill-authoring |
| **版本** | 1.1.0 |
| **一级分类** | `software-development` |
| **安装日期** | 2026-07-09 16:06:49 |
| **本地路径** | `/home/ubuntu/.hermes/skills/software-development/hermes-agent-skill-authoring` |
| **文件数** | 1 |
| **大小** | 10,651 字节 (10.4 KB) |
| **来源** | bundled |

**简介**：Author in-repo SKILL.md: frontmatter, validator, structure, and writing-quality principles.

**🎯 安装原因**： 配置 / 扩展 Hermes Agent

---

### 📦 requesting-code-review

| 字段 | 值 |
|------|----|
| **Slug** | `requesting-code-review` |
| **显示名** | requesting-code-review |
| **版本** | 2.0.0 |
| **一级分类** | `software-development` |
| **安装日期** | 2026-07-09 16:06:49 |
| **本地路径** | `/home/ubuntu/.hermes/skills/software-development/requesting-code-review` |
| **文件数** | 1 |
| **大小** | 8,465 字节 (8.3 KB) |
| **来源** | bundled |

**简介**：Pre-commit review: security scan, quality gates, auto-fix.

**🎯 安装原因**： 提交前代码审查

---

### 📦 systematic-debugging

| 字段 | 值 |
|------|----|
| **Slug** | `systematic-debugging` |
| **显示名** | systematic-debugging |
| **版本** | 1.1.0 |
| **一级分类** | `software-development` |
| **安装日期** | 2026-07-09 16:06:49 |
| **本地路径** | `/home/ubuntu/.hermes/skills/software-development/systematic-debugging` |
| **文件数** | 1 |
| **大小** | 14,065 字节 (13.7 KB) |
| **来源** | bundled |

**简介**：4-phase root cause debugging: understand bugs before fixing.

**🎯 安装原因**： 系统化调试（4 阶段）

---

### 📦 spike

| 字段 | 值 |
|------|----|
| **Slug** | `spike` |
| **显示名** | spike |
| **版本** | 1.0.0 |
| **一级分类** | `software-development` |
| **安装日期** | 2026-07-09 16:06:49 |
| **本地路径** | `/home/ubuntu/.hermes/skills/software-development/spike` |
| **文件数** | 1 |
| **大小** | 8,730 字节 (8.5 KB) |
| **来源** | bundled |

**简介**：Throwaway experiments to validate an idea before build.

**🎯 安装原因**： 动手前先做 spike 验证想法

---

### 📦 node-inspect-debugger

| 字段 | 值 |
|------|----|
| **Slug** | `node-inspect-debugger` |
| **显示名** | node-inspect-debugger |
| **版本** | 1.0.0 |
| **一级分类** | `software-development` |
| **安装日期** | 2026-07-08 11:11:08 |
| **本地路径** | `/home/ubuntu/.hermes/skills/software-development/node-inspect-debugger` |
| **文件数** | 1 |
| **大小** | 10,929 字节 (10.7 KB) |
| **来源** | bundled |

**简介**：Debug Node.js via --inspect + Chrome DevTools Protocol CLI.

**🎯 安装原因**： Python / Node.js 代码调试

---

### 📦 codebase-inspection

| 字段 | 值 |
|------|----|
| **Slug** | `codebase-inspection` |
| **显示名** | codebase-inspection |
| **版本** | 1.0.0 |
| **一级分类** | `github` |
| **安装日期** | 2026-07-08 11:11:08 |
| **本地路径** | `/home/ubuntu/.hermes/skills/github/codebase-inspection` |
| **文件数** | 1 |
| **大小** | 3,628 字节 (3.5 KB) |
| **来源** | bundled |

**简介**：Inspect codebases w/ pygount: LOC, languages, ratios.

**🎯 安装原因**： 代码库规模 / 语言分布扫描

---

## 🗄️ 备份

- `weread-skills-official.bak.v1.0.3` — 2026-07-14 08:24:00（如需回滚可直接拷贝回原路径）

## 🌐 个人网站（计划）

打算用这份 Markdown 渲染成轻量级个人博客风格的网站：
- **静态站**：VitePress / Hugo / Hexo 任选
- **统计**：Utterances（评论区）+ busuanzi（阅读量）+ 自建 KV（下载量）
- **部署**：GitHub Pages / Vercel / Cloudflare Pages（免费）

**（先不急做站，先把清单维护好，网站只是渲染）**

## 🔄 增量更新

以后每装一个新 skill，重新跑：

```bash
python3 ~/.hermes/longxia/skills-registry/generate.py
```

脚本会自动：
- 扫描 `~/.hermes/skills/` 和 `~/.agents/skills/`
- 跳过已存在的 skill（按 slug 去重）
- 只追加新增的条目到 README.md 末尾
- 保留你已手动填写的「安装原因」

---

📅 本次生成：2026-07-31 17:40:08 · 数据源：`~/.hermes/skills/` + `~/.agents/skills/`
