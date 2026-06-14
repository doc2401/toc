#!/usr/bin/env bash

set -euo pipefail

config_file="${1:-spring-cloud-projects.json}"
output_dir="${2:-.}"

if [[ ! -f "$config_file" ]]; then
  echo "错误：JSON 配置不存在：$config_file" >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "错误：未找到 jq。" >&2
  exit 1
fi

mkdir -p "$output_dir"

while IFS= read -r project_name; do
  mkdir -p "$output_dir/$project_name"
  echo "已创建：$output_dir/$project_name"
done < <(jq -er '.projects[].name' "$config_file")
