#!/usr/bin/env bash

set -uo pipefail

config_file="${1:-spring-cloud-projects.json}"
source_dir="${2:-./sources}"
log_dir="${3:-./build-logs}"

if [[ ! -f "$config_file" ]]; then
  echo "错误：JSON 配置不存在：$config_file" >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "错误：未找到 jq。" >&2
  exit 1
fi

mkdir -p "$log_dir"
failed_projects=()

while IFS= read -r project_name; do
  project_dir="$source_dir/$project_name"
  log_file="$log_dir/$project_name.log"

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

  (
    set -e
    cd "$project_dir"

    if [[ -f "docs/pom.xml" ]]; then
      echo "构建 reference 文档"
      "${maven_command[@]}" \
        --batch-mode \
        --no-transfer-progress \
        -DskipTests \
        -pl docs \
        -Pdocs \
        antora:antora
    else
      echo "跳过 reference：没有 docs/pom.xml"
    fi

    echo "构建聚合 Javadoc"
    "${maven_command[@]}" \
      --batch-mode \
      --no-transfer-progress \
      -DskipTests \
      -Dmaven.javadoc.failOnError=false \
      javadoc:aggregate
  ) 2>&1 | tee "$log_file"

  build_status=${PIPESTATUS[0]}

  if [[ $build_status -ne 0 ]]; then
    echo "构建失败：$project_name，详情见 $log_file"
    failed_projects+=("$project_name")
    continue
  fi

  echo "构建成功：$project_name"

  while IFS= read -r index_file; do
    echo "Reference 文档入口：$index_file"
  done < <(
    find "$project_dir" \
      -type f \
      -path "*/target/antora/*" \
      -name "index.html" \
      -print
  )
done < <(jq -er '.projects[].name' "$config_file")

if [[ ${#failed_projects[@]} -gt 0 ]]; then
  echo "以下项目构建失败："
  printf '  - %s\n' "${failed_projects[@]}"
  exit 1
fi

echo "所有已发现的项目均构建成功。"
