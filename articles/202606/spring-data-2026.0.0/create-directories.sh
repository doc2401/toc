#!/usr/bin/env bash

set -euo pipefail

pom_file="${1:-spring-data-bom-2026.0.0.pom}"
output_dir="${2:-.}"

if [[ ! -f "$pom_file" ]]; then
  echo "错误：POM 文件不存在：$pom_file" >&2
  exit 1
fi

if ! command -v xmllint >/dev/null 2>&1; then
  echo "错误：未找到 xmllint，请先安装 libxml2 工具。" >&2
  exit 1
fi

mkdir -p "$output_dir"

xmllint --xpath \
  '//*[local-name()="dependencyManagement"]/*[local-name()="dependencies"]/*[local-name()="dependency"]/*[local-name()="artifactId"]/text()' \
  "$pom_file" |
  tr ' ' '\n' |
  while IFS= read -r artifact_id; do
    [[ -z "$artifact_id" ]] && continue
    mkdir -p "$output_dir/$artifact_id"
    printf '已创建：%s\n' "$output_dir/$artifact_id"
  done
