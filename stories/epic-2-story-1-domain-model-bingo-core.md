# Epic 2 / Story 1 — Implement domain model in Bingo.Core

## User Story

As a developer,
I want the core bingo domain model implemented in a dedicated domain project,
so that the API and data layer share consistent business rules and types.

## Scope

- Implement the initial domain model in `src/Bingo.Core` for:
  - GameTemplate
  - TemplateTile
  - GameSession
  - Board
  - BoardCell
  - DrawEvent
- Define basic invariants (e.g., required fields, valid ranges, status transitions).
- Keep domain types persistence-agnostic (no EF Core attributes).

## Acceptance Criteria

- [ ] Domain types exist in `Bingo.Core` and compile.
- [ ] Invariants are enforced (constructor/creation methods guard invalid state).
- [ ] `Bingo.Api` can reference `Bingo.Core` without circular dependencies.
- [ ] Unit tests exist in `tests/Bingo.Core.Tests` validating key invariants.

## Implementation Tasks

- [ ] Add domain entities / value objects to `Bingo.Core`.
- [ ] Add an enum for session status (e.g., Draft/Active/Ended) and enforce transitions.
- [ ] Add tests for required-field and range validation.

## Notes / Dependencies

- Builds on Epic 1 (API + Aspire orchestration already running).
- EF Core mappings will be added in Epic 2 / Story 3 (do not add EF references here).
