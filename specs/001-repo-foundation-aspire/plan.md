# Implementation Plan: Repo Foundation & Aspire Setup

**Branch**: `001-repo-foundation-aspire` | **Date**: 2025-12-20 | **Spec**: specs/001-repo-foundation-aspire/spec.md
**Input**: Feature specification from `/specs/001-repo-foundation-aspire/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

Deliver a buildable .NET 10 repository foundation with a single `.slnx` solution, central
package management, and an Aspire AppHost that can run the distributed app locally with
Aspire-managed Postgres + Redis, plus CI guardrails that prevent convention regressions.

## Technical Context

**Language/Version**: .NET SDK 10 (all projects `net10.0`), C# `latest`  
**Primary Dependencies**: .NET Aspire (AppHost + service defaults), central package management (`Directory.Packages.props`)  
**Storage**: PostgreSQL (Aspire-managed resource), Redis (Aspire-managed resource)  
**Testing**: `dotnet test` is required; backend unit tests use xUnit (at least one passing test per test project to keep the signal meaningful)  
**Target Platform**: Local dev machines (macOS/Windows/Linux) + CI runners (GitHub Actions assumed)  
**Project Type**: single (repo-root `src/` + `tests/`)  
**Performance Goals**: N/A (foundation and orchestration scaffolding)  
**Constraints**: No hand-written docker compose; no `.sln`; no `PackageReference Version=`; docs must remain minimal (“install CLI, run CLI”)  
**Scale/Scope**: Repo scaffolding + Aspire orchestration wiring only (no product/domain features)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

**Gates (pre-Phase 0)**

- .NET 10-first: all projects target `net10.0`; repo pins SDK via `global.json`. **PASS (planned)**
- Aspire-first orchestration: AppHost + resources; no hand-written Docker Compose. **PASS (planned)**
- Central package management: `Directory.Packages.props`; no `PackageReference Version=`. **PASS (planned)**
- Solution/layout: single root `Bingo.slnx`; no `.sln`; follow `docs/design.md` layout. **PASS (planned)**
- Build/test/CI guardrails: CI runs `dotnet build` + `dotnet test` and fails on `.sln` or `PackageReference Version=`. **PASS (planned)**

**Waivers**: None.

**Re-check (post-Phase 1 design)**: No changes anticipated; gates remain **PASS**.

## Project Structure

### Documentation (this feature)

```text
specs/001-repo-foundation-aspire/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)
```text
global.json
Directory.Packages.props
Bingo.slnx

src/
├── Bingo.Api/
├── Bingo.Web/
├── Bingo.Core/
├── Bingo.Data/
└── Bingo.AppHost/

tests/
└── Bingo.*.Tests/

.config/
└── dotnet-tools.json   # optional (only if pinning Aspire CLI tool)
```

**Structure Decision**: Single repo layout per `docs/design.md` (repo-root `src/` + `tests/`).

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |

## Phase 0: Research (Decisions)

This feature requires a few concrete choices (SDK pin, Aspire CLI approach). Decisions and
rationale are captured in `research.md`.

## Phase 1: Design Outputs

- `data-model.md`: N/A for product/domain entities in this feature (scaffolding only)
- `contracts/`: N/A for API contracts in this feature (no endpoints specified yet)
- `quickstart.md`: Minimal, stable local run steps
