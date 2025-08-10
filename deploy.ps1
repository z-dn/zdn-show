# PowerShell 脚本：将 Vue 项目打包并部署到指定分支的目录
# 如果目标分支不存在，则终止操作

# 1. 打包 Vue 项目
Write-Host "🔨 正在打包 Vue 项目..." -ForegroundColor Cyan
npm run build
if (-not $?) {
    Write-Host "❌ 打包失败，请检查构建命令！" -ForegroundColor Red
    exit 1
}

# 2. 获取当前源码分支名
$SOURCE_BRANCH = git branch --show-current
$TARGET_BRANCH = "gh-pages"  # 目标分支名（可修改）
$TARGET_DIR = $SOURCE_BRANCH  # 目标目录名 = 源码分支名

# 3. 检查目标分支是否存在，不存在则报错退出
$branchExists = git show-ref --quiet "refs/heads/$TARGET_BRANCH"
if (-not $branchExists) {
    Write-Host "❌ 错误：目标分支 '$TARGET_BRANCH' 不存在！" -ForegroundColor Red
    Write-Host "💡 请先手动创建分支：git checkout -b $TARGET_BRANCH" -ForegroundColor Yellow
    exit 1
}

# 4. 切换到目标分支
Write-Host "🔄 切换到目标分支 $TARGET_BRANCH..." -ForegroundColor Cyan
git checkout $TARGET_BRANCH
if (-not $?) {
    Write-Host "❌ 切换分支失败！" -ForegroundColor Red
    exit 1
}

# 5. 创建目标目录（如果不存在）
if (-not (Test-Path $TARGET_DIR)) {
    New-Item -ItemType Directory -Path $TARGET_DIR | Out-Null
    Write-Host "📂 创建目录：$TARGET_DIR" -ForegroundColor Green
}

# 6. 复制 dist/ 内容到目标目录（强制覆盖）
Write-Host "📂 复制构建文件到 $TARGET_DIR/..." -ForegroundColor Cyan
Copy-Item -Path ".\dist\*" -Destination "$TARGET_DIR\" -Recurse -Force

# 7. 提交更改
Write-Host "💾 提交更改..." -ForegroundColor Cyan
git add "$TARGET_DIR"
git commit -m "Deploy $SOURCE_BRANCH build to $TARGET_DIR"
if (-not $?) {
    Write-Host "⚠️ 无新更改可提交！" -ForegroundColor Yellow
}

# 8. 推送到远程
Write-Host "🚀 推送到远程分支..." -ForegroundColor Cyan
git push origin $TARGET_BRANCH --force-with-lease
if (-not $?) {
    Write-Host "❌ 推送失败！请检查网络或权限。" -ForegroundColor Red
    exit 1
}

# 9. 切换回源码分支
git checkout $SOURCE_BRANCH

Write-Host "✅ 成功将 $SOURCE_BRANCH 的构建文件部署到 $TARGET_BRANCH/$TARGET_DIR" -ForegroundColor Green