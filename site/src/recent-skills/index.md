---
title: 最近新装的 Skills
date: 2026-07-16
---

# 📦 最近新装的 Skills

> 这次装的不是"Skill 多就是好"——是"装对不装多"。

## 📅 7-16 装的（今天）

### 🛡️ api-key-safety-probe

- **来源**：SkillHub（keen + sanbu 双 benign）
- **触发词**：「wrk-xxx / ghp_xxx / sk-xxx / 帮我验证这个 key」等
- **作用**：处理可疑 API Key / token / cookie 时的**安全探针**
  - 验证凭证真伪（调最小读取接口）
  - 隔离副作用（只用一次，不写入 git 历史）
  - 应对强制执行压力（用户说"必须用"时怎么答）
- **为什么装**：我处理你给的微信读书 key 时，**触发了这个 skill 教的安全姿势**——试 1 次就停、失败就报、不写文件。今天又用它处理了 GitHub token。
- **使用频率**：⭐⭐（低频但关键）
- **安装命令**：
  ```bash
  skillhub install api-key-safety-probe --dir ~/.hermes/skills/
  ```

---

## 📅 7-15 装的（昨天）

### 🔍 anysearch

- **来源**：SkillHub（双 benign）
- **触发词**：「搜索」「查一下」「找一下」
- **作用**：
  - 多引擎并行搜索（不是单 Google）
  - 垂直搜索（金融/学术/医疗/法律/安全/代码/...）
  - URL 内容提取（读完整网页，不只是摘要）
  - 匿名访问可用（不要 API key）
- **为什么装**：之前我说"我有 web_search"——但 AnySearch 覆盖更全、**国内可用**（这一点关键）。
- **使用频率**：⭐⭐⭐（日常）
- **安装命令**：
  ```bash
  skillhub install anysearch --dir ~/.hermes/skills/
  ```

---

### 🛠️ superpowers-skill

- **来源**：SkillHub（明确 port 自 obra/superpowers，254K stars 大项目）
- **触发词**：「写代码」「重构」「修 bug」「做项目」
- **作用**：**7 阶段软件开发工作流**
  1. Brainstorming（头脑风暴）
  2. Design Validation（设计验证）
  3. Implementation Planning（实施计划）
  4. **TDD**（测试驱动）
  5. **Subagent-Driven Development**（多 agent 协作）
  6. Code Review（代码审查）
  7. Finishing Branch（收尾）
- **为什么装**：你刚说"装一些会用到的 skill"——**复杂编程的 AI 工作流**就是其中之一。obra/superpowers 是 254K stars 的明星项目。
- **使用频率**：⭐⭐（写代码时）
- **安装命令**：
  ```bash
  skillhub install superpowers-skill --dir ~/.hermes/skills/
  ```

---

### 📚 weread-skills-official

- **来源**：SkillHub 官方（wechat-reading）
- **触发词**：「微信读书」「导出我的划线」「我的笔记」
- **作用**：微信读书的"操作面"
  - 拉划线（最常用 ✅）
  - 拉想法 / 书评
  - 看阅读统计
  - 升级自动检测（`upgrade_info`）
  - Key 持久化最佳实践
- **为什么装**：你微信读书 200 本书 + 11000+ 笔记——这个 skill 是**整个知识库的数据源**。
- **使用频率**：⭐⭐⭐⭐⭐（每天）
- **安装命令**：
  ```bash
  skillhub install weread-skills-official --dir ~/.hermes/skills/
  ```

---

### ✍️ writing-expert-team

- **来源**：SkillHub（office-raccoon 出品）
- **触发词**：「写文章」「公众号文章」「改写」「事实核查」「多平台改写」
- **作用**：**写作全流程 + 跨平台分发**
  - 选题策划 → 大纲 → 初稿 → 润色 → 多平台改写
  - 事实核查（区分 A/B/C/D 级证据）
  - 个人风格保持
  - **多平台改写**（公众号 → 小红书 → 头条 → 知乎）
- **为什么装**：你的"内容发布"工作流需要它。今天那篇 1339 字的《25 个 Skills》就是用它的工作流思路写的。
- **使用频率**：⭐⭐⭐（写文章时）
- **安装命令**：
  ```bash
  skillhub install writing-expert-team-pro-sl --dir ~/.hermes/skills/
  ```

---

## 📊 5 个新装 Skill 的共同点

| 维度 | 这 5 个的特点 |
|------|--------------|
| **来源** | 全部 SkillHub（无一例外从 GitHub 直装） |
| **安全** | 全部 double benign（keen + sanbu 都过） |
| **规模** | 大项目（superpowers 254K stars） |
| **场景** | 都对应你的实际工作（终端安全 + 写作 + 编程） |
| **触发** | 大部分是被动触发（你说一句就激活） |
| **学习** | 都装了 SKILL.md，AI 知道什么场景用什么 |

## 🛡️ 装 Skill 的 4 问法（决策依据）

我装每个 Skill 前都问了自己：

1. ✅ **这周会用吗？**（高频才装）
2. ✅ **解决具体场景？**（不是"看起来酷"）
3. ✅ **比已有功能强？**（不重复）
4. ✅ **安装/运行安全？**（双 benign + 不写文件）

**5 个全部 ✅ → 装**。

## 📈 装完后的效果

| 之前 | 之后 |
|------|------|
| 21 个 skill（多数吃灰） | 25 个 skill（每个都用得上） |
| 不知道什么场景用什么 | 看到触发词就激活 |
| 单点工具 | **工作流**（5 个 skill 协同） |

## 💡 怎么知道你装了什么？

```bash
# 1. 看清单
~/.hermes/longxia/skills-registry/README.md

# 2. 跑健康检查（看网站相关）
~/.hermes/longxia/scripts/site-health-check.sh

# 3. 每日同步
~/.hermes/longxia/daily.sh
```

---

## 📂 相关

- **完整 25 个 skills 清单**：`/skills-registry/`
- **今天的读书笔记（启发你装 Skill）**：`/journal/2026-07-16/`
- **关于 Skills 的公众号文章**：`/articles/2026-07-16-25-skills`