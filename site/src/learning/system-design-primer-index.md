---
title: System Design Primer 仓库归档
date: 2026-09-10
source: https://github.com/donnemartin/system-design-primer
---

# 📦 System Design Primer · 仓库归档

> **donnemartin/system-design-primer** · ⭐ 369K stars · 系统设计学习圣经
> 完整仓库已归档到本地：`~/.hermes/longxia/learning/system-design-primer/`（14MB，23 个 md + 8 套实战题解）

## 📖 在线读

- **[系统设计入门 · 中文全文](/learning/system-design-primer-full)** — README-zh-Hans 完整收录（含全部主题 + 8 道设计题目录）
- [英文原版（GitHub）](https://github.com/donnemartin/system-design-primer)

## 🗂 本地归档内容

```
system-design-primer/
├── README-zh-Hans.md        # 中文主文档（本站已收录）
├── README.md                # 英文主文档
├── solutions/system_design/ # 8 道实战设计题解
│   ├── pastebin/            # 设计 Pastebin / 短链服务
│   ├── twitter/             # 设计 Twitter 时间线和搜索
│   ├── web_crawler/         # 设计网页爬虫
│   ├── mint/                # 设计 Mint.com
│   ├── social_graph/        # 社交网络数据结构
│   ├── query_cache/         # 搜索引擎 KV 存储
│   ├── sales_rank/          # Amazon 销售排名
│   ├── scaling_aws/         # AWS 百万用户系统
│   └── template/            # 设计题解答模板
└── images/                  # 全部架构图
```

## 🎯 与 EDR 工作的关联点

| 章节 | 对应场景 |
|---|---|
| 背压（Back pressure） | 事件流检测架构：生产速度 > 消费速度时的限流策略 |
| 延迟数字表 | 滑动窗口检测放内存还是磁盘的决策依据 |
| 一致性哈希 | 多节点日志聚合的分片选型 |
| 消息队列/任务队列 | 检测任务的异步分发 |

## 📌 阅读建议

先读中文全文的「系统设计主题的索引」建立地图 → 按需深入 → 用 `solutions/template` 练 1 道设计题（推荐 pastebin，最经典）。
