#!/usr/bin/env bash
# 主管指标看板 · 一键发布到 GitHub Pages（永久静态托管）
#
# 用法（由小迪执行，需用户提供 GitHub Personal Access Token）:
#   bash deploy_github.sh <GITHUB_PAT> [REPO_NAME]
#
# 前置: 本目录已是 git 仓库且已 commit（数据已最新）。
# 脚本会: 1) 用令牌取用户名 2) 建公开仓库 3) 推送 4) 开启 GitHub Pages。
set -e

TOKEN="${1:?请提供 GitHub Personal Access Token (ghp_...): bash deploy_github.sh <PAT>}"
REPO="${2:-zhuguan-dashboard}"

echo "== 1. 获取 GitHub 用户名 =="
OWNER=$(curl -s -H "Authorization: Bearer $TOKEN" -H "Accept: application/vnd.github+json" \
        "https://api.github.com/user" | grep -o '"login"[ ]*:[ ]*"[^"]*"' | head -1 | sed 's/.*:[ ]*"//;s/"//')
[ -z "$OWNER" ] && { echo "获取用户名失败，请检查 PAT 是否有效（需 repo 权限）"; exit 1; }
echo "   用户名: $OWNER"

echo "== 2. 创建公开仓库（若已存在则忽略）=="
curl -s -X POST -H "Authorization: Bearer $TOKEN" -H "Accept: application/vnd.github+json" \
  -d "{\"name\":\"$REPO\",\"description\":\"主管指标看板(永久静态托管)\",\"private\":false,\"auto_init\":false}" \
  "https://api.github.com/user/repos" >/dev/null || true

echo "== 3. 配置远程并推送 =="
git remote remove origin 2>/dev/null || true
git remote add origin "https://$TOKEN@github.com/$OWNER/$REPO.git"
BRANCH=$(git rev-parse --abbrev-ref HEAD)
git push -u origin "$BRANCH"

echo "== 4. 开启 GitHub Pages =="
curl -s -X POST -H "Authorization: Bearer $TOKEN" -H "Accept: application/vnd.github+json" \
  -d "{\"source\":{\"branch\":\"$BRANCH\",\"path\":\"/\"}}" \
  "https://api.github.com/repos/$OWNER/$REPO/pages" >/dev/null || true

echo ""
echo "=============================================="
echo " 仓库地址 : https://github.com/$OWNER/$REPO"
echo " 永久链接 : https://$OWNER.github.io/$REPO/"
echo " 若 Pages 未自动开启：进仓库 → Settings → Pages"
echo "   → Source 选分支 [$BRANCH]、目录 /(root) → Save。"
echo "   首次构建约 1 分钟，之后链接永久不变。"
echo "=============================================="
