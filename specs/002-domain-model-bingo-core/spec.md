# Feature: Domain Model in Bingo.Core

**Epic**: 2 - Domain and Data  
**Story**: 1 - Implement domain model in Bingo.Core  
**Status**: Planning

## Overview

Implement the core bingo domain model in a dedicated domain project (`src/Bingo.Core`) to provide consistent business rules and types shared across the API and data layer.

## User Story

As a developer,  
I want the core bingo domain model implemented in a dedicated domain project,  
so that the API and data layer share consistent business rules and types.

## Goals

- Create domain entities in `Bingo.Core` for the bingo game domain
- Define business invariants and validation rules
- Keep domain types persistence-agnostic (no EF Core dependencies)
- Ensure the domain model is testable and maintainable

## Domain Entities

The following domain entities need to be implemented:

1. **GameTemplate**: Defines a reusable bingo game template with tiles
2. **TemplateTile**: Individual tiles that can be used in a template
3. **GameSession**: An active game session with specific settings
4. **Board**: A player's bingo board generated from a template
5. **BoardCell**: Individual cells on a board with marked/unmarked state
6. **DrawEvent**: Records when a tile is called during a session

## Business Rules

- **GameTemplate**:
  - Must have a unique name
  - Must have at least one tile
  - Tiles must be unique within a template

- **GameSession**:
  - Must be associated with a valid GameTemplate
  - Has a status: Draft, Active, or Ended
  - Status transitions must be validated:
    - Draft → Active (start game)
    - Active → Ended (end game)
    - Cannot transition back to earlier states

- **Board**:
  - Must be associated with a GameSession
  - Must have the correct number of cells (typically 5x5 = 25)
  - Each cell references a tile from the session's template

- **BoardCell**:
  - Tracks marked/unmarked state
  - Cannot be unmarked once marked (in basic rules)

- **DrawEvent**:
  - Records which tile was called and when
  - Tiles can only be called once per session
  - Must be associated with an active GameSession

## Validation Requirements

- Required fields must be enforced at construction time
- Value ranges must be validated (e.g., board dimensions)
- Status transitions must follow defined rules
- Domain invariants should be impossible to violate

## Testing Requirements

- Unit tests for each entity's construction and validation
- Tests for business rule enforcement
- Tests for status transitions
- Tests for edge cases and error conditions

## Non-Goals

- EF Core mappings (deferred to Epic 2 / Story 3)
- Database persistence logic
- API endpoints (Epic 3)
- UI components (Epic 5)

## Dependencies

- Epic 1 complete (Aspire orchestration and API project structure exists)
- .NET 10 SDK
- xUnit for testing

## Acceptance Criteria

- [ ] Domain types exist in `Bingo.Core` and compile
- [ ] Invariants are enforced (constructor/creation methods guard invalid state)
- [ ] `Bingo.Api` can reference `Bingo.Core` without circular dependencies
- [ ] Unit tests exist in `tests/Bingo.Core.Tests` validating key invariants
- [ ] No EF Core or persistence framework dependencies in `Bingo.Core`
- [ ] All tests pass

## Technical Constraints

- Must use .NET 10
- Must follow repository Central Package Management conventions
- Must not introduce `*.sln` files (use `.slnx` only)
- Domain layer must remain persistence-agnostic
- No external dependencies except base .NET libraries

## Success Metrics

- All unit tests passing
- 100% of business rules enforced in code
- Zero persistence framework references in domain project
- Code builds and passes CI validation
