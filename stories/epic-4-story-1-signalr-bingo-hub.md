# Epic 4 / Story 1 — Add SignalR Bingo hub

## User Story

As a viewer,
I want to connect to a SignalR hub for the live game,
so that the board updates in real time during the stream.

## Scope

- Add SignalR to `Bingo.Api`.
- Implement hub at `/hubs/bingo`.
- Add basic client methods:
  - `JoinSession`
  - `RegisterBoard`

## Acceptance Criteria

- [ ] The hub is reachable at `/hubs/bingo` when running via `aspire run`.
- [ ] A client can connect and invoke `JoinSession` without errors.
- [ ] Connection + hub are visible/traceable in logs.

## Implementation Tasks

- [ ] Add SignalR service registration.
- [ ] Create `BingoHub` and map it to `/hubs/bingo`.
- [ ] Add minimal hub methods and request validation.
- [ ] Add a basic integration test or manual validation steps.

## Notes / Dependencies

- Depends on Epic 3 endpoints for session/board identity.
- Keep payloads small and stable; prefer DTOs.
