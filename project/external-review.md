# 外部参考核对记录

> 核对日期：2026-10-04。记录本次整理范围、链接处理与尚未确认的访问状态。

## 核对范围与方法

- 原目录有 386 个条目，其中 373 个不同的 HTTP(S) 链接；四个条目连接我的文档。
- 对原有链接及新增、替换候选共 448 个不同 URL 发出轻量 GET 请求，跟随 HTTP 重定向，读取前 16 KiB 和页面标题；对异常、迁移及新增来源补充核对官方页面。
- HTTP 200 只表示请求成功；另查到 Hive 镜像的软 404。HTML / JavaScript 跳转、登录限制和全文内容不会被这种请求完整验证。
- 整理后为八个分类、34 个主题页、384 个互不重复的外部 URL；替换 49 个原 URL，补充 25 个官方或原始参考条目。

## 分类调整

| 目录 | 内容 |
| --- | --- |
| `languages/` | 语言与运行时：语言教程、标准库和常用生态 |
| `frontend/` | 前端与跨平台：Web 标准、UI、构建与客户端 |
| `backend/` | 服务端与协议：Java 框架、API、认证与分布式服务 |
| `data/` | 数据与存储：数据库、检索、数据工程与存储 |
| `ai/` | AI 与机器学习：模型接口、应用编排与数据科学 |
| `devops/` | 研发与运维：构建、系统、云原生、可观测性与安全 |
| `quality/` | 测试与代码质量：测试框架、静态检查与依赖维护 |
| `graphics/` | 图形与游戏：创作工具、游戏引擎与图形 API |

`ai-data/` 分为 `ai/` 和 `data/`；`middleware/` 分为 `backend/` 和 `data/`。API / 认证移入服务端；测试与代码质量独立收纳；系统、可观测性、安全按用途分开。顶部四个入口与个人内容优先的定位保持一致。

## 修正与收录原则

- 修正微信错误域名与 Gin 的 404；Hive、HBase、Flume 和 jQuery 改用官方文档。移除 Oracle / SQL Server 的失效教程及重复的泛化入门教程。
- 模型供应商、Dify、FastGPT、ComfyUI 等主页改为开发文档；补充 Java、Spring、Web 标准、Linux、编译器与图形 API。
- CI/CD、测试、代码质量与 ORM 每个 URL 只保留一个入口；跨分类使用相关入口连接。Kafka、RabbitMQ、Blender 与 Spring AI 的个人镜像继续由“我的文档”维护。
- 社区翻译明确标注；Remix v2、Moment.js 的历史用途保留说明。MinIO 迁移后的入口标为 [AIStor 产品文档](https://docs.min.io/aistor/)，避免当成社区版本通用手册。
- 保留稳定的版本选择入口；`current` / `latest` 随上游更新，不能用动态链接证明某个固定版本。

## 访问待复核

最终目录中 379 个 URL 请求返回 200，以下 5 个入口未能通过自动请求确认。403 或 TLS 失败不直接等于网站失效。

| 入口 | 请求结果 | 处理 |
| --- | --- | --- |
| [https://studygolang.com/pkgdoc](https://studygolang.com/pkgdoc) | TLS 握手失败 | 保留官方或有用的社区入口，并在页面标注访问待复核 |
| [https://zh.cppreference.com/](https://zh.cppreference.com/) | HTTP 403 | 保留官方或有用的社区入口，并在页面标注访问待复核 |
| [https://dev.mysql.com/doc/](https://dev.mysql.com/doc/) | HTTP 403 | 官方文档索引可由网页检索读取，直接请求仍被拒绝；保留版本选择入口 |
| [https://milvus.io/docs/overview.md](https://milvus.io/docs/overview.md) | 循环重定向（HTTP 302） | 保留官方或有用的社区入口，并在页面标注访问待复核 |
| [https://wikis.khronos.org/opengl/](https://wikis.khronos.org/opengl/) | HTTP 403 | 保留官方或有用的社区入口，并在页面标注访问待复核 |

Milvus 的[概览文档](https://milvus.io/docs/overview.md)可由网页检索读取，直接请求仍发生循环重定向；保留并标为待复核。Rust Course 重定向后返回 404，本次移出，保留 Rust 官方教程。WebAssembly 的候选 `/docs/` 返回 404，保留已返回 200 的官方入口。

## 验证记录与后续维护

- 原始状态、重定向目标、标题、错误和最终归属保存于 [逐项链接结果](project/external-links.csv ':ignore')。该文件记录本次快照，不代表持续监控。
- 本次使用现有环境，检查修改涉及的内部路径、目录侧栏和单浏览器导航；未执行全功能、多浏览器、性能测试或镜像构建。
- 未下载依赖、大文件或文档副本，未修改远程状态。新增链接需确认标题、归属与版本；无法确认的入口明确保留待复核状态。

[外部参考](/external/README.md) · [关于项目](/project/about.md)
