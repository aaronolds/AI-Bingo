---

description: "Task list for Repo Foundation & Aspire Setup"
---

# Tasks: Repo Foundation & Aspire Setup

**Input**: Design documents from `/specs/001-repo-foundation-aspire/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, quickstart.md

**Tests**: Tests are REQUIRED. Backend tests MUST use xUnit and `dotnet test` MUST be part of the standard validation loop.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `- [ ] T### [P?] [US#?] Description with file path`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[US#]**: Which user story this task belongs to (US1/US2/US3)
- Every task includes at least one concrete file path

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Create the baseline repository directories and docs anchors used by all stories.

- [x] T001 Create baseline repo directories `src/` and `tests/`
- [x] T002 Create CI folder structure in `.github/workflows/`
- [x] T003 [P] Add `.config/` directory (reserved for optional `dotnet-tools.json`)

**Checkpoint**: repo has the required top-level directories.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Shared configuration that all projects will inherit.

- [x] T004 Add repo-wide MSBuild defaults in `Directory.Build.props` (set `TargetFramework` to `net10.0`, `LangVersion` to `latest`, and `ManagePackageVersionsCentrally` to `true`)
- [ ] T005 [P] Add repo-wide test SDK defaults in `Directory.Build.targets` (optional; only if needed to keep new test projects consistent)

**Checkpoint**: foundation defaults exist for subsequent project scaffolding.

---

## Phase 3: User Story 1 — Buildable Repo Foundation (Priority: P1) 🎯 MVP

**Goal**: A developer can clone the repo and successfully run `dotnet build` and `dotnet test` from the repo root using the pinned SDK.

**Independent Test**: On a clean machine with the pinned SDK installed, running `dotnet build` and `dotnet test` from repo root succeeds.

### Implementation

- [x] T006 [US1] Pin .NET 10 SDK in `global.json`
- [x] T007 [US1] Add central package management file `Directory.Packages.props` with initial package versions (Aspire packages, xUnit test packages, and any baseline SDK packages needed)
- [x] T008 [US1] Create root solution in `.slnx` format at `Bingo.slnx` (no `.sln` committed)

- [x] T009 [P] [US1] Scaffold `src/Bingo.Core/Bingo.Core.csproj` targeting `net10.0`
- [x] T010 [P] [US1] Scaffold `src/Bingo.Data/Bingo.Data.csproj` targeting `net10.0`
- [x] T011 [P] [US1] Scaffold `src/Bingo.Api/Bingo.Api.csproj` targeting `net10.0`
- [x] T012 [P] [US1] Scaffold `src/Bingo.Web/Bingo.Web.csproj` targeting `net10.0` (placeholder web app; minimal)

- [x] T013 [P] [US1] Create xUnit test project `tests/Bingo.Core.Tests/Bingo.Core.Tests.csproj` targeting `net10.0` (include at least one passing test)
- [x] T014 [P] [US1] Create xUnit test project `tests/Bingo.Api.Tests/Bingo.Api.Tests.csproj` targeting `net10.0` (include at least one passing test)

- [x] T015 [US1] Add all projects to `Bingo.slnx`
- [x] T016 [US1] Ensure no project files contain `PackageReference` with `Version=` (enforced by `Directory.Packages.props`)
- [x] T017 [US1] Verify repo-root build passes and document expected build command in `README.md`

**Checkpoint**: US1 is complete when `dotnet build` and `dotnet test` succeed from repo root.

---

## Phase 4: User Story 2 — One-Command Local Distributed Run (Priority: P2)

**Goal**: A single Aspire CLI command starts the distributed app locally (API + Postgres + Redis) and the dashboard shows all resources/services.

**Independent Test**: Running the single documented Aspire CLI command from repo root starts the dashboard and shows `Bingo.Api`, Postgres, and Redis running.

### Implementation

- [x] T018 [US2] Scaffold the Aspire AppHost project via Aspire CLI into `src/Bingo.AppHost/Bingo.AppHost.csproj`
- [x] T019 [US2] Add Postgres Aspire resource via CLI (resulting changes under `src/Bingo.AppHost/`)
- [x] T020 [US2] Add Redis Aspire resource via CLI (resulting changes under `src/Bingo.AppHost/`)
- [x] T021 [US2] Wire `src/Bingo.Api/Bingo.Api.csproj` into the AppHost so it starts as part of the distributed app (changes under `src/Bingo.AppHost/`)
- [x] T022 [US2] Document the single supported local run command in `README.md` (minimal: install Aspire CLI, run the command; avoid multi-version instructions)
- [x] T023 [US2] Align `specs/001-repo-foundation-aspire/quickstart.md` with the single-command run guidance (keep it minimal and stable)

**Checkpoint**: US2 is complete when the dashboard shows API + Postgres + Redis running via a single command.

---

## Phase 5: User Story 3 — CI Guardrails for Conventions (Priority: P3)

**Goal**: CI fails fast when `.sln` exists or when any `PackageReference` specifies `Version=`, and runs `dotnet build` + `dotnet test` for compliant changes.

**Independent Test**: A PR that introduces a `.sln` or `PackageReference Version=` fails CI with a clear message; compliant changes pass.

### Implementation

- [x] T024 [US3] Add guardrail script `eng/ci/guardrails.sh` that fails on any `*.sln` and any `PackageReference` containing `Version=`
- [x] T025 [US3] Add CI workflow `.github/workflows/ci.yml` that runs `eng/ci/guardrails.sh`, then `dotnet build`, then `dotnet test`
- [x] T026 [US3] Add a short CI note to `README.md` describing what CI enforces (no `.sln`, no `PackageReference Version=`)

**Checkpoint**: US3 is complete when CI enforces guardrails + build/test.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Cleanups and validation that span multiple stories.

- [x] T027 [P] Normalize and de-flake `docs/design.md` (remove garbled/truncated fragments, replace nonstandard separators, deduplicate repeated lines, and normalize list formatting to Markdown bullets without changing intent)
- [x] T028 Run the full quickstart validation and ensure it matches reality: `specs/001-repo-foundation-aspire/quickstart.md`

---

## Dependencies & Execution Order

### User Story Dependencies (Dependency Graph)

- US1 → blocks US2 (AppHost wires to projects created in US1)
- US1 → blocks US3 (CI should build/test the real solution/projects)
- US2 and US3 can proceed in parallel *after* US1 completes

### Parallel Opportunities

- Within US1, project scaffolding tasks T009–T014 are parallelizable (different directories/files)
- After US1, US2 (AppHost/resources) and US3 (CI/guardrails) can be done in parallel

---

## Parallel Execution Examples

### US1 (parallel scaffolding)

```text
Run in parallel:
- T009 [US1] src/Bingo.Core/Bingo.Core.csproj
- T010 [US1] src/Bingo.Data/Bingo.Data.csproj
- T011 [US1] src/Bingo.Api/Bingo.Api.csproj
- T012 [US1] src/Bingo.Web/Bingo.Web.csproj
- T013 [US1] tests/Bingo.Core.Tests/Bingo.Core.Tests.csproj
- T014 [US1] tests/Bingo.Api.Tests/Bingo.Api.Tests.csproj

Then (sequential):
- T015 add to Bingo.slnx
- T017 verify dotnet build/test and update README.md
```

### US2 (AppHost/resources)

```text
Mostly sequential in src/Bingo.AppHost/:
- T018 scaffold AppHost
- T019 add Postgres resource
- T020 add Redis resource
- T021 wire Bingo.Api into AppHost
- T022/T023 docs updates
```

### US3 (CI/guardrails)

```text
Run in parallel:
- T024 eng/ci/guardrails.sh
- T025 .github/workflows/ci.yml

Then:
- T026 README.md note
```

---

## Implementation Strategy

### MVP Scope (recommended)

- Implement US1 only (through T017), stop and validate on a clean machine/CI runner.

### Incremental Delivery

- US1 → validate build/test
- US2 → validate one-command Aspire run
- US3 → validate CI guardrails and pipeline behavior
