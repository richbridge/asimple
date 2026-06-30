### 简介
本项目基于hugo进行构建，主题为`aiovt-simple`主题，主题的制作参考了开源项目[Shiro](https://github.com/Innei/Shiro),部分页面几乎一样，感谢大佬开源

原创部分为*行星环* 采用绝无仅有的方式展示你的文章，本项目更适合用作记录而非发布，下面是预览图片展示
![](https://r2tc.20030327.xyz/file/博客/文章/1782655349920_1782655066518.png)
![](https://r2tc.20030327.xyz/file/博客/文章/1782655904620_1782655875410.png)
![](https://r2tc.20030327.xyz/file/博客/文章/1782655349185_1782655081243.png)

下面是行星环深色模式动态演示

<a href="https://naixiai.cn/video/20260628-215843.Ldci1"><video src="https://img.naixiai.cn/2026/06/28/20260628_215843.mp4" controls poster="https://img.naixiai.cn/2026/06/28/20260628_215843.fr.jpeg"></video></a>

### 部署教程
#### 快速开始
本地开放，先克隆仓库，再运行预览
```bash
# 克隆仓库
git clone https://github.com/AIOVTUE/hugo-theme-asimple
cd hugo-theme-asimple

# 修改 hugo.toml 中的 baseURL、站点信息等

# 本地开发（含草稿，热更新）
hugo server -D
# 生产构建
hugo --minify --gc

```
构建输出在 `public/`
#### 项目结构

```
hugo-theme-asimple/
├── hugo.toml                 # 站点主配置（菜单、Hero、Twikoo、首页、搜索等）
├── data/
│   └── friends.yaml          # 友链分组与链接
├── content/                  # Markdown 内容
│   ├── posts/                # 文章
│   ├── thoughts/             # 动态
│   ├── about/                # 关于
│   ├── archives/             # 归档
│   ├── friends/              # 友链页
│   └── guestbook/            # 留言
├── static/                   # 原样复制到站点根（_headers、图片等）
├── archetypes/               # 新建内容模板
├── scripts/
│   └── build.sh              # CI 构建脚本（自动处理预览 URL）
├── themes/aiovt-simple/      # 主题
│   ├── assets/               # CSS / JS（Hugo Pipes 打包）
│   └── layouts/              # 模板与 partials
├── netlify.toml              # Netlify 部署
├── vercel.json               # Vercel 部署
├── wrangler.toml             # Cloudflare Pages 部署
└── package.json              # npm 构建脚本（供 CI 使用）
```

---

#### 主要配置

| 配置项 | 位置 | 说明 |
|--------|------|------|
| 站点信息 / 菜单 | `hugo.toml` → `[params]`、`[[menus.main]]` | 标题、头像、导航 |
| Twikoo 评论 | `[params.twikoo]` | `envId` 为评论服务地址，全站共用 |
| 友链列表 | `data/friends.yaml` | 分组与链接数据 |
| 首页视图 | `[params.home].desktop_posts_view` | `orbit` 或 `timeline` |
| 动态分页 | `[params.thoughts]` | `initial_count` / `load_batch` |
| 加载动画 | `[params.loader]` | `min_duration` / `max_duration` |
| 站内搜索 | `[params.search]` | 检索 `posts`、`thoughts` 等 section |
| 一言 | `[params.hitokoto]` | 可配置类型、刷新间隔 |
| 页脚 | `[params.footer]` | ICP、版权、生命计时 |

部署前请将 `hugo.toml` 顶部的 `baseURL` 改为你的正式域名。
#### 部署
仓库已包含 Netlify、Vercel、Cloudflare Pages 的配置文件。三平台通用参数如下：

| 项       | 值                                                                  |
| ------- | ------------------------------------------------------------------ |
| 构建命令    | `npm run build`（或直接 `hugo --minify --gc`）                          |
| 输出目录    | `public`                                                           |
| Hugo 版本 | `0.163.3`（最低 0.146.0 Extended）                                     |
| 环境变量    | `HUGO_VERSION`、`HUGO_ENV=production`（可选 `HUGO_ENABLEGITINFO=true`） |

##### Netlify
1. [Netlify](https://app.netlify.com/) → **Add new site** → **Import an existing project**
2. 连接 Git 仓库，Netlify 会自动读取 [`netlify.toml`](netlify.toml)
3. 确认构建命令 `npm run build`、发布目录 `public`
4. 绑定自定义域名后，将 `hugo.toml` 中 `baseURL` 改为该域名

##### Vercel
1. [Vercel](https://vercel.com/) → **Add New Project** → 导入 Git 仓库
2. Vercel 读取 [`vercel.json`](vercel.json)，Framework Preset 选 **Other**
3. 构建命令 `npm run build`，输出目录 `public`

##### Cloudflare Pages
1. [Cloudflare Dashboard](https://dash.cloudflare.com/) → **Workers & Pages** → **Create** → **Pages** → **Connect to Git**
2. 构建配置：
   | Build command | `npm run build` |
   | Build output directory | `public` |
   | Root directory | `/`（默认） |
