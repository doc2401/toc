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




## 检出代码

## 创建分支


```bash

## git-bash 执行
# 获取文件夹名
d=$(basename "$PWD")

## 创建新分支
git worktree add -b lang "../$d.lang" HEAD
cd "../$d.lang"


# 添加名为 `lang` 的**远端仓库地址**
d=$(basename "$PWD")
url=$(git remote get-url origin)
url=${url%.git}
git remote add lang "$url.lang.git"

# 推送分支 
git push lang


```

## 拆分 Spring Cloud 文档目录

`split-spring-cloud-folders.ps1` 会遍历当前目录下所有 `spring-cloud-*`
项目目录，再遍历它们的直接子目录；每个子目录移动到
`00.<项目名>.<子目录名>\<项目名>\<子目录名>`。支持使用 `-WhatIf`
预览和 `-Copy` 可选复制模式，默认是拆分并移动。例如：

`spring-cloud-build/api` -> `00.spring-cloud-build.api/spring-cloud-build/api`

`spring-cloud-build/reference` -> `00.spring-cloud-build.reference/spring-cloud-build/reference`

不需要指定 `api`、`reference` 等子文件夹名称。先用 `-WhatIf` 预览，
确认后执行；使用 `-Copy` 时保留原目录。默认处理当前目录，也可以使用
`-RootPath` 指定其他目录，使用 `-ProjectPattern` 修改项目目录匹配规则：

```powershell
# 预览当前目录
.\split-spring-cloud-folders.ps1 -WhatIf

# 拆分并移动当前目录
.\split-spring-cloud-folders.ps1

# 拆分并复制当前目录
.\split-spring-cloud-folders.ps1 -Copy

# 指定要处理的目录
.\split-spring-cloud-folders.ps1 -RootPath "D:\docs"

# 指定目录并预览
.\split-spring-cloud-folders.ps1 -RootPath "D:\docs" -WhatIf

# 指定目录和项目匹配规则
.\split-spring-cloud-folders.ps1 `
  -RootPath "D:\docs" `
  -ProjectPattern "spring-cloud-*"
```



```bash

git add .
git commit -m "split api/ reference/"
```


**拆分html**
```powershell

Get-ChildItem -Directory -Filter "00*" | ForEach-Object {
    Set-Location $_.FullName
    pw2401 dir-copy -Extension html -DeleteOriginal
    Set-Location ..
} 


git add .
git commit -m "split html files"



Get-ChildItem -Directory -Filter "00.*.copy" | ForEach-Object {
    $name = $_.Name -replace "^00\.", "01." -replace "\.copy$", ".html"
    Rename-Item $_.FullName $name
}


git add .
git commit -m "00.*.copy -> 01.*.html "


git push lang



```


**github action**
```bash




## 忽略翻译的日志文件
echo "/*.log"  >> ".gitignore"

# 下载 lang.json 配置文件
curl -fsSL https://raw.githubusercontent.com/doc2401/actions/main/lang/lang.json -o lang.json

# 创建目录并下载工作流文件
mkdir -p .github/workflows && curl -fsSL https://raw.githubusercontent.com/doc2401/actions/main/lang/deploy-example.yml -o .github/workflows/lang-deploy.yml

## 删除原来的静态网站的 action
rm .github/workflows/static.yml

git add .
git commit -m "github action"


```

## end


