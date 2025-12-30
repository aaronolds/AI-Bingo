# Epic 0 / Story 4 — Baseline build/test + CI guardrails

## User Story
As a developer,
I want a baseline build/test pipeline and guardrails,
so that the repo stays compliant with solution and dependency conventions.

## Scope
- Ensure `dotnet build` and `dotnet test` run cleanly.
- Add CI checks for:
  - central package management compliance (no package versions in csproj)
  - solution format conventions (only `.slnx`, no `.sln`)

## Acceptance Criteria
- [ ] `dotnet build` succeeds on a clean machine.
- [ ] `dotnet test` succeeds (or test projects exist with a placeholder test to validate tooling).
- [ ] CI fails if any `<PackageReference ... Version="..." />` exists.
- [ ] CI fails if any `.sln` is committed.

## Implementation Tasks
- [ ] Add/confirm test projects under `tests/` and ensure they build/run.
- [ ] Add a CI workflow (e.g., GitHub Actions) that runs:
  - restore
  - build
  - test
- [ ] Add CI “grep” style checks:
  - fail if `Version=` appears on `PackageReference`
  - fail if a `*.sln` file exists

## Notes / Dependencies
- Depends on Story 1 (pinned SDK), Story 2 (solution exists), and Story 3 (central packages).
- Keep CI fast and deterministic; prefer simple checks over complex tooling at this stage.
