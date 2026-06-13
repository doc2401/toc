

 

新建github仓库 `spring-data.2026.0.0`

查看 `2026.0.0` 各个项目对应的子版本
https://repo.maven.apache.org/maven2/org/springframework/data/spring-data-bom/2026.0.0/spring-data-bom-2026.0.0.pom

 
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