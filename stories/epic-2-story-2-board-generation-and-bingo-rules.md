# Epic 2 / Story 2 — Board generation + bingo rules

## User Story

As a viewer,
I want my bingo board generated deterministically from a seed,
so that reconnects and exports can reproduce the same board reliably.

## Scope

- Implement a board generation service in `Bingo.Core`:
  - Input: template tiles + seed
  - Output: 5x5 board cells (with a center “free” cell if desired)
- Implement bingo rule evaluation:
  - Marking behavior
  - Winning detection (rows/columns/diagonals)
- Keep the algorithm deterministic and testable.

## Acceptance Criteria

- [ ] Given the same seed + template tiles, generation produces the same board.
- [ ] Different seeds produce different boards (statistically, across multiple tests).
- [ ] Bingo detection correctly identifies wins for row/column/diagonal.
- [ ] Unit tests cover deterministic generation and win detection.

## Implementation Tasks

- [ ] Create `BoardGenerator` (or equivalent) in `Bingo.Core`.
- [ ] Create `BingoRules` (or equivalent) in `Bingo.Core`.
- [ ] Add unit tests for:
  - Deterministic output
  - No duplicate tiles on a board
  - Win detection

## Notes / Dependencies

- Coordinate with Epic 2 / Story 1 for final entity shapes.
- The API will use this to create boards in Epic 3 / Story 1.
