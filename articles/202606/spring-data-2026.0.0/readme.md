

 

新建github仓库 `spring-data.2026.0.0`

查看 `2026.0.0` 各个项目对应的子版本
https://repo.maven.apache.org/maven2/org/springframework/data/spring-data-bom/2026.0.0/spring-data-bom-2026.0.0.pom

## 脚本使用

脚本需要在 Bash 环境中运行。开始前可以添加执行权限：

```bash
chmod +x create-directories.sh \
  checkout-spring-data-projects.sh \
  build-spring-data-docs.sh
```

### 1. 根据 BOM 创建目录

`create-directories.sh` 读取 Maven BOM 中
`dependencyManagement/dependencies/dependency/artifactId` 的值，并为每个
`artifactId` 创建一个空目录。

依赖：

- Bash
- `xmllint`（通常由 `libxml2` 软件包提供）

用法：

```bash
./create-directories.sh [POM 文件] [输出目录]
```

不传参数时，默认读取当前目录下的
`spring-data-bom-2026.0.0.pom`，并在当前目录创建文件夹：

```bash
./create-directories.sh
```

指定 POM 和输出目录：

```bash
./create-directories.sh spring-data-bom-2026.0.0.pom ./artifact-directories
```

### 2. Checkout 子项目并切换 tag

`checkout-spring-data-projects.sh` 会读取 Spring Data BOM 中每个模块的
版本，克隆对应的源码仓库，并分别切换到各自的版本 tag。对于已经存在的
Git 仓库，脚本会先拉取远程 tags。

JDBC 和 R2DBC 共用 `spring-data-relational` 仓库，Envers 位于
`spring-data-jpa` 仓库中，因此这些仓库不会被重复克隆。

 
```bash
# ./checkout-spring-data-projects.sh [BOM 文件] [输出目录]
bash checkout-spring-data-projects.sh  spring-data-bom-2026.0.0.pom ./sources
```

脚本不会把 BOM 版本 `2026.0.0` 当作所有仓库共同的 tag，而是使用各模块
在 BOM 中声明的版本。例如 Commons、JPA 和 Relational 使用 `4.1.0`，
Cassandra 使用 `5.1.0`，Neo4j 使用 `8.1.0`。

每个仓库都必须存在 BOM 指定的版本 tag；缺少 tag 时脚本会报错并停止。
输出目录中如果存在同名但不是 Git 仓库的目录，脚本也会停止。

> 不要让 `create-directories.sh` 和 `checkout-spring-data-projects.sh`
> 使用同一个输出目录。前者创建的空目录会与后者需要克隆的 Git 仓库目录
> 冲突。

### 3. 构建 Javadoc 和 Reference

`build-spring-data-docs.sh` 会依次进入各个源码仓库，通过 Maven 的
`distribute` profile 构建 reference 文档，并执行聚合 Javadoc 构建。

脚本优先使用项目中的 `mvnw`；项目没有 Maven Wrapper 时，使用系统中的
`mvn`。每个项目的构建日志会单独保存，一个项目失败后仍会继续构建其他
项目，最后统一列出失败项目。

构建 `./sources` 中的项目，并将日志写入 `./build-logs`：

```bash
# ./build-spring-data-docs.sh [源码目录] [日志目录]
bash build-spring-data-docs.sh ./sources ./build-logs
```

实际执行的主要 Maven 命令为：

```bash
./mvnw -DskipTests -Dmaven.javadoc.failOnError=false \
  -Pdistribute clean package javadoc:aggregate
```

### 完整流程示例

```bash
# 1. 根据 BOM 克隆项目并分别切换到各模块对应的版本
./checkout-spring-data-projects.sh spring-data-bom-2026.0.0.pom ./sources

# 2. 构建各项目的 Javadoc 和 reference 文档
./build-spring-data-docs.sh ./sources ./build-logs
```

 
- [spring-projects/spring-data-commons: Spring Data Commons. Interfaces and code shared between the various datastore specific implementations. · GitHub](https://github.com/spring-projects/spring-data-commons)
- [Spring Data JDBC](https://spring.io/projects/spring-data-jdbc)
- [spring-data-relational/spring-data-jdbc at main · spring-projects/spring-data-relational · GitHub](https://github.com/spring-projects/spring-data-relational/tree/main/spring-data-jdbc)
- [Spring Data JPA](https://spring.io/projects/spring-data-jpa)
- [spring-projects/spring-data-jpa: Simplifies the development of creating a JPA-based data access layer. · GitHub](https://github.com/spring-projects/spring-data-jpa)
- [Spring Data LDAP](https://spring.io/projects/spring-data-ldap)
- [spring-projects/spring-data-ldap: Repository abstraction for Spring LDAP · GitHub](https://github.com/spring-projects/spring-data-ldap)
- [Spring Data MongoDB](https://spring.io/projects/spring-data-mongodb)
- [spring-projects/spring-data-mongodb: Provides support to increase developer productivity in Java when using MongoDB. Uses familiar Spring concepts such as a template classes for core API usage and lightweight repository style data access. · GitHub](https://github.com/spring-projects/spring-data-mongodb)
- [Spring Data Redis](https://spring.io/projects/spring-data-redis)
- [spring-projects/spring-data-redis: Provides support to increase developer productivity in Java when using Redis, a key-value store. Uses familiar Spring concepts such as a template classes for core API usage and lightweight repository style data access. · GitHub](https://github.com/spring-projects/spring-data-redis)
- [Spring Data R2DBC](https://spring.io/projects/spring-data-r2dbc)
- [spring-data-relational/spring-data-r2dbc at main · spring-projects/spring-data-relational · GitHub](https://github.com/spring-projects/spring-data-relational/tree/main/spring-data-r2dbc)
- [Spring Data REST](https://spring.io/projects/spring-data-rest)
- [spring-projects/spring-data-rest: Simplifies building hypermedia-driven REST web services on top of Spring Data repositories · GitHub](https://github.com/spring-projects/spring-data-rest)
- [Spring Data for Apache Cassandra](https://spring.io/projects/spring-data-cassandra)
- [spring-projects/spring-data-cassandra: Provides support to increase developer productivity in Java when using Apache Cassandra. Uses familiar Spring concepts such as a template classes for core API usage and lightweight repository style data access. · GitHub](https://github.com/spring-projects/spring-data-cassandra)
- [Spring Data Couchbase](https://spring.io/projects/spring-data-couchbase)
- [spring-projects/spring-data-couchbase: Provides support to increase developer productivity in Java when using Couchbase. Uses familiar Spring concepts such as a template classes for core API usage and lightweight repository style data access. · GitHub](https://github.com/spring-projects/spring-data-couchbase)
- [Spring Data Elasticsearch](https://spring.io/projects/spring-data-elasticsearch)
- [spring-projects/spring-data-elasticsearch: Provide support to increase developer productivity in Java when using Elasticsearch. Uses familiar Spring concepts such as a template classes for core API usage and lightweight repository style data access. · GitHub](https://github.com/spring-projects/spring-data-elasticsearch)
- [Spring Data Envers](https://spring.io/projects/spring-data-envers)
- [spring-data-jpa/spring-data-envers at main · spring-projects/spring-data-jpa · GitHub](https://github.com/spring-projects/spring-data-jpa/tree/main/spring-data-envers)
- [Spring Data Neo4j](https://spring.io/projects/spring-data-neo4j)
- [spring-projects/spring-data-neo4j: Provide support to increase developer productivity in Java when using Neo4j. Uses familiar Spring concepts such as a template classes for core API usage and lightweight repository style data access. · GitHub](https://github.com/spring-projects/spring-data-neo4j)






## sprnig-data

Spring Data’s mission is to provide a familiar and consistent, Spring-based programming model for data access while still retaining the special traits of the underlying data store.

It makes it easy to use data access technologies, relational and non-relational databases, map-reduce frameworks, and cloud-based data services. This is an umbrella project which contains many subprojects that are specific to a given database. The projects are developed by working together with many of the companies and developers that are behind these exciting technologies.

## [](#features)[](#features)Features

+   Powerful repository and custom object-mapping abstractions
+   Dynamic query derivation from repository method names
+   Implementation domain base classes providing basic properties
+   Support for transparent auditing (created, last changed)
+   Possibility to integrate custom repository code
+   Easy Spring integration via JavaConfig and custom XML namespaces
+   Advanced integration with Spring MVC controllers
+   Experimental support for cross-store persistence

## [](#main-modules)[](#main-modules)Main modules

+   [Spring Data Commons](https://github.com/spring-projects/spring-data-commons) - Core Spring concepts underpinning every Spring Data module.
+   [Spring Data JDBC](https://spring.io/projects/spring-data-jdbc) - Spring Data repository support for JDBC.
+   [Spring Data R2DBC](https://spring.io/projects/spring-data-r2dbc) - Spring Data repository support for R2DBC.
+   [Spring Data JPA](https://spring.io/projects/spring-data-jpa) - Spring Data repository support for JPA.
+   [Spring Data KeyValue](https://github.com/spring-projects/spring-data-keyvalue) - `Map` based repositories and SPIs to easily build a Spring Data module for key-value stores.
+   [Spring Data LDAP](https://spring.io/projects/spring-data-ldap) - Spring Data repository support for [Spring LDAP](https://github.com/spring-projects/spring-ldap).
+   [Spring Data MongoDB](https://spring.io/projects/spring-data-mongodb) - Spring based, object-document support and repositories for MongoDB.
+   [Spring Data Redis](https://spring.io/projects/spring-data-redis) - Easy configuration and access to Redis from Spring applications.
+   [Spring Data REST](https://spring.io/projects/spring-data-rest) - Exports Spring Data repositories as hypermedia-driven RESTful resources.
+   [Spring Data for Apache Cassandra](https://spring.io/projects/spring-data-cassandra) - Easy configuration and access to Apache Cassandra or large scale, highly available, data oriented Spring applications.
