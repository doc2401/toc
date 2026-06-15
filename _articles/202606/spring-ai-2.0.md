

https://spring.io/blog/2026/06/12/spring-ai-2-0-0-GA-available-now

spring ai 2.0 已经于 June 12, 2026 发布了

编译文档 准备翻译


首先 [新建repo](https://github.com/new)   `spring-ai.2.0.0`

`Start coding with Codespaces` 打开一个服务器准备编译



## 编译文档


命令列表
```bash
#确认 java 版本
java -version
# 切换到 上级目录
cd ../

# 克隆 spring-ai 源码
gh repo clone spring-projects/spring-ai 

# 切换分支
cd spring-ai
git fetch --tags
git checkout tags/v2.0.0

# 编译文档
./mvnw -pl spring-ai-docs antora
mv /workspaces/spring-ai/spring-ai-docs/target/antora/site /workspaces/spring-ai.2.0.0/reference

# 编译 javadoc
./mvnw javadoc:aggregate
# 移动目录
mv /workspaces/spring-ai/target/reports/apidocs /workspaces/spring-ai.2.0.0/api




# git 提交 推送
git add .
git commit -m "docs: add generated Spring AI 2.0.0 reference and API docs"
git push
 
```


命令输出

```bash
#确认 java 版本
@doc2401 ➜ /workspaces/spring-ai.2.0.0 (main) $ java -version
openjdk version "25.0.2" 2026-01-20 LTS
OpenJDK Runtime Environment Microsoft-13053558 (build 25.0.2+10-LTS)
OpenJDK 64-Bit Server VM Microsoft-13053558 (build 25.0.2+10-LTS, mixed mode, sharing)

# 切换到 上级目录
@doc2401 ➜ /workspaces/spring-ai.2.0.0 (main) $ cd ../
@doc2401 ➜ /workspaces $ 

# 克隆 spring-ai 源码
@doc2401 ➜ /workspaces $ gh repo clone spring-projects/spring-ai
Cloning into 'spring-ai'...
remote: Enumerating objects: 190510, done.
remote: Counting objects: 100% (1122/1122), done.
remote: Compressing objects: 100% (377/377), done.
remote: Total 190510 (delta 849), reused 745 (delta 745), pack-reused 189388 (from 2)
Receiving objects: 100% (190510/190510), 102.10 MiB | 26.25 MiB/s, done.
Resolving deltas: 100% (74999/74999), done.
Filtering content: 100% (1/1), 86.20 MiB | 7.20 MiB/s, done.

# 切换分支
@doc2401 ➜ /workspaces $ cd spring-ai
@doc2401 ➜ /workspaces/spring-ai (main) $ 
@doc2401 ➜ /workspaces/spring-ai (main) $ git fetch --tags
@doc2401 ➜ /workspaces/spring-ai (main) $ git checkout tags/v2.0.0
Note: switching to 'tags/v2.0.0'.
....
....
....
HEAD is now at ef502dab6 Release version 2.0.0
@doc2401 ➜ /workspaces/spring-ai (ef502dab6) $ 
 

# Reference Doc
@doc2401 ➜ /workspaces/spring-ai (ef502dab6) $ ./mvnw -pl spring-ai-docs antora
....
....
[INFO] Site generation complete!
[INFO] Open file:///workspaces/spring-ai/spring-ai-docs/target/antora/site in a browser to view your site.
[INFO] Skipping cache save: no artifacts to save (only metadata present)
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  04:43 min
[INFO] Finished at: 2026-06-13T02:05:52Z
[INFO] ------------------------------------------------------------------------
@doc2401 ➜ /workspaces/spring-ai (ef502dab6) $ 


# 移动构建产物到指定目录
@doc2401 ➜ /workspaces/spring-ai (ef502dab6) $ mv /workspaces/spring-ai/spring-ai-docs/target/antora/site /workspaces/spring-ai.2.0.0/reference


# API Doc（聚合 Javadoc）
@doc2401 ➜ /workspaces/spring-ai (ef502dab6) $ ./mvnw javadoc:aggregate
....
....
[INFO] ------------------------------------------------------------------------
[INFO] Reactor Summary for Spring AI Parent 2.0.0:
[INFO] 
[INFO] Spring AI BOM ...................................... SKIPPED
[INFO] Spring AI Parent ................................... SUCCESS [04:12 min]
[INFO] Spring AI Commons .................................. SKIPPED
[INFO] Spring AI Template StringTemplate .................. SKIPPED
[INFO] Spring AI Model .................................... SKIPPED
[INFO] Spring AI Chat Client .............................. SKIPPED
[INFO] Spring AI Docs ..................................... SKIPPED
[INFO] Spring AI Vector Store ............................. SKIPPED
[INFO] Spring AI RAG ...................................... SKIPPED
[INFO] Spring AI Advisors ................................. SKIPPED
[INFO] spring-ai-tool-search-tool ......................... SKIPPED
[INFO] Spring AI Model - ONNX Transformers ................ SKIPPED
[INFO] Spring AI Test ..................................... SKIPPED
[INFO] WebFlux transports ................................. SKIPPED
[INFO] Spring Web MVC transports .......................... SKIPPED
[INFO] Spring AI MCP Client ............................... SKIPPED
[INFO] Spring AI Model - OpenAI ........................... SKIPPED
[INFO] Spring AI Tool Search Advisor ...................... SKIPPED
[INFO] Spring AI Chat Model Auto Configuration ............ SKIPPED
[INFO] Spring AI Retry .................................... SKIPPED
[INFO] Spring AI Retry Auto Configuration ................. SKIPPED
[INFO] Spring AI Chat Observation Auto Configuration ...... SKIPPED
[INFO] Spring AI Embedding Observation Auto Configuration . SKIPPED
[INFO] Spring AI Image Observation Auto Configuration ..... SKIPPED
[INFO] Spring AI Chat Client Auto Configuration ........... SKIPPED
[INFO] Spring AI OpenAI Auto Configuration ................ SKIPPED
[INFO] Spring AI Chat Memory Auto Configuration ........... SKIPPED
[INFO] Spring AI Starter - OpenAI ......................... SKIPPED
[INFO] Spring AI Model - Vertex AI Embedding .............. SKIPPED
[INFO] Spring AI Vector Store - PGVector .................. SKIPPED
[INFO] Spring AI Auto Configuration for Postgres vector store SKIPPED
[INFO] Spring AI Auto Configuration for vector store observation SKIPPED
[INFO] Spring AI Starter - PGVector Vector Store .......... SKIPPED
[INFO] Spring AI Document Reader - HTML ................... SKIPPED
[INFO] Spring AI Document Reader - Markdown ............... SKIPPED
[INFO] Spring AI Integration Tests ........................ SKIPPED
[INFO] Spring AI Model - Ollama ........................... SKIPPED
[INFO] Spring AI Vector Store - OpenSearch ................ SKIPPED
[INFO] Spring AI Auto Configuration for Opensearch vector store SKIPPED
[INFO] Spring AI Vector Store - Chroma .................... SKIPPED
[INFO] Spring AI Auto Configuration for Chroma vector store SKIPPED
[INFO] Spring AI Vector Store - Weaviate .................. SKIPPED
[INFO] Spring AI Auto Configuration for Weaviate vector store SKIPPED
[INFO] Spring AI Vector Store - Milvus .................... SKIPPED
[INFO] Spring AI Auto Configuration for Milvus vector store SKIPPED
[INFO] Spring AI Vector Store - QDrant .................... SKIPPED
[INFO] Spring AI Auto Configuration for Qdrant vector store SKIPPED
[INFO] Spring AI Typesense Vector Store ................... SKIPPED
[INFO] Spring AI Auto Configuration for Typesense vector store SKIPPED
[INFO] Spring AI MCP Java SDK - Annotations ............... SKIPPED
[INFO] Spring AI MCP Client Common Auto Configuration ..... SKIPPED
[INFO] Spring AI MCP Client (HttpClient) Auto Configuration SKIPPED
[INFO] Spring AI MCP WebFlux Client Auto Configuration .... SKIPPED
[INFO] Spring AI Ollama Auto Configuration ................ SKIPPED
[INFO] Spring AI Vector Store - Redis ..................... SKIPPED
[INFO] Spring AI Vector Store - MongoDB Atlas ............. SKIPPED
[INFO] Spring AI Docker Compose ........................... SKIPPED
[INFO] Spring AI Auto Configuration for MongoDB Atlas vector store SKIPPED
[INFO] Spring AI Testcontainers ........................... SKIPPED
[INFO] Spring AI Tool Search Advisor Auto Configuration ... SKIPPED
[INFO] Spring AI MCP Server Common Auto Configuration for STDIO, SSE and Streamable-HTTP SKIPPED
[INFO] Spring AI Model - Anthropic ........................ SKIPPED
[INFO] Spring AI Anthropic Auto Configuration ............. SKIPPED
[INFO] Spring AI MCP Server WebFlux Auto Configuration .... SKIPPED
[INFO] Spring AI MCP Server WebMVC Auto Configuration ..... SKIPPED
[INFO] Spring AI Apache Cassandra Chat Memory Repository .. SKIPPED
[INFO] Spring AI Apache Cassandra Chat Memory Repository Auto Configuration SKIPPED
[INFO] Spring AI JDBC Chat Memory ......................... SKIPPED
[INFO] Spring AI JDBC Chat Memory Repository Auto Configuration SKIPPED
[INFO] Spring AI MongoDB Chat Memory ...................... SKIPPED
[INFO] Spring AI MongoDB Chat Memory Auto Configuration ... SKIPPED
[INFO] Spring AI Neo4j Chat Memory Repository ............. SKIPPED
[INFO] Spring AI Neo4j Chat Memory Repository Auto Configuration SKIPPED
[INFO] Spring AI Chat Memory Repository - Redis ........... SKIPPED
[INFO] Spring AI Redis Chat Memory Auto Configuration ..... SKIPPED
[INFO] Spring AI Model - Amazon Bedrock ................... SKIPPED
[INFO] Spring AI Model - Amazon Bedrock Converse API ...... SKIPPED
[INFO] Spring AI Bedrock Auto Configuration ............... SKIPPED
[INFO] Spring AI DeepSeek ................................. SKIPPED
[INFO] Spring AI DeepSeek Auto Configuration .............. SKIPPED
[INFO] Spring AI Model - ElevenLabs ....................... SKIPPED
[INFO] Spring AI ElevenLabs Auto Configuration ............ SKIPPED
[INFO] Spring AI Model - Google GenAI Embedding ........... SKIPPED
[INFO] Spring AI Model - Google GenAI ..................... SKIPPED
[INFO] Spring AI Google GenAI Auto Configuration .......... SKIPPED
[INFO] Spring AI Model - Mistral AI ....................... SKIPPED
[INFO] Spring AI Mistral Auto Configuration ............... SKIPPED
[INFO] Spring AI Model - PostgresML ....................... SKIPPED
[INFO] Spring AI PostgresML Auto Configuration ............ SKIPPED
[INFO] Spring AI Model - Stability AI ..................... SKIPPED
[INFO] Spring AI Stability AI Auto Configuration .......... SKIPPED
[INFO] Spring AI ONNX Transformers Auto Configuration ..... SKIPPED
[INFO] Spring AI Vertex AI Auto Configuration ............. SKIPPED
[INFO] Spring AI Vector Store - Azure AI Search ........... SKIPPED
[INFO] Spring AI Auto Configuration for Azure vector store  SKIPPED
[INFO] Spring AI Vector Store - Amazon Bedrock Knowledge Base SKIPPED
[INFO] Spring AI Auto Configuration for Amazon Bedrock Knowledge Base vector store SKIPPED
[INFO] Spring AI Vector Store – Apache Cassandra .......... SKIPPED
[INFO] Spring AI Auto Configuration for Apache Cassandra vector store SKIPPED
[INFO] Spring AI Vector Store - Couchbase ................. SKIPPED
[INFO] Spring AI Auto Configuration for Couchbase vector store SKIPPED
[INFO] Spring AI Vector Store - Elasticsearch ............. SKIPPED
[INFO] Spring AI Auto Configuration for Elasticsearch vector store SKIPPED
[INFO] Spring AI Vector Store - GemFire ................... SKIPPED
[INFO] Spring AI Auto Configuration for Gemfire vector store SKIPPED
[INFO] Spring AI Vector Store - MariaDB ................... SKIPPED
[INFO] Spring AI Auto Configuration for MariaDB Atlas vector store SKIPPED
[INFO] Spring AI Vector Store - Neo4J ..................... SKIPPED
[INFO] Spring AI Auto Configuration for Neo4j vector store  SKIPPED
[INFO] Spring AI Vector Store - Oracle .................... SKIPPED
[INFO] Spring AI Auto Configuration for Oracle vector store SKIPPED
[INFO] Spring AI Vector Store - Pinecone .................. SKIPPED
[INFO] Spring AI Auto Configuration for Pinecone vector store SKIPPED
[INFO] Spring AI Auto Configuration for Redis vector store  SKIPPED
[INFO] Spring AI Redis Semantic Cache ..................... SKIPPED
[INFO] Spring AI Redis Semantic Cache Auto Configuration .. SKIPPED
[INFO] Spring AI Vector Store - S3 ........................ SKIPPED
[INFO] Spring AI Auto Configuration for S3 vector store ... SKIPPED
[INFO] Spring AI Document Reader - PDF .................... SKIPPED
[INFO] Spring AI Document Reader - Tika ................... SKIPPED
[INFO] Spring AI Starter - MCP Client ..................... SKIPPED
[INFO] Spring AI Starter - MCP Client Webflux ............. SKIPPED
[INFO] Spring AI Starter - MCP Server ..................... SKIPPED
[INFO] Spring AI Starter - MCP Server Webflux ............. SKIPPED
[INFO] Spring AI Starter - MCP Server WebMvc .............. SKIPPED
[INFO] Spring AI Starter - Anthropic ...................... SKIPPED
[INFO] Spring AI Starter - Bedrock AI ..................... SKIPPED
[INFO] Spring AI Starter - Bedrock Converse API ........... SKIPPED
[INFO] Spring AI Starter - Chat Memory .................... SKIPPED
[INFO] Spring AI Starter - Cassandra Chat Memory Repository SKIPPED
[INFO] Spring AI Starter - JDBC Chat Memory Repository .... SKIPPED
[INFO] Spring AI Starter - MongoDB Chat Memory ............ SKIPPED
[INFO] Spring AI Starter - Neo4j Chat Memory Repository ... SKIPPED
[INFO] Spring AI Starter - Redis Chat Memory Repository ... SKIPPED
[INFO] Spring AI Starter - DeepSeek ....................... SKIPPED
[INFO] Spring AI Starter - ElevenLabs ..................... SKIPPED
[INFO] Spring AI Starter - Google Genai ................... SKIPPED
[INFO] Spring AI Starter - Google Genai Embedding ......... SKIPPED
[INFO] Spring AI Starter - MistralAI ...................... SKIPPED
[INFO] Spring AI Starter - Ollama ......................... SKIPPED
[INFO] Spring AI Starter - PostgresML Embedding ........... SKIPPED
[INFO] Spring AI Starter - Stability AI ................... SKIPPED
[INFO] Spring AI Starter - Transformers Embedding ......... SKIPPED
[INFO] Spring AI Starter - VertexAI Embedding ............. SKIPPED
[INFO] Spring AI Starter - Tool Search Advisor ............ SKIPPED
[INFO] Spring AI Starter - AWS OpenSearch Vector Store .... SKIPPED
[INFO] Spring AI Starter - Azure Vector Store ............. SKIPPED
[INFO] Spring AI Starter - Amazon Bedrock Knowledge Base Vector Store SKIPPED
[INFO] Spring AI Starter - Apache Cassandra Vector Store .. SKIPPED
[INFO] Spring AI Starter - Chroma Vector Store ............ SKIPPED
[INFO] Spring AI Starter - Couchbase Store ................ SKIPPED
[INFO] Spring AI Starter - Elasticsearch Store ............ SKIPPED
[INFO] Spring AI Starter - GemFire Vector Store ........... SKIPPED
[INFO] Spring AI Starter - MariaDB Vector Store ........... SKIPPED
[INFO] Spring AI Starter - Milvus Vector Store ............ SKIPPED
[INFO] Spring AI Starter - MongoDB Atlas Store ............ SKIPPED
[INFO] Spring AI Starter - Neo4j Store .................... SKIPPED
[INFO] Spring AI Starter - OpenSearch Store ............... SKIPPED
[INFO] Spring AI Starter - Oracle ......................... SKIPPED
[INFO] Spring AI Starter - Pinecone Vector Store .......... SKIPPED
[INFO] Spring AI Starter - Qdrant Vector Store ............ SKIPPED
[INFO] Spring AI Starter - Redis Vector Store ............. SKIPPED
[INFO] Spring AI Starter - S3 Vector Store ................ SKIPPED
[INFO] Spring AI Starter - Typesense ...................... SKIPPED
[INFO] Spring AI Starter - Weaviate Vector Store .......... SKIPPED
[INFO] Spring AI Vector Store - Coherence ................. SKIPPED
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  04:16 min
[INFO] Finished at: 2026-06-13T02:22:36Z
[INFO] ------------------------------------------------------------------------


# 移动目录
@doc2401 ➜ /workspaces/spring-ai (ef502dab6) $ mv /workspaces/spring-ai/target/reports/apidocs /workspaces/spring-ai.2.0.0/api




# git 提交 推送
@doc2401 ➜ /workspaces/spring-ai.2.0.0 (main) $ git add .
@doc2401 ➜ /workspaces/spring-ai.2.0.0 (main) $ git commit -m "docs: add generated Spring AI 2.0.0 reference and API docs"
@doc2401 ➜ /workspaces/spring-ai.2.0.0 (main) $ git push
Enumerating objects: 5013, done.
Counting objects: 100% (5013/5013), done.
Delta compression using up to 2 threads
Compressing objects: 100% (4954/4954), done.
Writing objects: 100% (5012/5012), 41.19 MiB | 10.04 MiB/s, done.
Total 5012 (delta 4025), reused 0 (delta 0), pack-reused 0 (from 0)
remote: Resolving deltas: 100% (4025/4025), done.
To https://github.com/doc2401/spring-ai.2.0.0
   907707f..85f0d81  main -> main
@doc2401 ➜ /workspaces/spring-ai.2.0.0 (main) $ 



```



## 分析文档


使用`pw2401 dir-info -Depth 1 -ExtSummary`分析文档

Directory Name  : api

Category        | Count      | Size
----------------|------------|---------------
Files           | 4047       | 66.10 MB
  .html         | 4022       | 64.05 MB

Directory Name  : reference
 
Category        | Count      | Size
----------------|------------|---------------
Files           | 302        | 53.71 MB
  .html         | 118        | 7.55 MB



 
api reference 差异过大 所以拆分翻译 并且 选取 reference 作为测试各个大模型翻译的试验场

## 拆分文件

创建分支

```bash

# 获取文件夹名
## powershell 7 
$d = Split-Path -Leaf $PWD
## bash
d=$(basename "$PWD")

## 创建新分支
git worktree add -b lang "../$d.lang" HEAD
cd "../$d.lang"

# 添加名为 `lang` 的**远端仓库地址**
## powershell 7 
$url = git remote get-url origin
$url = $url -replace '\.git$', ''
git remote add lang "$url.lang.git"
## bash
url=$(git remote get-url origin)
url=${url%.git}
git remote add lang "$url.lang.git"

```

重命名文件夹 00.*作为初始化目录

```bash
mv api 00.api
git add .
git commit -m "move: api -> 00.api"


mv reference 00.reference
git add .
git commit -m "move: reference -> 00.reference"


```
 

抽离 html 文件
```powershell

#提取 html
cd 00.api
pw2401 dir-copy  -Extension html -DeleteOriginal 
cd ../
mv  00.api.copy 01.api.html
# 提交 git 
git add .
git commit -m "move: 00.api(*.html) -> 01.api.html"

#提取 html
cd 00.reference
pw2401 dir-copy  -Extension html -DeleteOriginal 
cd ../
mv  00.reference.copy 01.reference.html
# 提交 git 
git add .
git commit -m "move: 00.reference(*.html) -> 01.reference.html"






```

## 开始翻译
 
```bash


## 默认 qwen3.5-9b 翻译
spring-ai.2.0.0.lang\01.reference.html> translate2401.ps1




2026-06-13 15:21:30 - INFO - Total time: 4826.54s
2026-06-13 15:21:30 - INFO - ==================================================
2026-06-13 15:21:30 - INFO - 任务完成总结
2026-06-13 15:21:30 - INFO - ==================================================
2026-06-13 15:21:30 - INFO - 总共处理文件: 118 个
2026-06-13 15:21:30 - INFO - 总文件大小: 7.5MB
2026-06-13 15:21:30 - INFO - API 调用次数: 7574 次
2026-06-13 15:21:30 - INFO - API 调用全部成功
2026-06-13 15:21:30 - INFO - 缓存统计: 当前大小 7456/1000000
2026-06-13 15:21:30 - INFO - 缓存命中: 4551 次, 命中率: 8.4%
2026-06-13 15:21:30 - INFO - ==================================================



git add ../01.reference.html.qwen_qwen3.5-9b.202606131401/
git add  ../01.reference.html.qwen_qwen3.5-9b.pageCache/

git commit -m "qwen3.5-9b"



## 使用 gemma-4-12b 翻译
spring-ai.2.0.0.lang\01.reference.html> translate2401.ps1  -Model "google/gemma-4-12b"

>>> 执行命令: python translate.py --api LM-Studio --model google/gemma-4-12b --dir . --pageCache


2026-06-13 19:09:32 - INFO - Total time: 13280.16s
2026-06-13 19:09:32 - INFO - ==================================================
2026-06-13 19:09:32 - INFO - 任务完成总结
2026-06-13 19:09:32 - INFO - ==================================================
2026-06-13 19:09:32 - INFO - 总共处理文件: 118 个
2026-06-13 19:09:32 - INFO - 总文件大小: 7.5MB
2026-06-13 19:09:32 - INFO - API 调用次数: 7574 次
2026-06-13 19:09:32 - INFO - API 调用全部成功
2026-06-13 19:09:32 - INFO - 缓存统计: 当前大小 7456/1000000
2026-06-13 19:09:32 - INFO - 缓存命中: 4551 次, 命中率: 8.4%
2026-06-13 19:09:32 - INFO - ==================================================



git add ../01.reference.html.google_gemma-4-12b.202606131528/
git add  ../01.reference.html.google_gemma-4-12b.pageCache/

git commit -m "gemma-4-12b"


cd ../


mv 01.reference.html.google_gemma-4-12b.202606131528 02.reference.html.google_gemma-4-12b.202606131528

mv 01.reference.html.qwen_qwen3.5-9b.202606131401 02.reference.html.qwen_qwen3.5-9b.202606131401


git add  01.reference.html.google_gemma-4-12b.202606131528/
git add  01.reference.html.qwen_qwen3.5-9b.202606131401/

git add  02.reference.html.google_gemma-4-12b.202606131528/
git add  02.reference.html.qwen_qwen3.5-9b.202606131401/


git commit -m "01 -> 02"

```

## 配置脚本

```bash

## 忽略翻译的日志文件
echo "/*.log"  >> ".gitignore"

# 下载 lang.json 配置文件
curl -fsSL https://raw.githubusercontent.com/doc2401/actions/main/lang/lang.json -o lang.json

# 创建目录并下载工作流文件
mkdir -p .github/workflows && curl -fsSL https://raw.githubusercontent.com/doc2401/actions/main/lang/deploy-example.yml -o .github/workflows/lang-deploy.yml

## 删除原来的静态网站的 action
rm .github/workflows/static.yml

```


## 子目录

忘记了 api 和 reference 应该放子目录 方便合并 

比如 `00.api` 应该是 `00.api/api`


## 配置 action
`lang.json` 
访问路径和 拼接地址

zh
zh/(访问地址) = "00.api/"(api的非html部分)+ "00.reference/"(reference的非html部分)+ "01.api.html/"(还未翻译的api)+ "02.reference.html.qwen_qwen3.5-9b.202606131401/"(reference已经翻译的部分)；

因为 api 还没有翻译所以就先不添加api部分
zh.qwen3.5-9b/(访问地址) = "00.reference/"(reference的非html部分)+ "02.reference.html.qwen_qwen3.5-9b.202606131401/"(reference已经翻译的部分)；

```json
[
        {
            "url": "zh/",
            "path": [
                "00.api/",
                "00.reference/",
                "01.api.html/",
                "02.reference.html.qwen_qwen3.5-9b.202606131401/"
            ]
        },
        {
            "url": "zh.qwen3.5-9b/",
            "path": [ 
                "00.reference/", 
                "02.reference.html.qwen_qwen3.5-9b.202606131401/"
            ]
        },
]
```


## 部署

` git push lang`推送分支等待部署后


## 翻译javadoc

```
spring-ai.2.0.0.lang\01.api.html> translate2401.ps1  --profile javadoc


2026-06-15 09:07:47 - INFO - Total time: 7524.89s
2026-06-15 09:07:47 - INFO - ==================================================
2026-06-15 09:07:47 - INFO - 任务完成总结
2026-06-15 09:07:47 - INFO - ==================================================
2026-06-15 09:07:47 - INFO - 总共处理文件: 4022 个
2026-06-15 09:07:47 - INFO - 总文件大小: 64.0MB
2026-06-15 09:07:47 - INFO - API 调用次数: 13479 次
2026-06-15 09:07:47 - INFO - API 调用全部成功
2026-06-15 09:07:47 - INFO - 缓存统计: 当前大小 13479/1000000
2026-06-15 09:07:47 - INFO - 缓存命中: 24898 次, 命中率: 37.0%
2026-06-15 09:07:47 - INFO - ==================================================

```

```bash
git add .
git commit -m "translate  javadoc"

# rename
git add .
git commit -m "01 -> 02"


```

查看 原文
https://doc.2401.xyz/spring-ai.2.0.0.lang/en/reference/api/prompt.html
qwen的翻译
https://doc.2401.xyz/spring-ai.2.0.0.lang/zh.qwen3.5-9b/reference/api/prompt.html
gemma-4-12b 翻译
https://doc.2401.xyz/spring-ai.2.0.0.lang/zh.gemma-4-12b/reference/api/prompt.html
 


## 翻译javadoc





# end