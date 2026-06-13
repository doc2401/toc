#!/usr/bin/env bash

set -uo pipefail

source_dir="${1:-.}"
log_dir="${2:-./build-logs}"

repositories=(
  "spring-data-commons"
  "spring-data-relational"
  "spring-data-jpa"
  "spring-data-ldap"
  "spring-data-mongodb"
  "spring-data-redis"
  "spring-data-rest"
  "spring-data-cassandra"
  "spring-data-couchbase"
  "spring-data-elasticsearch"
  "spring-data-neo4j"
  "spring-data-keyvalue"
)

mkdir -p "$log_dir"

failed_projects=()

for project_name in "${repositories[@]}"; do
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
  echo "日志文件：$log_file"

  (
    cd "$project_dir" || exit 1
    "${maven_command[@]}" \
      --batch-mode \
      --no-transfer-progress \
      -DskipTests \
      -Dmaven.javadoc.failOnError=false \
      -Pdistribute \
      clean package javadoc:aggregate
  ) 2>&1 | tee "$log_file"

  build_status=${PIPESTATUS[0]}

  if [[ $build_status -eq 0 ]]; then
    echo "构建成功：$project_name"
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
