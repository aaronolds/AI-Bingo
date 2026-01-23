# Research: Domain Model in Bingo.Core

**Date**: 2025-01-23  
**Feature**: 002-domain-model-bingo-core

## Overview

This document captures research decisions for implementing the core bingo domain model in `src/Bingo.Core` following .NET best practices for domain-driven design.

## Research Areas

### 1. Invariant Enforcement Pattern

**Decision**: Use static factory methods with private constructors and Result<T> pattern

**Rationale**:
- Private constructors prevent direct instantiation of invalid objects
- Static factory methods (e.g., `Create()`) enforce business rules before construction
- `Result<T>` pattern provides explicit failure information without exceptions for validation failures
- This pattern is testable and makes invariants explicit in the code

**Alternatives Considered**:
- Public constructors with validation: Can still create invalid objects if caller forgets validation
- Separate validator classes: Adds indirection and doesn't prevent invalid construction
- Constructor exceptions: Makes testing harder and hides validation failures in stack traces

**Example Pattern**:
```csharp
public class GameTemplate
{
    private GameTemplate(Guid id, string name, IReadOnlyList<TemplateTile> tiles)
    {
        Id = id;
        Name = name;
        Tiles = tiles;
    }
    
    public static Result<GameTemplate> Create(string name, IEnumerable<TemplateTile> tiles)
    {
        if (string.IsNullOrWhiteSpace(name))
            return Result.Failure<GameTemplate>("Template name is required");
        
        var tileList = tiles?.ToList() ?? new List<TemplateTile>();
        if (tileList.Count == 0)
            return Result.Failure<GameTemplate>("At least one tile is required");
        
        // Check for duplicate tiles
        if (tileList.DistinctBy(t => t.Id).Count() != tileList.Count)
            return Result.Failure<GameTemplate>("Duplicate tiles are not allowed");
        
        return Result.Success(new GameTemplate(Guid.NewGuid(), name, tileList.AsReadOnly()));
    }
}
```

### 2. Aggregate Roots and Entity Design

**Decision**: Use aggregate roots to enforce consistency boundaries

**Aggregate Roots**:
- **GameTemplate**: Owns and manages TemplateTiles; validates tile uniqueness
- **GameSession**: Owns Boards and DrawEvents; manages status transitions

**Entities** (with identity):
- **Board**: Child of GameSession; owns BoardCells
- **BoardCell**: Child of Board; tracks marked state
- **DrawEvent**: Child of GameSession; records tile calls
- **TemplateTile**: Child of GameTemplate; represents a tile definition

**Rationale**:
- Aggregates enforce internal consistency (e.g., GameSession validates all status transitions)
- Each aggregate has a clear boundary and can be loaded/saved independently
- Child entities are accessed through their aggregate root
- This prevents invalid cross-aggregate references

**Alternatives Considered**:
- Flat entity model with repositories for everything: Harder to enforce invariants across related entities
- Large single aggregate: Would make GameSession too complex and harder to test

### 3. Value Objects vs Entities

**Decision**: Use enums for status values; entities for domain objects with identity

**Value Objects** (immutable, equality by value):
- `GameSessionStatus` enum: Draft, Active, Ended
- `CellState` enum: Unmarked, Marked

**Entities** (mutable, equality by ID):
- All domain objects (GameTemplate, GameSession, Board, BoardCell, TemplateTile, DrawEvent)
- Implement `IEquatable<T>` based on ID comparison

**Rationale**:
- Entities have lifecycle and identity (Guid IDs)
- Status/state values are simple enums with no behavior
- Clear distinction helps with EF Core mapping (deferred to Epic 2/Story 3)

**Alternatives Considered**:
- Making TemplateTile a value object: Rejected because tiles have identity and may need to be referenced independently

### 4. Session State Transitions

**Decision**: Implement strict state machine for GameSession

**Valid Transitions**:
- `Draft → Active`: When session starts (game begins)
- `Active → Ended`: When session ends (game concludes)

**Invalid Transitions**:
- Cannot transition back to earlier states
- Cannot skip states (e.g., Draft → Ended)
- Cannot transition from Ended

**Implementation**:
```csharp
public class GameSession
{
    public GameSessionStatus Status { get; private set; } = GameSessionStatus.Draft;
    
    public Result Start()
    {
        if (Status != GameSessionStatus.Draft)
            return Result.Failure("Can only start a draft session");
        
        Status = GameSessionStatus.Active;
        return Result.Success();
    }
    
    public Result End()
    {
        if (Status != GameSessionStatus.Active)
            return Result.Failure("Can only end an active session");
        
        Status = GameSessionStatus.Ended;
        return Result.Success();
    }
}
```

**Rationale**:
- Makes state transitions explicit and testable
- Prevents invalid game states
- Clear error messages for invalid transitions

**Alternatives Considered**:
- Allowing any transition: Too permissive, allows invalid game states
- Complex state machine with more states: Not needed for MVP (can add Paused, etc. later)

### 5. Board Generation Algorithm

**Decision**: Defer to Board factory method; validate 5x5 = 25 cells

**Approach**:
- Board.Create() takes a collection of 25 TemplateTiles
- Each cell references one tile from the template
- Caller (application layer) is responsible for random selection logic
- Domain layer validates correct count and no null references

**Rationale**:
- Domain layer enforces invariants (correct size, valid references)
- Random selection logic belongs in application/API layer (can vary by game type)
- Keeps domain focused on rules, not algorithms

**Alternatives Considered**:
- Domain generates boards: Couples domain to specific generation algorithm; harder to test
- No validation: Allows invalid board sizes

### 6. Validation Approach

**Decision**: Constructor validation + Result<T> for creation methods

**Pattern**:
- All invariants validated at construction time
- Factory methods return `Result<T>` with explicit error messages
- No separate validator classes
- Properties have private setters or are init-only

**Rationale**:
- Impossible to create invalid domain objects
- Clear failure messages returned to caller
- No need for defensive checks after construction
- Easier to test: just call Create() and check Result

**Alternatives Considered**:
- FluentValidation or similar: Adds external dependency; validation can be skipped
- Property setters with validation: Can't prevent invalid state at construction

### 7. Persistence Agnosticism

**Decision**: No persistence framework dependencies; use read-only collections

**Practices**:
- No `[Key]`, `[Column]`, or other EF Core attributes
- No parameterless constructors (domain objects always constructed with required data)
- Use `IReadOnlyList<T>` for collections
- Private setters on all properties
- No lazy loading or navigation property patterns

**EF Core Compatibility** (deferred to Epic 2/Story 3):
- Will create separate EF Core configuration classes
- Will use shadow properties for foreign keys
- Will map factory methods to internal constructors via reflection if needed

**Rationale**:
- Domain layer remains testable without database
- Can swap persistence frameworks without changing domain
- Follows clean architecture principles

**Alternatives Considered**:
- Adding EF Core attributes: Couples domain to persistence; violates clean architecture
- Parameterless constructors: Allows invalid object construction

## Dependencies

**No external dependencies**: Domain layer uses only .NET BCL types (Guid, DateTime, collections, etc.)

**Testing dependencies**:
- xUnit: Test framework (already in repo from Epic 1)
- No mocking framework needed (domain objects are directly testable)

## Summary

The domain model will use:
1. **Static factory methods** with private constructors for invariant enforcement
2. **Aggregate roots** (GameTemplate, GameSession) for consistency boundaries
3. **Result<T> pattern** for explicit validation failure handling
4. **Enums** for status values (SessionStatus, CellState)
5. **Strict state machine** for session transitions
6. **IReadOnlyList<T>** for collections to prevent external modification
7. **No persistence dependencies** to keep domain agnostic

This design ensures the domain layer is:
- **Testable**: No external dependencies, direct unit testing
- **Maintainable**: Clear invariants, explicit validation
- **Persistence-agnostic**: No EF Core or database coupling
- **Expressive**: Domain language matches business rules
