@echo off
REM 主管指标看板 · 数据刷新后一键同步到托管包
REM 用法: 先在本机跑 update_dashboard.py 把 Excel 注入源文件，再双击本脚本。
setlocal
set SRC=..
copy "%SRC%\deploy_dashboard\index.html" "index.html" /Y
copy "%SRC%\deploy_dashboard\chart.umd.min.js" "chart.umd.min.js" /Y
if not exist "mobile" mkdir mobile
copy "%SRC%\mobile_deploy\index.html" "mobile\index.html" /Y
copy "%SRC%\mobile_deploy\chart.umd.min.js" "mobile\chart.umd.min.js" /Y
echo [OK] 已把最新 PC/手机端看板同步进 static_bundle。接下来: git add . && git commit -m "数据更新" && git push
endlocal
