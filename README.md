# 主管指标看板 · 永久静态托管包

本文件夹是「主管指标看板」的**直接可托管版本**，无需任何服务器，丢到任意静态托管平台（GitHub Pages / Gitee Pages / Netlify / 腾讯云COS）即可获得**永不变更的链接**。

## 目录结构
```
static_bundle/
├── index.html            # 电脑端看板（根路径，即主页）
├── chart.umd.min.js      # 图表库（与 index.html 同目录）
└── mobile/
    ├── index.html        # 手机端看板（访问 /mobile/）
    └── chart.umd.min.js
```

## 特性
- 数据已内联进 HTML（`const DATA`），不依赖外部接口。
- 图表库 `chart.umd.min.js` 本地打包，离线可用。
- 默认落地主题：暗夜黑；暗金版 / 科技蓝 / 商务红金 / 清新绿 / 简约灰 可一键切换。

## 数据刷新流程（日常）
1. 在本机用 `update_dashboard.py` 把桌面 `主管指标_已填充.xlsx` 注入 PC/手机端源文件。
2. 运行 `refresh.bat`（Windows）把最新源文件同步进本文件夹。
3. `git add . && git commit -m "数据更新" && git push`。
4. 托管平台自动重新发布，链接不变、刷新即时生效（PC 与手机端两个链接一起更新，始终一致）。

## 发布方式（已选定 GitHub Pages）
> 安全须知：GitHub **不支持用账号密码**做 git 推送/API，必须用 **Personal Access Token（PAT）**。请勿在聊天里发密码；请改用下面方式生成可吊销的 PAT。账号密码若已在聊天中出现，请立即去 GitHub 改密码。

**你只需做一件事**：生成一个 GitHub PAT 发我，其余我全包。
1. 登录 github.com → 右上角头像 → **Settings** → 左侧最下 **Developer settings** → **Personal access tokens** → **Tokens (classic)** → **Generate new token (classic)**；
2. Note 随便写（如 dashboard），Expiration 选 90 天或 No expiration；**勾选 `repo`（全选 repo 权限）** → Generate；
3. 复制令牌（以 `ghp_` 开头，只显示一次）发我。我会：`bash deploy_github.sh <PAT>` 一键完成 建公开仓库 → 推送 → 开 Pages → 把**永久链接** `https://<你名>.github.io/zhuguan-dashboard/` 给你。

- 若想自己推：仓库建好后，`bash deploy_github.sh <PAT>` 即可（脚本在根目录）。
- Pages 未自动开启：进仓库 → Settings → Pages → Source 选分支、目录 /(root) → Save（首次约 1 分钟生效）。

## 其他平台（备选）
- **Gitee Pages**（国内手机更快）：`bash deploy.sh <Gitee令牌>`，步骤见脚本注释。
- **Netlify**：拖本文件夹到 app.netlify.com/drop，立即获得链接。

> 注：当前 WorkBuddy 沙箱链接（app.workbuddy.link / sandbox.cloudstudio.club）会空闲回收，不适合做永久链接；本包即用来替代它。
