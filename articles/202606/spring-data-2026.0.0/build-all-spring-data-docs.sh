#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
config_file="$script_dir/spring-data-projects-ordered.json"
source_dir="$script_dir/sources"
log_dir="$script_dir/build-logs"
tool_dir="$script_dir/antora-tooling"
output_dir="$script_dir/target/antora/site"

echo "================================================================="
echo " 开始编译所有 Spring Data 项目 (API Javadoc & Reference 运行方案) "
echo "================================================================="

# 1. 确保安装了 Antora 工具链依赖
echo "1. 检查并安装 Antora 工具链依赖..."
if [[ -f "$tool_dir/package-lock.json" ]]; then
  npm --prefix "$tool_dir" ci --no-audit --no-fund
else
  npm --prefix "$tool_dir" install --no-audit --no-fund
fi

# 2. 运行 patch-toolchain.js 修复 Node.js v24 的 Zip 死锁挂起问题与扩展插件 Array 兼容性问题
echo "2. 修复工具链 (Node.js 24 ZIP Stream / Ext Array Compatibility)..."
node "$script_dir/patch-toolchain.js"

# 3. 运行 patch-playbooks.js 给各个项目的 antora-playbook 加上 tags: [ 4.1.0 ]
echo "3. 修复 Playbooks (添加 spring-data-commons 4.1.0 标签依赖)..."
node "$script_dir/patch-playbooks.js"

# 4. 在本地的 Antora git 缓存目录中拉取 tags
echo "4. 拉取缓存 Git 仓库中的 Tags..."
cache_dir="/mnt/data/fedora/.cache/antora/content"
if [[ -d "$cache_dir" ]]; then
  for git_repo in "$cache_dir"/*.git; do
    if [[ -d "$git_repo" ]]; then
      echo "  正在拉取标签: $(basename "$git_repo")"
      git -C "$git_repo" fetch --tags || echo "  [警告] 无法在 $git_repo 拉取 tags，跳过"
    fi
  done
else
  echo "  [提示] 缓存目录 $cache_dir 不存在，将在 Antora 构建时自动创建"
fi

# 5. 安装本地 BOM (spring-data-bom-2026.0.0.pom) 以确保 Maven 编译的版本依赖解析正常
echo "5. 安装本地 BOM pom 文件..."
if command -v mvn >/dev/null 2>&1; then
  maven_cmd="mvn"
else
  # 寻找源码目录中的 mvnw
  mvnw_path=$(find "$source_dir" -maxdepth 2 -name "mvnw" | head -n 1)
  if [[ -n "$mvnw_path" ]]; then
    maven_cmd="$mvnw_path"
  else
    echo "错误：未在系统路径或项目中找到 maven 或 mvnw 包装器。" >&2
    exit 1
  fi
fi

echo "  使用 Maven 命令: $maven_cmd"
(
  cd "$(dirname "$maven_cmd")"
  "./$(basename "$maven_cmd")" install:install-file \
    -Dfile="$script_dir/spring-data-bom-2026.0.0.pom" \
    -DgroupId="org.springframework.data" \
    -DartifactId="spring-data-bom" \
    -Dversion="2026.0.0" \
    -Dpackaging="pom" \
    --batch-mode \
    --no-transfer-progress
)

# 6. 运行 build-spring-data-docs.sh 构建各个项目的 Javadoc 和 Antora 文档
echo "6. 开始编译各个项目文档..."
# 我们使用有序的 spring-data-projects-ordered.json
# 来保证 commons 和 keyvalue / relational 优先构建
"$script_dir/build-spring-data-docs.sh" "$config_file" "$source_dir" "$log_dir"

# 7. 收集构建好的文档产物
echo "7. 收集并整理编译好的 API Javadoc 与 Reference 网页到 target/antora/site ..."
"$script_dir/collect-spring-data-docs.sh" "$config_file" "$source_dir" "$output_dir"

echo "================================================================="
echo " 构建和收集全部成功！"
echo " 访问生成的文档站点入口："
echo " file://$output_dir/index.html"
echo "================================================================="
