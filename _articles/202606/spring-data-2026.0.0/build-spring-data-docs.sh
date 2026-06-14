#!/usr/bin/env bash

set -uo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
config_file="${1:-$script_dir/spring-data-projects.json}"
source_dir="${2:-./sources}"
log_dir="${3:-./build-logs}"
tool_dir="$script_dir/antora-tooling"

if [[ ! -f "$config_file" ]]; then
  echo "错误：JSON 配置不存在：$config_file" >&2
  exit 1
fi

config_file="$(cd "$(dirname "$config_file")" && pwd)/$(basename "$config_file")"

if ! command -v jq >/dev/null 2>&1; then
  echo "错误：未找到 jq。" >&2
  exit 1
fi

mapfile -t repositories < <(jq -er '.projects[].name' "$config_file")

if ! command -v npm >/dev/null 2>&1; then
  echo "错误：未找到 npm，无法安装 Antora 工具链。" >&2
  exit 1
fi

if [[ ! -f "$tool_dir/package.json" ]]; then
  echo "错误：Antora 工具链配置不存在：$tool_dir/package.json" >&2
  exit 1
fi

if [[ ! -x "$tool_dir/node_modules/.bin/antora" ]]; then
  echo "安装固定版本的 Antora 工具链"
  if [[ -f "$tool_dir/package-lock.json" ]]; then
    npm --prefix "$tool_dir" ci --no-audit --no-fund
  else
    npm --prefix "$tool_dir" install --no-audit --no-fund
  fi
fi

tool_dir="$(cd "$tool_dir" && pwd)"

if [[ ! -d "$source_dir" ]]; then
  echo "错误：源码目录不存在：$source_dir" >&2
  exit 1
fi

source_dir="$(cd "$source_dir" && pwd)"
mkdir -p "$log_dir"
log_dir="$(cd "$log_dir" && pwd)"

failed_projects=()

for project_name in "${repositories[@]}"; do
  project_dir="$source_dir/$project_name"
  log_file="$log_dir/$project_name.log"
  reference_source_rel="$(jq -er --arg name "$project_name" '.projects[] | select(.name == $name) | .documentation.reference.source' "$config_file")"
  api_source_rel="$(jq -er --arg name "$project_name" '.projects[] | select(.name == $name) | .documentation.api.source' "$config_file")"

  if [[ ! -d "$project_dir" ]]; then
    echo "跳过：项目目录不存在：$project_dir"
    continue
  fi

  if [[ -f "$project_dir/mvnw" ]]; then
    maven_command=("./mvnw")
  elif command -v mvn >/dev/null 2>&1; then
    maven_command=("mvn")
  else
    echo "失败：$project_name 未找到 Maven Wrapper，系统中也没有 mvn"
    failed_projects+=("$project_name")
    continue
  fi

  echo "开始构建：$project_name"
  echo "日志文件：$log_file"

  (
    set -e
    cd "$project_dir" || exit 1

    playbook="src/main/antora/antora-playbook.yml"

    if [[ ! -f "$playbook" ]]; then
      echo "错误：未找到 Antora playbook：$project_dir/$playbook" >&2
      exit 1
    fi

    echo "构建聚合 Javadoc：$project_name"
    "${maven_command[@]}" \
      --batch-mode \
      --no-transfer-progress \
      -DskipTests \
      -Dmaven.javadoc.failOnError=false \
      javadoc:aggregate

    echo "构建 reference 文档：$project_name"
    PATH="$tool_dir/node_modules/.bin:$PATH" \
      NODE_PATH="$tool_dir/node_modules" \
      antora \
      --to-dir "$reference_source_rel" \
      "$playbook"
  ) 2>&1 | tee "$log_file"

  build_status=${PIPESTATUS[0]}

  if [[ $build_status -eq 0 ]]; then
    echo "构建成功：$project_name"
    echo "Reference 构建产物：$project_dir/$reference_source_rel"
    echo "Javadoc 构建产物：$project_dir/$api_source_rel"
  else
    echo "构建失败：$project_name，详情见 $log_file"
    failed_projects+=("$project_name")
  fi
done

echo

if [[ ${#failed_projects[@]} -gt 0 ]]; then
  echo "以下项目构建失败："
  printf '  - %s\n' "${failed_projects[@]}"
  exit 1
fi

echo "所有已发现的项目均构建成功。"
