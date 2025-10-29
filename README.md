# R Projects Monorepo

This repository hosts one or more R projects (apps, analyses, scripts) in a single, consistent structure. It includes opinionated defaults for code style, linting, dependency management, CI, and VS Code setup.

## Structure

- `Sales_Analytics_Dashboard/` – Example project with a Shiny app, scripts, and reports.
- Additional projects can live as sibling folders at the repo root, each owning their own `README.md` and sub-structure.

## Quick start

- Prereqs: R (>= 4.1 recommended), Git, VS Code with the R extension.
- Optional but recommended: renv for reproducible dependencies.

Common tasks (PowerShell):

```powershell
# 1) Install renv and restore packages if lockfile exists
pwsh .\scripts\tasks.ps1 Init-Renv

# 2) Lint the whole repo
pwsh .\scripts\tasks.ps1 Lint

# 3) Format code consistently
pwsh .\scripts\tasks.ps1 Style

# 4) Run the Shiny dashboard (example)
pwsh .\scripts\tasks.ps1 Run-Dashboard -ProjectPath "Sales_Analytics_Dashboard"
```

## Conventions

- Code style: 2-space indent, LF line endings, format-on-save (VS Code).
- Linting: `lintr` with repo-level `.lintr`. CI fails on lint errors.
- Dependencies: `renv` (per-repo). Each project can also maintain its own snapshot.
- Data: by default, large/raw/derived data is ignored by `.gitignore`. Commit only samples.

## CI

GitHub Actions runs `lintr` on pushes and PRs. If `renv.lock` exists, CI restores it. See `.github/workflows/ci.yml`.

## Add a new project

1. Create a folder at the repo root: `My_Project/`.
2. Add your R scripts and a `README.md` describing how to run them.
3. Use `renv` (optional): run `Init-Renv` to initialize and snapshot dependencies.
4. Lint and format before committing.

## License

MIT (see `LICENSE`).
