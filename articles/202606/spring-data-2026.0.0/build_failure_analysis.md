# Spring Data 2026.0.0 默认脚本构建失败分析报告

在尝试使用默认脚本构建 Spring Data 文档（以 `spring-data-mongodb` 为主）时，会遇到一系列链式的构建挂起与失败问题。本文档详细分析了导致默认构建流程无法跑通的三个核心原因及其底层机制。

---

## 核心原因分析

### 1. Node.js v24 版本下的 ZIP 流式解压死锁挂起 (流控制 Bug)
*   **问题现象**：执行构建时，进程会无报错地无限期挂起（Hang），且挂起位置始终停留在解压 UI 模板包（`ui-bundle.zip`）中的大文件（如 `fontawesome-webfont.ttf`，约 165KB）处。
*   **底层成因**：
    *   构建过程中由插件自动下载并使用的 Node.js 版本为 **v24.16.0**。
    *   Antora UI 加载器（`@antora/ui-loader`）依赖 `yauzl` 进行 ZIP 解压，而 `yauzl` 内部集成了早期的 `fd-slicer.js` 进行文件描述符分片读取。
    *   `fd-slicer.js` 手动覆写了流的 `destroy()` 方法，并在读取流到达 EOF（无更多数据）时同步且强行将自身状态标记为 `self.destroyed = true`。
    *   在 Node.js v24 中，这会直接导致 Node.js 核心流状态机在数据完全被消费者（Zlib 解压过滤器）读取完毕前，就将该流判定为已销毁并释放缓冲区。这导致剩余的压缩字节被丢弃，Zlib 过滤器永远无法接收到完整数据，导致解压流永远无法触发 `'end'` 事件，导致进程无限期挂起。
*   **修复方案**：
    重构 `node_modules/yauzl/fd-slicer.js` 及其在 `ui-loader` 中的调用，将自定义的 `destroy` 改为标准的 `_destroy`，并在到达 EOF 时取消手动设置 `self.destroyed` 的逻辑，交由 Node 原生的 `autoDestroy` 自动管理生命周期。

### 2. Playbook 依赖源配置缺失导致文档 Include 失败
*   **问题现象**：解决挂起问题后，Maven 构建报错中断，提示大量 `ERROR (asciidoctor): target of include not found: 4.1.0@data-commons::page$...`。
*   **底层成因**：
    *   `spring-data-mongodb`（版本 `5.1.0`）的文档页面深度依赖了 `spring-data-commons`（版本 `4.1.0`）的公共文档片段。
    *   然而，默认的 `antora-playbook.yml` 中对于 `spring-data-commons` 依赖库的配置仅指定了 `branches: [ main ]`。
    *   由于未声明拉取 `4.1.0` 标签，Antora 无法在文档资源池中找到 `4.1.0` 版本的 Commons 文档，导致 Asciidoctor 转换引擎抛出致命异常并中断构建。
*   **修复方案**：
    在 `antora-playbook.yml` 中为 `spring-data-commons` 添加 `tags: [ 4.1.0 ]`，并提前在本地缓存 Git 仓库中执行 `git fetch --tags` 获取对应版本的标签。

### 3. Spring 官方扩展插件的 Array 数组配置兼容性缺陷
*   **问题现象**：在补全 `spring-data-commons` 的 `4.1.0` 标签后，编译会报 `FATAL (antora): The "path" argument must be of type string. Received type undefined` 致命错误。
*   **底层成因**：
    *   在构建具有 Tag 的远程依赖分支时，Spring 官方的 `inject-collector-cache-config-extension` 缓存扩展插件会被激活，用于缓存构建的中间扫描件。
    *   该插件的源码（`inject-collector-cache-config-extension.js`）在读取项目的 `collector.scan` 配置时，默认假定其为一个单一的 Object（即 `scan.dir` 是一个字符串）。
    *   然而，`spring-data-commons` 和 `spring-data-mongodb` 里的 `antora.yml` 都将 `scan` 配置为了**一个包含两个对象的数组**（包含 `target/classes` 和 `target/antora`）。
    *   这导致插件在执行 `scanConfig.dir` 时读取到了 `undefined`，紧接着在执行 `expandPath(undefined)` 时引发类型异常导致整个构建崩溃。
*   **修复方案**：
    重构扩展插件中对 `scanConfig` 的解析逻辑，使其支持 Array 格式；同时修改 `cache-scandir.js` 在拷贝多个目录至同一缓存目录时对已存在路径（`fs.mkdirSync`）的处理，防止发生 `EEXIST` 异常。

---

## 结论
默认脚本之所以无法编译成功，是因为 **Node.js 24 版本的流控制改变** 触发了底层解压库的死锁 Bug，以及 **构建依赖缺少对应标签的拉取配置** 和 **Spring 官方 Antora 扩展插件本身对多扫描路径（Array）的解析缺陷** 共同导致的。

---

## 自动化修复与编译方案使用指南

为了彻底解决上述编译问题并实现一键构建，我们设计并实现了一套**高内聚、可复用、幂等**的自动化构建方案。

### 1. 新增的脚本与配置文件结构

*   **`build-all-spring-data-docs.sh` (编译总入口脚本)**：
    *   **职责**：主控脚本，负责环境检查、调用工具链修补、拉取标签、安装本地依赖、运行编译并收集文档。
    *   **特点**：自动处理了 Maven Wrapper (`mvnw`) 所需的工作目录依赖，即便在外层目录运行也不会报错。
*   **`patch-toolchain.js` (工具链补丁脚本)**：
    *   **职责**：自动修补 `antora-tooling/node_modules/` 下的第三方库。
    *   **修补细节**：
        1. 修复了 `yauzl/fd-slicer.js` 中的 EOF 同步关闭死锁。
        2. 修复了 `yauzl/fd-slicer.js` 中的 `ReadStream.prototype.destroy` 逻辑，移除了 Node 24 自动销毁流时产生的虚假 `stream destroyed` 报错。
        3. 修复了 `@springio/antora-extensions` 中对 `scan` 数组配置的解析并防范 `EEXIST` 创建目录冲突。
*   **`patch-playbooks.js` (Playbook 补丁脚本)**：
    *   **职责**：动态扫描所有子项目的 `antora-playbook.yml` 文件。如果包含 `spring-data-commons` 依赖但未配置标签，自动注入 `tags: [ 4.1.0 ]`。
*   **`spring-data-projects.json` (项目配置文件)**：
    *   **职责**：统一维护 12 个子项目的仓库、版本、文档路径和构建顺序，优先编译 `spring-data-commons`、`spring-data-keyvalue`、`spring-data-relational` 等基础项目。

### 2. 使用方法

直接在项目根目录下执行编译总入口脚本即可：

```bash
bash build-all-spring-data-docs.sh
```

Antora Git 缓存目录默认使用
`${XDG_CACHE_HOME:-$HOME/.cache}/antora/content`。如需指定其他位置，可以
设置环境变量：

```bash
ANTORA_CACHE_DIR=/path/to/antora/content bash build-all-spring-data-docs.sh
```

### 3. 可复用性设计 (如何应对重新 checkout)

本方案在设计上确保了**完全的可复用性**与**幂等性**，不需要人工介入官方代码的版本控制：
*   **如果您重新 `checkout` 了干净的官方分支**，本地的 `antora-playbook.yml` 会被还原为未加标签的状态。再次运行 `bash build-all-spring-data-docs.sh` 时，`patch-playbooks.js` 会自动检测并重新打上标签补丁。
*   **如果您清理了 `node_modules` 缓存**，脚本在编译前会通过 `npm install` 自动下回官方干净的包，并立即用 `patch-toolchain.js` 重新实施 Node 24 兼容性修补。
*   **如果您在任何外部目录运行**，脚本均能正确识别路径并把编译产物完美复制到统一的目录 `target/antora/site/` 下。
