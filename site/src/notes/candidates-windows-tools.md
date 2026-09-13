# Windows 双机调试候选清单

> **用途**：把小龙评估过的 Windows 工具记录在这里，等需要时再装
> **重要**：**这不是 Skill**——是**本地工具**——**不在 SkillHub**

---

## 🛠 候选工具

### ✅ 2026-07-29 加入：VirtualKD-Redux

- **GitHub**：https://github.com/4d61726b/VirtualKD-Redux
- **作用**：**Windows 驱动双机调试工具**——用 WinDbg 调试 VMware/VirtualBox 虚拟机里的 Windows 内核驱动
- **替代**：原版 VirtualKD（已停维护）
- **⭐ Stars**：977 · **🍴 Forks**：148
- **License**：LGPL v2.1
- **最后 push**：2024-06-23（2 年没更新但仍可用）
- **最新 release**：2024.3

**为什么登记**：
- 你做 EDR / Windows 驱动开发
- 调试 minifilter / ob callback 需要看内核
- 不用双机物理设备——一台电脑搞定

**不立刻装的理由**：
1. Linux 服务器装不了——这是 Windows-only 工具
2. 你现在功能开发密集期
3. 等有具体调试需求时再装

**装法（未来用）**：
- 在 Windows 工作机：装 WDK 7.1.0 + VS 2022
- 下 release：https://github.com/4d61726b/VirtualKD-Redux/releases
- 配 VMware / VirtualBox + WinDbg

---

## 📋 何时启动

**触发条件**：
- 你接到驱动调试任务
- 你想逆向分析 Windows 驱动
- 你想学习内核调试

**触发后**：
1. 你说"调试驱动"或"装 VirtualKD"
2. 我帮你走完整搭建流程
3. 整理一份"小龙的内核调试 SOP"

---

## ❌ 2026-07-29 删：微信抓取 skill（评估失败）

小龙问"是否有抓公众号链接的 skill"——**我系统搜了**——**5+ 个候选**——**全部失败**：
- 按公众号名批量抓 ≠ 小龙要的单 URL 单篇
- 多数要付费 AppID（aibana.art 平台）
- **腾讯反爬虫** = 服务器端无解（CDP 也被滑块验证拦）

**结论**：抓公众号文章 = **你手动复制粘贴 30 秒**（任何 skill 都不如这个简单）

**已删除**：
- ❌ wxpublic-fetch skill
- ❌ wechat_article_fetcher.py 脚本
- ❌ Chromium headless（不再需要）
- ❌ 失败记录文档

**保留教训**：**腾讯反爬虫是行业级难题**——**不浪费时间在这上面**

---

## 📌 当前候选（按需使用）

| 工具 | 类型 | 何时用 |
|------|------|--------|
| **VirtualKD-Redux** | Windows 工具 | 调试 Windows 内核驱动 |

---

## 🔧 当前状态

| 类型 | 已就绪 | 候选 |
|------|--------|------|
| Skill | 34 个（含 humanizer-zh / web-access-plus / AnySearch 等） | （暂无） |
| Windows 工具 | （暂无） | **VirtualKD-Redux**（调试用） |
| 开发环境 | （在你 Windows 工作机） | WDK 7.1.0 + VS 2022 |

---

**记录人**：Hermes Agent
**最后更新**：2026-07-29（清理版）
**关联**：小龙的安全开发工作