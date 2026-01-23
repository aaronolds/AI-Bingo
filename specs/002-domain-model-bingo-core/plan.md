# Implementation Plan: Domain Model in Bingo.Core

**Branch**: `002-domain-model-bingo-core` | **Date**: 2025-01-23 | **Spec**: specs/002-domain-model-bingo-core/spec.md
**Input**: Feature specification from `/specs/002-domain-model-bingo-core/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

Implement the core bingo domain model in `src/Bingo.Core` as a persistence-agnostic domain layer. The domain model includes GameTemplate, TemplateTile, GameSession, Board, BoardCell, and DrawEvent entities with enforced business invariants. This provides a shared, testable foundation for the API and data layers.

## Technical Context

**Language/Version**: .NET SDK 10 (all projects `net10.0`), C# `latest`  
**Primary Dependencies**: None (domain layer has no external dependencies beyond .NET BCL)  
**Frontend**: N/A (domain layer only)  
**Storage**: N/A (persistence-agnostic; EF Core mappings deferred to Epic 2 / Story 3)  
**Testing**: xUnit (following repo convention from Epic 1), test project: `tests/Bingo.Core.Tests`  
**Target Platform**: .NET 10 class library (platform-agnostic)  
**Project Type**: Single repo (existing `src/` + `tests/` layout)  
**Performance Goals**: N/A (domain model; performance critical path is in API/data layer)  
**Constraints**: Must remain persistence-agnostic; no EF Core, Dapper, or other data access dependencies; must enforce all business invariants at construction time  
**Scale/Scope**: 6 domain entities (GameTemplate, TemplateTile, GameSession, Board, BoardCell, DrawEvent) with unit tests for each

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

**Gates (pre-Phase 0)**

- .NET 10-first: all projects target `net10.0`; repo pins SDK via `global.json`. **PASS** (Bingo.Core will target net10.0)
- Aspire-first orchestration: AppHost + resources; no hand-written Docker Compose. **N/A** (domain layer does not affect orchestration)
- Central package management: `Directory.Packages.props`; no `PackageReference Version=`. **PASS** (no external packages needed; xUnit already managed centrally)
- Solution/layout: single root `Bingo.slnx`; no `.sln`; follow `docs/design.md` layout. **PASS** (Bingo.Core goes in src/, test project in tests/)
- Build/test/CI guardrails: CI runs `dotnet build` + `dotnet test` and fails on `.sln` or `PackageReference Version=`. **PASS** (will add unit tests)

**Waivers**: None.

**Re-check (post-Phase 1 design)**: No changes anticipated; gates remain **PASS**.

## Project Structure

### Documentation (this feature)

```text
specs/002-domain-model-bingo-core/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
src/
├── Bingo.Api/           # (existing)
├── Bingo.Web/           # (existing)
├── Bingo.Core/          # NEW: Domain model project
│   ├── Entities/
│   │   ├── GameTemplate.cs
│   │   ├── TemplateTile.cs
│   │   ├── GameSession.cs
│   │   ├── Board.cs
│   │   ├── BoardCell.cs
│   │   └── DrawEvent.cs
│   ├── Enums/
│   │   └── SessionStatus.cs
│   └── Bingo.Core.csproj
├── Bingo.Data/          # (existing, will reference Core in later epic)
└── Bingo.AppHost/       # (existing)

tests/
├── Bingo.Api.Tests/     # (existing)
└── Bingo.Core.Tests/    # NEW: Domain model unit tests
    ├── GameTemplateTests.cs
    ├── GameSessionTests.cs
    ├── BoardTests.cs
    └── Bingo.Core.Tests.csproj
```

**Structure Decision**: Domain model goes in new `src/Bingo.Core` project, unit tests in `tests/Bingo.Core.Tests`. This follows the existing repo layout and keeps the domain layer isolated from persistence concerns.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| N/A | N/A | N/A |

No violations. This feature adds a new domain project following established patterns.

## Phase 0: Research (Decisions)

Key research areas:

1. **Domain modeling patterns in .NET**: Research best practices for rich domain models in C# (aggregates, value objects, invariant enforcement)
2. **Session state transitions**: Determine the valid state machine for GameSession (Draft → Active → Ended)
3. **Board generation algorithm**: Research bingo board generation patterns (random tile selection, ensure no duplicates)
4. **Validation approach**: Factory methods vs constructors vs separate validator classes

These decisions will be captured in `research.md`.

## Phase 1: Design Outputs

- `data-model.md`: Domain entity definitions, relationships, and business rules
- `contracts/`: N/A for this feature (no API contracts; domain layer only)
- `quickstart.md`: Instructions for building and testing the domain project

## Phase 0: Research (Completed)

All decisions captured in `research.md`. Key outcomes:

1. **Invariant enforcement**: Static factory methods with Result<T> pattern
2. **Aggregates**: GameTemplate and GameSession as roots
3. **Value objects**: Enums for status (Draft/Active/Ended, Unmarked/Marked)
4. **Session state machine**: Strict Draft → Active → Ended transitions
5. **Validation**: Constructor-time validation, no invalid objects possible

## Phase 1: Design (Completed)

All design artifacts generated:

- **data-model.md**: Complete entity definitions with 6 domain entities, relationships, and business rules
- **contracts/**: N/A for domain layer (documented in contracts/README.md)
- **quickstart.md**: Build and test instructions for Bingo.Core project
- **Agent context**: Updated `.github/agents/copilot-instructions.md` with .NET 10 domain layer info

## Constitution Re-check (Post-Phase 1)

**Final Gate Status**:

- .NET 10-first: **PASS** (Bingo.Core targets net10.0)
- Aspire-first orchestration: **N/A** (domain layer does not affect orchestration)
- Central package management: **PASS** (no external packages; xUnit already managed)
- Solution/layout: **PASS** (Bingo.Core in src/, tests in tests/)
- Build/test/CI guardrails: **PASS** (will add comprehensive unit tests)

**Waivers**: None

**Status**: All applicable gates PASS. Ready for Phase 2 (task generation via `/speckit.tasks`).

## Summary

Implementation plan complete for feature 002-domain-model-bingo-core:

- ✅ Technical context filled
- ✅ Constitution gates passed (pre and post design)
- ✅ Phase 0 research completed (research.md)
- ✅ Phase 1 design completed (data-model.md, quickstart.md, contracts/)
- ✅ Agent context updated (copilot-instructions.md)
- ⏳ Phase 2 task generation (deferred to `/speckit.tasks` command)

**Next Steps**:
1. Run `/speckit.tasks` to generate `tasks.md` with actionable implementation tasks
2. Implement tasks: Create Bingo.Core project, entities, tests
3. Verify: Build succeeds, all tests pass, CI green
