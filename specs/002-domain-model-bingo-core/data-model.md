# Data Model: Domain Model in Bingo.Core

**Date**: 2025-01-23  
**Feature**: 002-domain-model-bingo-core

## Overview

This document defines the domain entities, value objects, and relationships for the Bingo.Core domain model. The model is persistence-agnostic and follows domain-driven design principles.

## Entities

### 1. GameTemplate (Aggregate Root)

A reusable template that defines the set of tiles available for bingo games.

**Properties**:
- `Id` (Guid): Unique identifier
- `Name` (string): Template name (required, non-empty)
- `Tiles` (IReadOnlyList<TemplateTile>): Collection of tiles in this template (at least 1 required)

**Invariants**:
- Name must not be null or whitespace
- Must have at least one tile
- All tiles must be unique (no duplicate tile IDs)

**Operations**:
- `Create(string name, IEnumerable<TemplateTile> tiles)`: Factory method to create a valid template

**Relationships**:
- Owns: TemplateTile (one-to-many)
- Referenced by: GameSession

---

### 2. TemplateTile (Entity)

An individual tile definition within a game template.

**Properties**:
- `Id` (Guid): Unique identifier
- `Number` (int): Tile number (e.g., 1-75 for traditional bingo)
- `Label` (string): Display label (e.g., "B-12" or "Lucky Star")

**Invariants**:
- Number must be positive
- Label must not be null or whitespace

**Operations**:
- `Create(int number, string label)`: Factory method to create a valid tile

**Relationships**:
- Owned by: GameTemplate
- Referenced by: BoardCell, DrawEvent

---

### 3. GameSession (Aggregate Root)

An active or completed game session based on a specific template.

**Properties**:
- `Id` (Guid): Unique identifier
- `TemplateId` (Guid): Reference to the GameTemplate used
- `Status` (GameSessionStatus): Current status (Draft/Active/Ended)
- `CreatedAt` (DateTime): When the session was created
- `StartedAt` (DateTime?): When the session was started (null if not started)
- `EndedAt` (DateTime?): When the session was ended (null if not ended)

**Invariants**:
- Status transitions must follow the state machine: Draft → Active → Ended
- Cannot transition backwards or skip states
- StartedAt must be set when transitioning to Active
- EndedAt must be set when transitioning to Ended

**Operations**:
- `Create(Guid templateId)`: Factory method to create a new draft session
- `Start()`: Transition from Draft to Active
- `End()`: Transition from Active to Ended

**Relationships**:
- References: GameTemplate
- Owns: Board (one-to-many)
- Owns: DrawEvent (one-to-many)

---

### 4. Board (Entity)

A player's bingo board generated from a game session's template.

**Properties**:
- `Id` (Guid): Unique identifier
- `SessionId` (Guid): Reference to the GameSession
- `PlayerId` (string?): Optional player identifier (null for anonymous players)
- `Cells` (IReadOnlyList<BoardCell>): Collection of cells (exactly 25 for standard 5x5 board)
- `CreatedAt` (DateTime): When the board was generated

**Invariants**:
- Must have exactly 25 cells (5x5 grid)
- All cells must reference valid tiles from the session's template
- Each cell must have unique tile (no duplicate tiles on same board)

**Operations**:
- `Create(Guid sessionId, IEnumerable<TemplateTile> tiles, string? playerId)`: Factory method to create a valid board
- `MarkCell(Guid cellId)`: Mark a cell as called

**Relationships**:
- Owned by: GameSession
- Owns: BoardCell (one-to-many)

---

### 5. BoardCell (Entity)

An individual cell on a bingo board.

**Properties**:
- `Id` (Guid): Unique identifier
- `BoardId` (Guid): Reference to the Board
- `TileId` (Guid): Reference to the TemplateTile
- `Position` (int): Position on the board (0-24 for row-major order)
- `State` (CellState): Marked or Unmarked
- `MarkedAt` (DateTime?): When the cell was marked (null if unmarked)

**Invariants**:
- Position must be 0-24 (inclusive)
- Once marked, cannot be unmarked
- MarkedAt must be set when State is Marked

**Operations**:
- `Create(Guid boardId, Guid tileId, int position)`: Factory method to create an unmarked cell
- `Mark()`: Mark the cell as called (sets State and MarkedAt)

**Relationships**:
- Owned by: Board
- References: TemplateTile

---

### 6. DrawEvent (Entity)

Records when a tile is called during a game session.

**Properties**:
- `Id` (Guid): Unique identifier
- `SessionId` (Guid): Reference to the GameSession
- `TileId` (Guid): Reference to the TemplateTile that was called
- `CalledAt` (DateTime): When the tile was called
- `SequenceNumber` (int): Order in which the tile was called (1, 2, 3, ...)

**Invariants**:
- Session must be in Active status
- Each tile can only be called once per session
- SequenceNumber must be positive and sequential

**Operations**:
- `Create(Guid sessionId, Guid tileId, int sequenceNumber)`: Factory method to record a tile call

**Relationships**:
- Owned by: GameSession
- References: TemplateTile

---

## Value Objects

### GameSessionStatus (Enum)

**Values**:
- `Draft` (0): Session is being prepared, not yet started
- `Active` (1): Session is in progress
- `Ended` (2): Session has concluded

**State Machine**:
```
Draft → Active → Ended
```

---

### CellState (Enum)

**Values**:
- `Unmarked` (0): Cell has not been marked (tile not yet called)
- `Marked` (1): Cell has been marked (tile was called)

**Transitions**:
- `Unmarked → Marked`: Allowed (when tile is called)
- `Marked → Unmarked`: **Not allowed** (one-way transition)

---

## Entity Relationships

```
GameTemplate (1)
  └─> TemplateTile (many)

GameSession (1)
  ├─> GameTemplate (1, reference)
  ├─> Board (many)
  │     └─> BoardCell (25)
  │           └─> TemplateTile (1, reference)
  └─> DrawEvent (many)
        └─> TemplateTile (1, reference)
```

### Aggregate Boundaries

**GameTemplate Aggregate**:
- Root: GameTemplate
- Children: TemplateTile
- Consistency: All tiles must be unique within a template

**GameSession Aggregate**:
- Root: GameSession
- Children: Board, BoardCell (via Board), DrawEvent
- Consistency: Session status transitions, tile call uniqueness, board validity

---

## Domain Rules Summary

### GameTemplate Rules
1. Must have a non-empty name
2. Must have at least one tile
3. All tiles within a template must be unique

### GameSession Rules
1. Follows strict state machine: Draft → Active → Ended
2. Can only call tiles when in Active status
3. Each tile can only be called once per session
4. Timestamps must be set appropriately for state transitions

### Board Rules
1. Must have exactly 25 cells (5x5 grid)
2. All cells must reference tiles from the session's template
3. No duplicate tiles on the same board
4. Cells can be marked but not unmarked

### BoardCell Rules
1. Position must be 0-24
2. Once marked, cannot be unmarked
3. MarkedAt timestamp must be set when marked

### DrawEvent Rules
1. Can only be created for Active sessions
2. Each tile can only appear once per session
3. Sequence numbers must be unique and sequential per session

---

## Validation Summary

All validation is enforced at construction time using static factory methods that return `Result<T>`:

```csharp
// Success case
var result = GameTemplate.Create("Classic Bingo", tiles);
if (result.IsSuccess)
{
    GameTemplate template = result.Value;
    // Use template
}

// Failure case
var result = GameTemplate.Create("", tiles);
if (result.IsFailure)
{
    string errorMessage = result.Error;
    // Handle error
}
```

This ensures **invalid domain objects cannot be constructed**.

---

## Testing Strategy

### Unit Test Coverage

**GameTemplate Tests**:
- ✓ Create with valid name and tiles succeeds
- ✓ Create with empty name fails
- ✓ Create with no tiles fails
- ✓ Create with duplicate tiles fails

**GameSession Tests**:
- ✓ Create creates a Draft session
- ✓ Start transitions Draft → Active
- ✓ End transitions Active → Ended
- ✓ Cannot start non-Draft session
- ✓ Cannot end non-Active session
- ✓ Cannot transition backwards

**Board Tests**:
- ✓ Create with 25 unique tiles succeeds
- ✓ Create with wrong number of tiles fails
- ✓ Create with duplicate tiles fails
- ✓ MarkCell marks the correct cell

**BoardCell Tests**:
- ✓ Create creates Unmarked cell
- ✓ Mark sets State to Marked and sets MarkedAt
- ✓ Cannot unmark a marked cell

**DrawEvent Tests**:
- ✓ Create records tile call with timestamp
- ✓ SequenceNumber is set correctly

**TemplateTile Tests**:
- ✓ Create with valid number and label succeeds
- ✓ Create with invalid number fails
- ✓ Create with empty label fails

---

## Future Considerations

**Not included in this iteration** (deferred to later epics):

1. **Bingo win detection**: Logic to determine if a board has a winning pattern (deferred to Epic 2 / Story 2)
2. **EF Core mappings**: Configuration for persistence (deferred to Epic 2 / Story 3)
3. **Domain events**: Rich event publishing for integration (deferred to Epic 3+)
4. **Board patterns**: Free space, different grid sizes, custom patterns (deferred to future stories)

The current model focuses on core entities and invariants, providing a solid foundation for these future enhancements.
