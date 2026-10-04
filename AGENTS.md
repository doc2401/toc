# Repository Guidelines

## Project Structure & Module Organization

This repository is a Chinese-language Docsify documentation index.

- `index.html` configures Docsify; `style.css` supplies styling. `README.md`, `_sidebar.md`, and `_navbar.md` define the homepage and navigation.
- `_local/` indexes sibling offline mirrors. Topic pages live in `languages/`, `frontend/`, `middleware/`, `ai-data/`, `devops/`, and `graphics/`.
- `_articles/` contains articles and dated utilities, such as `202606/spring-data-2026.0.0/`, with Bash, PowerShell, Node.js, and Antora configuration.
- `.github/workflows/static.yml` publishes the repository to GitHub Pages on pushes to `main`. `.nojekyll` preserves underscore-prefixed directories.

## Build, Test, and Development Commands

The index requires no compilation or root npm installation.

- With existing Python, run `python -m http.server 8000 --bind 127.0.0.1 --directory ..` from the repository root; visit `http://127.0.0.1:8000/toc/`. Serving the parent also exposes sibling mirrors. Docsify assets require CDN access.
- `git diff --check` checks tracked changes for whitespace errors.
- `bash -n path/to/script.sh` and `node --check path/to/script.js` check changed scripts without executing them.
- From `_articles/202606/spring-data-2026.0.0/`, `bash build-spring-data-docs.sh` builds reference/API documentation; `bash collect-spring-data-docs.sh` copies existing outputs into `site/`. Builds require approval and prerequisites described in that directory’s readme.

## Coding Style & Naming Conventions

Use UTF-8 and preserve Chinese text. Follow surrounding formatting; HTML, CSS, and JavaScript generally use two-space indentation. No formatter or linter is configured.

Use descriptive lowercase, hyphenated filenames, such as `spring-framework-toc.md`. Update relevant sidebars when adding pages. Preserve mirror-relative paths such as `../../spring-data.2026.0.0/`, version identifiers, and badge labels such as `本地镜像`.

## Testing Guidelines

No automated test framework or coverage threshold exists. Check changed routes, navigation, and mirror links in one browser when applicable; report unavailable mirrors. Use syntax checks for script edits. Keep generated sources, dependencies, logs, and sites out of commits according to archive-local `.gitignore` files.

## Commit & Pull Request Guidelines

Recent history commonly uses `docs:` and `feat:` prefixes; prefer descriptive subjects over `update`. PR descriptions should explain changes, affected paths, validation, linked issues when relevant, and screenshots for visual changes.

## Agent Execution Rules

Use existing environments and minimal relevant checks. Before costly operations—including comprehensive, cross-browser/OS, or performance tests; isolated environments; large downloads; substantial runtime, compute, or token use; pushes, PRs, releases, deployments, or remote workflows—explain purpose, scope, estimated cost, uncertainties, and remote effects, then await explicit approval. Silence is not approval. Approval covers only the stated scope; pause for expansion. Do not bypass permission through another tool or agent. Report completed and unperformed validation.
