#!/usr/bin/env bash
# 主管指标看板 · 一键发布到 Gitee Pages（永久静态托管）
#
# 用法（由小迪执行，需用户提供 Gitee 私人令牌）:
#   bash deploy.sh <GITEE_TOKEN> [REPO_NAME]
#
# 前置: 本目录已是 git 仓库且已 commit（数据已最新）。
# 脚本会: 1) 用令牌取用户名 2) 建公开仓库 3) 推送到 Gitee 4) 尝试开启 Pages。
set -e

TOKEN="${1:?请提供 Gitee 私人令牌: bash deploy.sh <TOKEN>}"
REPO="${2:-zhuguan-dashboard}"

echo "== 1. 获取 Gitee 用户名 =="
OWNER=$(curl -s "https://gitee.com/api/v5/user?access_token=$TOKEN" \
        | grep -o '"login"[ ]*:[ ]*"[^"]*"' | head -1 | sed 's/.*:[ ]*"//;s/"//')
[ -z "$OWNER" ] && { echo "获取用户名失败，请检查令牌是否有效"; exit 1; }
echo "   用户名: $OWNER"

echo "== 2. 创建公开仓库（若已存在则忽略）=="
curl -s -X POST "https://gitee.com/api/v5/user/repos?access_token=$TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"$REPO\",\"description\":\"主管指标看板(永久静态托管)\",\"public\":true}" \
  >/dev/null || true

echo "== 3. 配置远程并推送 =="
git remote remove origin 2>/dev/null || true
git remote add origin "https://oauth2:$TOKEN@gitee.com/$OWNER/$REPO.git"
BRANCH=$(git rev-parse --abbrev-ref HEAD)
git push -u origin "$BRANCH"

echo "== 4. 尝试自动开启 Gitee Pages =="
curl -s -X POST "https://gitee.com/api/v5/repos/$OWNER/$REPO/pages?access_token=$TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"branch\":\"$BRANCH\",\"directory\":\"/\"}" >/dev/null || true

echo ""
echo "=============================================="
echo " 仓库地址 : https://gitee.com/$OWNER/$REPO"
echo " 永久链接 : https://$OWNER.gitee.io/$REPO/"
echo " 若 Pages 未自动启动：进 Gitee 仓库 → 服务 → Gitee Pages"
echo "   → 选分支 [$BRANCH]、目录 [/] → 点「启动」即可。"
echo "=============================================="
