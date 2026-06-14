# 2025.1.2

2026-06-11

## 脚本使用

项目版本统一维护在 `spring-cloud-projects.json` 中。三个脚本均依赖 Bash
和 `jq`，不需要在脚本中重复维护仓库与版本。

### 创建项目目录

```bash
bash create-directories.sh spring-cloud-projects.json .
```

### Checkout 各项目版本

```bash
bash checkout-spring-cloud-projects.sh \
  spring-cloud-projects.json \
  ./sources
```

脚本会读取每个项目自己的 tag，例如 Spring Cloud Config 使用 `v5.0.4`，
Spring Cloud Contract 和 Function 使用 `v5.0.3`，其他项目按 JSON 中的
版本切换。

### 构建 Reference 和 Javadoc

```bash
bash build-spring-cloud-docs.sh \
  spring-cloud-projects.json \
  ./sources \
  ./build-logs
```

有 `docs/pom.xml` 的项目使用以下命令构建 Antora reference：

```bash
./mvnw -DskipTests -pl docs -Pdocs antora:antora
```

所有项目随后执行聚合 Javadoc 构建。源码、日志和 Maven 构建产物已由
`.gitignore` 忽略。

[spring-cloud/spring-cloud-release at v2025.1.2 · GitHub](https://github.com/spring-cloud/spring-cloud-release/tree/v2025.1.2/)


 - Spring Cloud Netflix `5.0.2` ([issues](https://github.com/spring-cloud/spring-cloud-netflix/releases/tag/v5.0.2))
 - Spring Cloud Stream `5.0.2` ([issues](https://github.com/spring-cloud/spring-cloud-stream/releases/tag/v5.0.2))
 - Spring Cloud Config `5.0.4` ([issues](https://github.com/spring-cloud/spring-cloud-config/releases/tag/v5.0.4))
 - Spring Cloud Consul `5.0.2` ([issues](https://github.com/spring-cloud/spring-cloud-consul/releases/tag/v5.0.2))
 - Spring Cloud Circuitbreaker `5.0.2` ([issues](https://github.com/spring-cloud/spring-cloud-circuitbreaker/releases/tag/v5.0.2))
 - Spring Cloud Build `5.0.2` ([issues](https://github.com/spring-cloud/spring-cloud-build/releases/tag/v5.0.2))
 - Spring Cloud Gateway `5.0.2` ([issues](https://github.com/spring-cloud/spring-cloud-gateway/releases/tag/v5.0.2))
 - Spring Cloud Bus `5.0.2` ([issues](https://github.com/spring-cloud/spring-cloud-bus/releases/tag/v5.0.2))
 - Spring Cloud Contract `5.0.3` ([issues](https://github.com/spring-cloud/spring-cloud-contract/releases/tag/v5.0.3))
 - Spring Cloud Vault `5.0.2` ([issues](https://github.com/spring-cloud/spring-cloud-vault/releases/tag/v5.0.2))
 - Spring Cloud Task `5.0.2` ([issues](https://github.com/spring-cloud/spring-cloud-task/releases/tag/v5.0.2))
 - Spring Cloud Function `5.0.3` ([issues](https://github.com/spring-cloud/spring-cloud-function/releases/tag/v5.0.3))
 - Spring Cloud Kubernetes `5.0.2` ([issues](https://github.com/spring-cloud/spring-cloud-kubernetes/releases/tag/v5.0.2))
 - Spring Cloud Commons `5.0.2` ([issues](https://github.com/spring-cloud/spring-cloud-commons/releases/tag/v5.0.2))
 - Spring Cloud Openfeign `5.0.2` ([issues](https://github.com/spring-cloud/spring-cloud-openfeign/releases/tag/v5.0.2))
 - Spring Cloud Zookeeper `5.0.2` ([issues](https://github.com/spring-cloud/spring-cloud-zookeeper/releases/tag/v5.0.2))

 *404*
 - Spring Cloud Starter Build `2025.1.2` ([issues](https://github.com/spring-cloud/spring-cloud-starter-build/releases/tag/v2025.1.2))




