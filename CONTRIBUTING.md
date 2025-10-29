# Contributing

Thanks for taking the time to contribute! This repo uses an opinionated but simple workflow.

## Getting started

- Install R and VS Code. Recommended extensions are suggested automatically.
- Clone the repo and open it in VS Code.
- Optionally set up `renv` for reproducible dependencies (see below).

## Workflow

- Create a feature branch from `main`.
- Keep changes focused; small PRs are easier to review.
- Run linters and formatters before committing:
  - `pwsh .\\scripts\\tasks.ps1 Lint`
  - `pwsh .\\scripts\\tasks.ps1 Style`
- Write or update project-specific `README.md` with run instructions.

## Code style & linting

- 2-space indent, LF newlines, format on save.
- Lint with `lintr` using repo-level `.lintr`.
- CI will fail on lint errors.

## Dependencies with renv

- Initialize once per repo: `pwsh .\\scripts\\tasks.ps1 Init-Renv`
- Add packages as usual (`install.packages(...)`), then snapshot: `renv::snapshot()`.
- Commit `renv.lock` (not `renv/library/`).

## Commit messages

- Use clear, imperative messages (e.g., "Add data loader"), referencing issues where helpful.

## Reporting issues

- Use GitHub Issues. Include steps to reproduce, expected vs actual behavior, and logs if relevant.
