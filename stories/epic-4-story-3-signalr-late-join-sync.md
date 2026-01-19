# Epic 4 / Story 3 — Late join sync (state snapshot)

## User Story

As a viewer,
I want to join late (or reconnect) and still get the current game state,
so that I don’t miss tile calls if my connection drops.

## Scope

- On `JoinSession`, send a snapshot of current state:
  - session info
  - called tiles (DrawEvents)
  - optional announcement
- Ensure state comes from a canonical store (DB and/or Redis).

## Acceptance Criteria

- [ ] A client connecting after several tile calls receives the full called-tile list.
- [ ] Reconnecting does not duplicate calls or corrupt client state.
- [ ] Snapshot shape is versioned/stable.

## Implementation Tasks

- [ ] Implement a `GetSessionSnapshot` query in the API/data layer.
- [ ] Return snapshot from `JoinSession` (or via a separate hub method).
- [ ] Add tests for snapshot completeness.

## Notes / Dependencies

- Redis can be used as an optimization, but DB must remain the source of truth.
