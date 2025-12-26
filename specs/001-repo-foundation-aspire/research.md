# Research: Repo Foundation & Aspire Setup

**Feature**: specs/001-repo-foundation-aspire/spec.md
**Date**: 2025-12-20

This document records the key technical decisions required by the plan, along with the
rationale and alternatives considered.

## Decision 1: .NET SDK pinning strategy (`global.json`)

**Decision**: Pin the repository to a specific .NET 10 SDK version via `global.json`, and use
a roll-forward policy that prefers patch updates within the chosen feature band.

**Rationale**:
- The constitution and design require repeatable builds and consistent SDK selection.
- Pinning avoids “works on my machine” drift across developer machines and CI.
- Allowing patch roll-forward reduces friction when only patch updates are installed.

**Alternatives considered**:
- No pinning (reject: violates constitution + design acceptance criteria).
- Pin to a floating `10.0.x` (reject: `global.json` requires an explicit version; also less reproducible).

## Decision 2: Aspire CLI usage and version pinning

**Decision**: Use Aspire CLI to scaffold the AppHost and add resources (Postgres/Redis). Do
not hard-pin the Aspire CLI as a dotnet tool initially unless instability/compatibility issues
are observed; keep the option open to add `/.config/dotnet-tools.json` later.

**Rationale**:
- The design explicitly calls for CLI-driven Aspire workflows.
- CLI verbs can change across versions; pinning can improve reproducibility, but adds another
  moving part to manage.
- Starting unpinned reduces friction while the repo is still bootstrapping.

**Alternatives considered**:
- Immediately pin Aspire CLI as a repo-local tool (reject for now: additional setup and ongoing
  maintenance; can be revisited if onboarding friction or CI drift appears).
- Avoid CLI and run via `dotnet run` only (reject: conflicts with design story emphasis on CLI workflows).

## Decision 3: Single-command local distributed run

**Decision**: Document exactly one “run locally” command that uses the Aspire CLI. Because
CLI verbs vary by version, the repo should (a) keep docs minimal and (b) verify the command
in CI or as part of the baseline validation once the CLI version is effectively chosen.

**Rationale**:
- Constitution + design require “install CLI, run CLI” and discourage multi-step docs.
- A single command is the UX contract; the precise verb/flags are an implementation detail
  that must be validated against the installed CLI.

**Alternatives considered**:
- Provide multiple commands for different CLI versions (reject: violates minimal docs requirement).
- Require developers to discover the command via `aspire --help` (reject: weak onboarding; still
  acceptable as a fallback note, but not as the primary instruction).

## Decision 4: CI guardrails implementation approach

**Decision**: Add CI checks that fail fast when either (a) any `.sln` file exists or (b) any
project contains a `PackageReference` with a `Version=` attribute. Prefer simple, explicit
shell checks over complex tooling.

**Rationale**:
- This directly enforces the constitution and stories.
- Simple checks are easy to understand and hard to break.

**Alternatives considered**:
- Custom analyzers or MSBuild tasks (reject: heavier weight than needed for foundation phase).
- Relying on convention alone (reject: drift risk is high).
