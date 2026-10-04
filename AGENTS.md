# Repository Guidelines

## Project Structure & Module Organization

This Docsify index serves the owner’s documentation.

- `notes/` stores personal records: builds, translation, troubleshooting, and maintenance. Dated folders such as `202606/spring-data-2026.0.0/` also hold supporting utilities.
- `docs/` connects maintained documentation projects, including versions, translations, and APIs in sibling directories.
- `external/` contains third-party references in six category subdirectories. `external/README.md` is their overview.
- `project/` contains `about.md`, `repositories.md`, and `changelog.md`.
- `README.md`, `_sidebar.md`, and `_navbar.md` define main navigation; directory sidebars provide local navigation. `index.html` configures Docsify and `style.css` supplies styling.
- `.github/workflows/static.yml` deploys on pushes to `main`; `.nojekyll` preserves Docsify navigation files.

## Content & Navigation Priorities

Prioritize personal records and maintained documentation. The top menu has four entries: home, records, documents, and external references. Sidebars list only the current section. Keep external references secondary. Add records to `notes/README.md` and documentation entries to `docs/README.md`.

## Build, Test, and Development Commands

The index requires no compilation or root npm installation.

- With existing Python, run `python -m http.server 8000 --bind 127.0.0.1 --directory ..`; visit `http://127.0.0.1:8000/toc/`. Serving the parent exposes sibling mirrors. Docsify assets require CDN access.
- `git diff --check` checks tracked changes for whitespace errors.
- `bash -n path/to/script.sh` and `node --check path/to/script.js` validate syntax without execution.
- After approval, run `bash build-spring-data-docs.sh` from its archive directory; consult its readme for prerequisites.

## Coding Style & Naming Conventions

Use UTF-8 and preserve Chinese text. Match surrounding formatting; HTML, CSS, and JavaScript generally use two-space indentation. No formatter or linter is configured. Use lowercase, hyphenated names, except `README.md`, `AGENTS.md`, and Docsify navigation files. Preserve versions and mirror-relative links such as `../../spring-data.2026.0.0/`.

## Testing Guidelines

No automated framework or coverage threshold exists. Check changed navigation and links in one browser when applicable; report unavailable mirrors. Use syntax checks for script edits. Follow archive-local ignore rules for generated files.

## Commit & Pull Request Guidelines

Recent commits commonly use `docs:` and `feat:` prefixes. Describe affected paths, purpose, validation, relevant issues, and visual changes with screenshots when applicable.

## Agent Execution Rules

Use existing environments and minimal relevant checks. Before costly operations—including comprehensive, cross-browser/OS, or performance tests; isolated environments; large downloads; substantial runtime, compute, or token use; pushes, PRs, releases, deployments, or remote workflows—explain purpose, scope, estimated cost, uncertainties, and remote effects, then await explicit approval. Silence is not approval. Approval covers only the stated scope; pause for expansion. Do not bypass permission through another tool or agent. Report completed and unperformed validation.
