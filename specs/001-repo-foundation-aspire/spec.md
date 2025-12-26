# Feature Specification: Repo Foundation & Aspire Setup

**Feature Branch**: `001-repo-foundation-aspire`  
**Created**: 2025-12-20  
**Status**: Draft  
**Input**: Derived from `docs/design.md` and `stories/epic-0-*`, `stories/epic-1-*`

## User Scenarios & Testing *(mandatory)*

<!--
  IMPORTANT: User stories should be PRIORITIZED as user journeys ordered by importance.
  Each user story/journey must be INDEPENDENTLY TESTABLE - meaning if you implement just ONE of them,
  you should still have a viable MVP (Minimum Viable Product) that delivers value.
  
  Assign priorities (P1, P2, P3, etc.) to each story, where P1 is the most critical.
  Think of each story as a standalone slice of functionality that can be:
  - Developed independently
  - Tested independently
  - Deployed independently
  - Demonstrated to users independently
-->

### User Story 1 - Buildable Repo Foundation (Priority: P1)

As a developer, I want a consistent .NET 10 repo foundation (pinned SDK, solution format,
central package versions, and expected folder layout) so I can clone the repo and build/test
reliably.

**Why this priority**: This is the prerequisite for all later work; if build and structure are
inconsistent, every subsequent feature becomes harder to develop and validate.

**Independent Test**: A developer can clone the repository, use the pinned .NET 10 SDK, and
successfully build/test from the repository root.

**Acceptance Scenarios**:

1. **Given** the repository is cloned and the pinned .NET 10 SDK is installed, **When** the
  developer runs `dotnet build` and `dotnet test`, **Then** the build and tests succeed.
2. **Given** the repository is cloned and multiple .NET SDKs are installed, **When** the
  developer runs `dotnet --version` from the repository root, **Then** the version selected
  matches the pinned SDK specified by `global.json`.

---

### User Story 2 - One-Command Local Distributed Run (Priority: P2)

As a developer, I want to start the distributed app locally using a single Aspire CLI command
so the system (API + resources) is easy to run and consistent across machines.

**Why this priority**: A one-command run loop enables fast iteration and reduces onboarding
friction; it is the repo's standard for local orchestration.

**Independent Test**: Running the single documented Aspire CLI command starts the Aspire
dashboard, provisions required resources (Postgres, Redis), and starts the API.

**Acceptance Scenarios**:

1. **Given** the developer has installed the required local prerequisites for Aspire,
   **When** they run the single documented Aspire CLI command from repo root,
   **Then** the Aspire dashboard starts and shows the distributed app running.
2. **Given** the distributed app is running, **When** the developer checks the dashboard,
   **Then** Postgres, Redis, and the API appear as running resources/services.

---

### User Story 3 - CI Guardrails for Conventions (Priority: P3)

As a developer, I want CI checks that prevent regressions in solution and dependency
conventions so the repo stays compliant over time.

**Why this priority**: Guardrails prevent subtle drift (e.g., accidental `.sln` commits or
package versions in project files) that can break the repo's standards.

**Independent Test**: CI reliably fails when conventions are violated and passes when the
repository is compliant.

**Acceptance Scenarios**:

1. **Given** a PR introduces a `.sln` file, **When** CI runs, **Then** CI fails with a clear
  message indicating `.sln` files are not allowed.
2. **Given** a PR introduces a `<PackageReference ... Version="..." />` in any project file,
  **When** CI runs, **Then** CI fails with a clear message indicating package versions must be
  centrally managed.

---

### Edge Cases

- The pinned .NET 10 SDK is not installed on the developer machine.
- The Aspire CLI is not installed or is incompatible with the pinned SDK.
- Local prerequisites required for Aspire-managed container resources are unavailable.
- A developer accidentally introduces a `.sln` or adds `Version=` attributes to package
  references.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The repository MUST pin a .NET 10 SDK via `global.json`.
- **FR-002**: The repository MUST use a single root solution file in `.slnx` format named
  `Bingo.slnx` and MUST NOT contain any `.sln` files.
- **FR-003**: The repository MUST follow the source layout described in `docs/design.md`,
  including `src/` projects and `tests/` projects.
- **FR-004**: The repository MUST use central package management via `Directory.Packages.props`.
- **FR-005**: All projects MUST be configured to manage package versions centrally and the repo
  MUST NOT contain `<PackageReference ... Version="..." />` entries.
- **FR-006**: Local development orchestration MUST use Aspire (no hand-written Docker Compose
  for dev orchestration).
- **FR-007**: An Aspire AppHost MUST exist under `src/Bingo.AppHost` and MUST be created via
  Aspire CLI workflows.
- **FR-008**: The AppHost MUST define a Postgres resource and a Redis resource managed by Aspire.
- **FR-009**: The distributed app MUST start the API as part of the Aspire run experience so that
  "Run locally" is a single Aspire CLI command.
- **FR-010**: CI MUST run restore/build/test and MUST include guardrails that fail if `.sln`
  files exist or if any project file contains a `PackageReference` with a `Version=` attribute.
- **FR-011**: Repository documentation MUST keep Aspire guidance minimal and stable: install the
  CLI and run the single command (avoid documenting version-specific CLI verbs).
- **FR-012**: Backend unit tests MUST use xUnit and MUST be runnable via `dotnet test` from the repository root.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: `global.json` exists and pins a .NET 10 SDK version.
- **SC-002**: `Bingo.slnx` exists at repo root and no `.sln` files exist anywhere in the repo.
- **SC-003**: No `<PackageReference ... Version="..." />` exists anywhere in the repository.
- **SC-004**: On a clean machine with prerequisites installed, `dotnet build` and `dotnet test` succeed.
- **SC-005**: On a machine with Aspire prerequisites installed, a single Aspire CLI command starts
  the distributed app and the Aspire dashboard shows the API + Postgres + Redis running.
- **SC-006**: CI fails when `.sln` or `PackageReference Version=` violations are introduced and
  passes when the repository complies with the conventions.
