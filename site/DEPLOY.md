# 🚀 小龙的小站 - 部署到 Vercel 指南

> 从 0 到上线，预计 3-5 分钟。

## 📋 前置条件（你需要的）

- ✅ GitHub 账号（https://github.com）
- ✅ Vercel 账号（https://vercel.com，可以用 GitHub 一键登录）

## 🔧 第 1 步：初始化 Git 仓库

在 `~/.hermes/longxia/` 目录执行：

```bash
cd ~/.hermes/longxia

# 1. 初始化 git（如果还没初始化）
git init
git config user.name "小龙"
git config user.email "你的邮箱@example.com"

# 2. 创建 .gitignore（排除掉不需要上传的东西）
cat > .gitignore << 'EOF'
node_modules/
.vitepress/cache/
.vitepress/dist/
.DS_Store
*.log
__pycache__/
*.pyc
.venv/
.env
.env.local
EOF

# 3. 添加 Vercel 部署只需要的文件
#    （不包含 journal/ 里的私人日记，只包含构建产物和配置）
git add vercel.json site/package.json site/package-lock.json site/.vitepress/

# 4. 注意：site/src/ 是构建时的输入，但 Vercel 上也要有，否则 build 找不到 .md 文件
git add site/src/

# 5. 提交
git commit -m "init: 小龙的小站 - VitePress"
```

## 🔗 第 2 步：在 GitHub 创建仓库并推送

### 选项 A：用 GitHub 网页（推荐新手）

1. 打开 https://github.com/new
2. Repository name: `longxia-site`（或你想要的名字）
3. 选 **Private**（你的个人站，建议私有仓库）
4. **不要**勾选 "Add a README"
5. 点击 "Create repository"

然后回到终端：

```bash
cd ~/.hermes/longxia
git remote add origin https://github.com/你的用户名/longxia-site.git
git branch -M main
git push -u origin main
```

### 选项 B：如果你已经有 GitHub CLI（`gh`）

```bash
cd ~/.hermes/longxia
gh repo create longxia-site --private --source=. --remote=origin
git push -u origin main
```

## 🌐 第 3 步：在 Vercel 一键部署

1. 打开 https://vercel.com/new
2. 用 GitHub 账号登录（第一次会要求授权）
3. 在 "Import Git Repository" 找到 `longxia-site` 仓库，点击 **Import**
4. 配置项目（**大部分已经自动填好了**）：
   - **Framework Preset**: VitePress（自动识别）
   - **Build Command**: `cd site && npm install && npm run docs:build`（已经写在 vercel.json 里）
   - **Output Directory**: `site/.vitepress/dist`（已经写在 vercel.json 里）
5. 点击 **Deploy**

等待 1-2 分钟，部署完成！Vercel 会给你一个域名，类似：

```
https://longxia-site-xxxx.vercel.app
```

## 🎉 第 4 步：访问你的网站

打开浏览器，输入上面的 URL，**你应该看到**：
- 首页 Hero + 4 个 Features 卡片
- 顶部导航：首页 / 读书笔记 / Skills
- 底部：**阅读量 + 访客数**（busuanzi 在国内访问比较快，国际访问可能慢）
- 明暗主题切换按钮

## 🔄 以后怎么更新内容？

**每天早上跑一次** `daily.sh`：

```bash
~/.hermes/longxia/daily.sh --push
```

这会自动：
1. 拉今天的微信读书新增笔记
2. 同步到 site/src/
3. 重新 build
4. git push 到 GitHub
5. **Vercel 自动部署**（通常 30 秒内完成）

## 🛠️ 进阶：自定义域名

如果你有自己的域名（比如 longxia.dev）：

1. Vercel 项目 → Settings → Domains
2. 添加你的域名
3. 按提示在你的域名 DNS 里加一条 CNAME 记录
4. Vercel 自动签发 SSL 证书（免费）

## 🛡️ 关于隐私

我建议把 journal/ 目录**保持本地**，不要 push 到 GitHub：

- 在 `.gitignore` 里加 `journal/` 和 `skills-registry/`
- **只 push** 构建产物需要的文件（`site/src/`、`site/.vitepress/`、`site/package*.json`）
- 这样你的**私人笔记不会公开**

或者如果你想公开所有内容，那就全部 push。

---

## ❓ 常见问题

### Q: 部署后页面 404？
A: 检查 `vercel.json` 的 `outputDirectory` 是否是 `site/.vitepress/dist`，Vercel 项目设置里也要对应。

### Q: 阅读量显示 "--"？
A: busuanzi 在国内访问正常，国际网络可能慢。等几秒或者刷新页面。也可以换 Umami（自托管）。

### Q: 域名要钱吗？
A: Vercel 默认域名免费。自定义域名：域名本身年费（几十块），Vercel 不收费。

### Q: 部署后图片/样式丢了？
A: 大概率是 `base` 路径问题。如果你的仓库名不是用户名同名，要在 `config.mts` 里改 `base: "/longxia-site/"`。

---

**有任何问题随时问我** 🐉