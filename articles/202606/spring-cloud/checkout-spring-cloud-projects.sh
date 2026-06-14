#!/usr/bin/env bash

set -euo pipefail

config_file="${1:-spring-cloud-projects.json}"
output_dir="${2:-./sources}"

if [[ ! -f "$config_file" ]]; then
  echo "错误：JSON 配置不存在：$config_file" >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "错误：未找到 jq。" >&2
  exit 1
fi

mkdir -p "$output_dir"

while IFS=$'\t' read -r project_name repository_url tag; do
  project_dir="$output_dir/$project_name"

  echo "处理：$project_name -> $tag"

  if [[ -d "$project_dir/.git" ]]; then
    git -C "$project_dir" fetch origin --tags
  elif [[ -e "$project_dir" ]]; then
    echo "错误：目录已存在但不是 Git 仓库：$project_dir" >&2
    exit 1
  else
    git clone "$repository_url" "$project_dir"
  fi

  if ! git -C "$project_dir" rev-parse --verify --quiet "refs/tags/$tag" >/dev/null; then
    echo "错误：$project_name 中不存在 tag：$tag" >&2
    exit 1
  fi

  git -C "$project_dir" switch --detach "$tag"
done < <(jq -er '.projects[] | [.name, .repository, .tag] | @tsv' "$config_file")

echo "所有仓库均已切换到 JSON 指定的版本。"
