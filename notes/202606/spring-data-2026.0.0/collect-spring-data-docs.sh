#!/usr/bin/env bash

set -euo pipefail

config_file="${1:-spring-data-projects.json}"
source_dir="${2:-./sources}"
output_dir="${3:-./site}"

if [[ ! -f "$config_file" ]]; then
  echo "错误：JSON 配置不存在：$config_file" >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "错误：未找到 jq。" >&2
  exit 1
fi

mkdir -p "$output_dir"

missing_artifacts=()

while IFS=$'\t' read -r project_name reference_source reference_destination api_source api_destination; do
  project_source_dir="$source_dir/$project_name"
  project_output_dir="$output_dir/$project_name"
  reference_source_dir="$project_source_dir/$reference_source"
  reference_output_dir="$project_output_dir/$reference_destination"
  api_source_dir="$project_source_dir/$api_source"
  api_output_dir="$project_output_dir/$api_destination"

  mkdir -p "$reference_output_dir" "$api_output_dir"

  if [[ -f "$reference_source_dir/index.html" ]]; then
    cp -R "$reference_source_dir/." "$reference_output_dir/"
    echo "已复制 Reference：$reference_output_dir/index.html"
  else
    echo "缺少 Reference：$reference_source_dir/index.html" >&2
    missing_artifacts+=("$project_name:reference")
  fi

  if [[ -f "$api_source_dir/index.html" ]]; then
    cp -R "$api_source_dir/." "$api_output_dir/"
    echo "已复制 API：$api_output_dir/index.html"
  else
    echo "缺少 API：$api_source_dir/index.html" >&2
    missing_artifacts+=("$project_name:api")
  fi
done < <(
  jq -er '
    .projects[] |
    [
      .name,
      .documentation.reference.source,
      .documentation.reference.destination,
      .documentation.api.source,
      .documentation.api.destination
    ] |
    @tsv
  ' "$config_file"
)

if [[ ${#missing_artifacts[@]} -gt 0 ]]; then
  echo "以下构建产物尚未生成：" >&2
  printf '  - %s\n' "${missing_artifacts[@]}" >&2
  exit 1
fi

echo "所有文档产物均已复制完成。"
