#!/bin/bash

# 1. 打包 Vue 项目
echo "🔨 正在打包 Vue 项目..."
npm run build || {
  echo "❌ 打包失败，请检查构建命令！"
  exit 1
}

# 2. 获取当前源码分支名
SOURCE_BRANCH=$(git branch --show-current)
TARGET_BRANCH="gh-pages"  # 假设目标分支是 gh-pages
TARGET_DIR="$SOURCE_BRANCH"  # 目标目录名 = 源码分支名

# 3. 检查目标分支是否存在，不存在则报错退出
if ! git show-ref --quiet "refs/heads/$TARGET_BRANCH"; then
  echo "❌ 错误：目标分支 '$TARGET_BRANCH' 不存在！"
  echo "💡 请先手动创建分支：git checkout -b $TARGET_BRANCH"
  exit 1
fi

# 4. 切换到目标分支
echo "🔄 切换到目标分支 $TARGET_BRANCH..."
git checkout "$TARGET_BRANCH" || {
  echo "❌ 切换分支失败！"
  exit 1
}

# 5. 创建目标目录（如果不存在）
mkdir -p "$TARGET_DIR"

# 6. 复制 dist/ 内容到目标目录（强制覆盖）
echo "📂 复制构建文件到 $TARGET_DIR/..."
cp -rf dist/* "$TARGET_DIR/"

# 7. 提交更改
echo "💾 提交更改..."
git add "$TARGET_DIR"
current_time=$(date "+%Y-%m-%d %H:%M:%S")
git commit -m "deploy $SOURCE_BRANCH build to $TARGET_DIR at $current_time" || {
  echo "⚠️ 无新更改可提交！"
}

# 8. 推送到远程
echo "🚀 推送到远程分支..."
git push origin "$TARGET_BRANCH" --force-with-lease || {
  echo "❌ 推送失败！请检查网络或权限。"
  exit 1
}

# 9. 切换回源码分支
git checkout "$SOURCE_BRANCH"