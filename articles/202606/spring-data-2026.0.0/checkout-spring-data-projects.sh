#!/usr/bin/env bash

set -euo pipefail

pom_file="${1:-spring-data-bom-2026.0.0.pom}"
output_dir="${2:-./sources}"

if [[ ! -f "$pom_file" ]]; then
  echo "错误：BOM 文件不存在：$pom_file" >&2
  exit 1
fi

if ! command -v xmllint >/dev/null 2>&1; then
  echo "错误：未找到 xmllint，请先安装 libxml2 工具。" >&2
  exit 1
fi

declare -A repository_versions=()
declare -A repository_artifacts=()
repository_order=()

dependency_path='//*[local-name()="dependencyManagement"]/*[local-name()="dependencies"]/*[local-name()="dependency"]'
dependency_count="$(xmllint --xpath "count($dependency_path)" "$pom_file")"

for ((index = 1; index <= dependency_count; index++)); do
  artifact_id="$(xmllint --xpath "string(($dependency_path)[$index]/*[local-name()='artifactId'])" "$pom_file")"
  version="$(xmllint --xpath "string(($dependency_path)[$index]/*[local-name()='version'])" "$pom_file")"

  case "$artifact_id" in
    spring-data-jdbc|spring-data-r2dbc|spring-data-relational)
      repository_name="spring-data-relational"
      ;;
    spring-data-jpa|spring-data-envers)
      repository_name="spring-data-jpa"
      ;;
    spring-data-rest-*)
      repository_name="spring-data-rest"
      ;;
    *)
      repository_name="$artifact_id"
      ;;
  esac

  if [[ -n "${repository_versions[$repository_name]+x}" ]]; then
    if [[ "${repository_versions[$repository_name]}" != "$version" ]]; then
      echo "错误：同一仓库 $repository_name 对应了不同版本：" >&2
      echo "  ${repository_artifacts[$repository_name]} -> ${repository_versions[$repository_name]}" >&2
      echo "  $artifact_id -> $version" >&2
      exit 1
    fi

    repository_artifacts[$repository_name]+=", $artifact_id"
    continue
  fi

  repository_versions[$repository_name]="$version"
  repository_artifacts[$repository_name]="$artifact_id"
  repository_order+=("$repository_name")
done

mkdir -p "$output_dir"

for repository_name in "${repository_order[@]}"; do
  version="${repository_versions[$repository_name]}"
  repository_url="https://github.com/spring-projects/$repository_name.git"
  repository_dir="$output_dir/$repository_name"

  echo "处理：$repository_name"
  echo "模块：${repository_artifacts[$repository_name]}"
  echo "版本：$version"

  if [[ -d "$repository_dir/.git" ]]; then
    git -C "$repository_dir" fetch origin --tags
  elif [[ -e "$repository_dir" ]]; then
    echo "错误：目录已存在但不是 Git 仓库：$repository_dir" >&2
    exit 1
  else
    git clone "$repository_url" "$repository_dir"
  fi

  if ! git -C "$repository_dir" rev-parse --verify --quiet "refs/tags/$version" >/dev/null; then
    echo "错误：$repository_name 中不存在 BOM 指定的 tag：$version" >&2
    exit 1
  fi

  git -C "$repository_dir" switch --detach "$version"
  echo "已切换：$repository_name -> $version"
  echo
done

echo "所有仓库均已切换到 BOM 指定的版本。"
