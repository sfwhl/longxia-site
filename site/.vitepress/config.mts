import { defineConfig } from 'vitepress'

export default defineConfig({
  title: "小龙的小站",
  description: "个人知识库 + Skill 技能库 + 读书笔记",
  base: "/",

  // 内容源在 src/ 下（避免 symlink 解析问题）
  srcDir: "src",

  themeConfig: {
    siteTitle: "小龙的小站",

    nav: [
      { text: "🏠 首页", link: "/" },
      { text: "💡 感悟", link: "/thoughts/" },
      { text: "📚 今日笔记", link: "/journal/2026-07-14/" },
      { text: "🛠️ Skills", link: "/skills-registry/" },
    ],

    sidebar: {
      "/thoughts/": [
        {
          text: "💡 每日感悟",
          items: [
            { text: "全部感悟", link: "/thoughts/" },
            { text: "—— 2026-07-15 周三", collapsed: false,
              items: [
                { text: "中 · 上班=训练，用 AI 做杠杆", link: "/thoughts/2026-07-15/afternoon/" },
                { text: "早 · 人和 AI 一样，是个可训练的系统", link: "/thoughts/2026-07-15/morning/" },
              ]
            },
            { text: "—— 2026-07-14 周二", collapsed: true,
              items: [
                { text: "中 · 费曼 + 自我对话 + 思维导图", link: "/thoughts/2026-07-14/midday/" },
                { text: "早 · 早点起床，做真正的自己", link: "/thoughts/2026-07-14/early/" },
              ]
            },
            { text: "—— 2026-07-13 周一",
              items: [
                { text: "早起，才能做自己", link: "/thoughts/2026-07-13/" },
              ]
            },
          ],
        },
      ],
      "/journal/": [
        {
          text: "📅 2026-07-14 周二",
          items: [
            { text: "今日索引", link: "/journal/2026-07-14/" },
            { text: "完整划线 - 离开公司", link: "/journal/2026-07-14/weread-离开公司-你的能力还值钱吗" },
            { text: "笔记总结 - 离开公司", link: "/journal/2026-07-14/weread-summary-离开公司" },
          ],
        },
      ],
      "/skills-registry/": [
        {
          text: "🛠️ Skills 技能库",
          items: [
            { text: "Skill 清单", link: "/skills-registry/README" },
          ],
        },
      ],
    },

    // 搜索（VitePress 内置本地搜索）
    search: {
      provider: "local",
    },

    footer: {
      message: "由 Hermes Agent 协助搭建 · 持续更新中",
      copyright: "© 2026 小龙",
    },

    // 阅读量统计：在每页底部显示 PV/UV
    // 数据来源：busuanzi 不蒜子（轻量、零配置）
    docFooter: {
      prev: "上一篇",
      next: "下一篇",
    },

    // 在每个页脚加上自定义 HTML（PV/UV 统计）
    // 用 VitePress 的 slot 机制，在 layout 里再加
  },

  // 指定自定义 theme 入口（用于加载 PageStats 组件）
  // VitePress 默认会自动查找 .vitepress/theme/index.{js,ts}
  // 这里显式声明一下更清晰
  // 注意：使用自定义 theme 时，需要从 DefaultTheme 继承（已在 theme/index.js 中完成）

  // 全局 head 注入：busuanzi 统计脚本
  head: [
    ['script', { async: '', src: '//busuanzi.ibruce.info/busuanzi/2.3/busuanzi.pure.mini.js' }],
    ['meta', { name: 'referrer', content: 'no-referrer-when-downgrade' }],
  ],

  markdown: {
    theme: {
      light: 'github-light',
      dark: 'github-dark',
    },
    lineNumbers: true,
  },
})