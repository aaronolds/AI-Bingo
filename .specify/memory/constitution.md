<!--
Sync Impact Report

- Version change: N/A (template) -> 0.1.0
- Modified principles: Template placeholders -> repo-specific principles
- Added sections: Technical Standards, Development Workflow
- Removed sections: None
- Templates requiring updates:
	- UPDATED: .specify/templates/plan-template.md
	- OK (no change needed): .specify/templates/spec-template.md
	- OK (no change needed): .specify/templates/tasks-template.md
	- OK (no change needed): .specify/templates/checklist-template.md
	- OK (no change needed): .specify/templates/agent-file-template.md
- Follow-up TODOs: None
-->

# AI-Bingo Constitution

## Core Principles

### I. .NET 10-First (Pinned SDK)

All production projects MUST target `net10.0`, and the repository MUST pin the
.NET SDK via `global.json`. Any change that requires a different SDK version MUST
update `global.json` and keep CI/build instructions consistent.

### II. Aspire-First Local Orchestration (CLI Driven)

Local distributed runs MUST be orchestrated via .NET Aspire (AppHost + resources).
The repo MUST NOT rely on hand-written Docker Compose for development orchestration.
Documentation MUST keep local run steps minimal: install Aspire CLI, run the single
Aspire command.

### III. Central Package Management (Single Source of Truth)

Package versions MUST be defined centrally in `Directory.Packages.props`.
Projects MUST set `ManagePackageVersionsCentrally=true`, and the repository MUST
NOT contain `<PackageReference ... Version="..." />` in any project file.

### IV. Solution & Layout Conventions

The repository MUST have a single root solution file named `Bingo.slnx`.
Legacy `.sln` files MUST NOT be committed. New projects MUST follow the agreed
layout in `docs/design.md` (e.g., `src/Bingo.Api`, `src/Bingo.Web`, `src/Bingo.AppHost`,
andf `tests/`).

### V. Build/Test/CI Guardrails

Every change MUST keep `dotnet build` green. CI MUST run `dotnet build` and
`dotnet test` (or maintain placeholder test projects until real tests exist).
CI MUST fail if:

- Any `.sln` file exists in the repo.
- Any `PackageReference` specifies a `Version=` attribute.

## Technical Standards

- **Target framework**: `net10.0` for all projects unless explicitly justified.
- **Language version**: Prefer C# `latest` unless a fixed version is required for tooling.
- **Frontend**: `Bingo.Web` MUST use React + Vite. Vue/Nuxt MUST NOT be introduced.
- **Aspire resources**: Postgres/Redis (and future infra) MUST be declared in the AppHost
 and wired via Aspire conventions rather than manual environment-variable documentation.
- **Docs policy**: Keep repository docs focused on intent and one-command local run;
 avoid duplicating Aspire CLI steps that drift across CLI versions.
- **Source of truth**: `docs/design.md` defines platform and layout expectations.

## Development Workflow

- **Story-driven delivery**: Use `stories/` as the canonical backlog format; keep acceptance
 criteria explicit and testable.
- **PR quality bar**: PRs MUST demonstrate compliance with this constitution and keep CI green.
- **Minimal run instructions**: PRs MUST NOT add hand-maintained multi-step local run docs; prefer
 a single Aspire CLI invocation.
- **Changes with waivers**: If a change must violate a principle temporarily, it MUST include a
 clearly scoped waiver and a follow-up issue/story to remove the waiver.

## Governance
<!-- Example: Constitution supersedes all other practices; Amendments require documentation, approval, migration plan -->

This constitution supersedes other project guidance when conflicts arise.

Amendments:

- Any change to this document MUST include a short rationale in the PR description.
- If an amendment introduces breaking governance changes (removes or redefines a principle),
 it MUST include a migration plan (what changes, how to adapt, and by when).

Versioning:

- **MAJOR**: Backward-incompatible governance changes (principle removals or redefinitions).
- **MINOR**: New principle/section added, or materially expanded guidance.
- **PATCH**: Clarifications, wording improvements, typo fixes, non-semantic refinements.

Compliance:

- Reviewers MUST explicitly consider these principles during PR review.
- `docs/design.md` is the supporting technical reference; stories in `stories/` are the
 supporting delivery reference.

**Version**: 0.2.0 | **Ratified**: 2025-12-20 | **Last Amended**: 2026-01-18
