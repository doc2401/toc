#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
all_projects_config="$script_dir/spring-data-projects.json"
config_file="$all_projects_config"
source_dir="$script_dir/sources"
log_dir="$script_dir/build-logs"
tool_dir="$script_dir/antora-tooling"

if ! command -v jq >/dev/null 2>&1; then
  echo "错误：未找到 jq。" >&2
  exit 1
fi

selected_projects=("$@")
temporary_config=""

cleanup() {
  if [[ -n "$temporary_config" && -f "$temporary_config" ]]; then
    rm -f "$temporary_config"
  fi
}
trap cleanup EXIT

if [[ ${#selected_projects[@]} -gt 0 ]]; then
  for project_name in "${selected_projects[@]}"; do
    if ! jq -e --arg name "$project_name" '.projects[] | select(.name == $name)' "$all_projects_config" >/dev/null; then
      echo "错误：JSON 中不存在项目：$project_name" >&2
      exit 1
    fi
  done

  selected_projects_json="$(printf '%s\n' "${selected_projects[@]}" | jq -R . | jq -s .)"
  temporary_config="$(mktemp "${TMPDIR:-/tmp}/spring-data-projects.XXXXXX.json")"

  jq \
    --argjson selected "$selected_projects_json" \
    '.projects |= map(select(.name as $name | $selected | index($name)))' \
    "$all_projects_config" > "$temporary_config"

  config_file="$temporary_config"
  echo "仅构建项目：${selected_projects[*]}"
else
  echo "未指定项目，将构建全部项目。"
fi

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

# 3. 让各项目使用已经 checkout 到指定版本的本地 Spring Data Commons。
echo "3. 修复 Playbooks (使用本地 spring-data-commons HEAD)..."
node "$script_dir/patch-playbooks.js" "${selected_projects[@]}"

# 4. 更新仍由 playbook 引用的远程 Antora Git 缓存。
echo "4. 更新 Antora Git 缓存..."
cache_dir="${ANTORA_CACHE_DIR:-${XDG_CACHE_HOME:-$HOME/.cache}/antora/content}"
echo "  Antora 缓存目录: $cache_dir"
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
commons_mvnw="$source_dir/spring-data-commons/mvnw"
default_maven_workdir="$source_dir/spring-data-commons"

if [[ -x "$commons_mvnw" ]]; then
  maven_workdir="$default_maven_workdir"
  maven_cmd=("./mvnw")
else
  # 优先使用任意已检出子项目自带的 Maven Wrapper。
  mvnw_path="$(find "$source_dir" -mindepth 2 -maxdepth 2 -type f -name "mvnw" -perm -u+x -print -quit)"

  if [[ -n "$mvnw_path" ]]; then
    maven_workdir="$(dirname "$mvnw_path")"
    maven_cmd=("./mvnw")
  elif command -v mvn >/dev/null 2>&1; then
    if [[ ! -d "$default_maven_workdir" ]]; then
      echo "错误：Maven 工作目录不存在：$default_maven_workdir" >&2
      exit 1
    fi
    maven_workdir="$default_maven_workdir"
    maven_cmd=("mvn")
  else
    echo "错误：未在子项目或系统 PATH 中找到 Maven。" >&2
    exit 1
  fi
fi

echo "  Maven 工作目录: $maven_workdir"
echo "  使用 Maven 命令: ${maven_cmd[*]}"
(
  cd "$maven_workdir"
  "${maven_cmd[@]}" install:install-file \
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
# spring-data-projects.json 已按依赖顺序排列。
bash "$script_dir/build-spring-data-docs.sh" "$config_file" "$source_dir" "$log_dir"

echo "================================================================="
echo " 所有指定项目构建完成！"
echo " 如需收集文档，请单独运行："
echo " bash collect-spring-data-docs.sh"
echo "================================================================="
