# Epic 0 / Story 2 — Create solution in `.slnx` format

## User Story

As a developer,
I want the repo to have a single `.slnx` solution file that includes all projects,
so that tooling and onboarding are consistent and we avoid committing a legacy `.sln`.

## Scope

- Create the root solution file `Bingo.slnx`.
- Ensure the solution uses `net10.0` defaults where appropriate.
- Ensure no `.sln` is committed.

## Acceptance Criteria

- [x] `Bingo.slnx` exists at repo root.
- [x] No `.sln` file is present in the repo.
- [x] All existing projects are included in `Bingo.slnx`.
- [x] `dotnet build Bingo.slnx` succeeds on a clean machine.

## Implementation Tasks

- [x] Create folder layout (if not already present):
  - `src/Bingo.Api`
  - `src/Bingo.Web`
  - `src/Bingo.Core`
  - `src/Bingo.Data`
  - `src/Bingo.AppHost`
  - `tests/Bingo.*.Tests`
- [x] Create `Bingo.slnx` at repo root.
- [x] Add all projects to the solution.
- [x] Add a guardrail (docs or CI) ensuring `.sln` files aren’t committed.

## Notes / Dependencies

- This story is foundational; subsequent stories assume the solution exists.
- If the exact `.slnx` creation flow differs by SDK version, use the supported `dotnet` tooling for the pinned SDK.
