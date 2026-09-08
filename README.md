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

## 发布方式（已默认 Gitee Pages，国内手机最快最稳）
**你只需做一件事**：去 Gitee 生成一个「私人令牌」发我，其余我全包。
1. 登录 gitee.com → 右上角头像 → 设置 → 左侧「私人令牌」→ 生成新令牌；
2. 权限勾选 `projects`（或全选只读也可）→ 复制令牌（只显示一次）；
3. 把令牌发我。我会：建公开仓库 → 推送本文件夹 → 开启 Pages → 把**永久链接**给你。
- 若想自己推：仓库建好后，`bash deploy.sh <你的令牌>` 即可一键上线（脚本在根目录）。
- Pages 未自动启动的话，进仓库 → 服务 → Gitee Pages → 选分支、目录 `/` → 点「启动」。

## 其他平台（如你指定）
- **GitHub Pages**：建仓库 → `bash deploy.sh <GitHub令牌> <repo>`（脚本已兼容）→ Settings → Pages 选分支根目录。
- **Netlify**：拖本文件夹到 app.netlify.com/drop，立即获得链接。

> 注：当前 WorkBuddy 沙箱链接（app.workbuddy.link / sandbox.cloudstudio.club）会空闲回收，不适合做永久链接；本包即用来替代它。
