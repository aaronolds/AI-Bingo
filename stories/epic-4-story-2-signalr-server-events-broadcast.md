# Epic 4 / Story 2 — Broadcast server events over SignalR

## User Story

As a viewer,
I want tile calls and session lifecycle events pushed to my client instantly,
so that my board stays in sync with the show.

## Scope

Broadcast these server-to-client events:

- `sessionStarted`
- `sessionEnded`
- `tileCalled`
- `tileUncalled`
- `boardUpdated`
- `announcement`

## Acceptance Criteria

- [ ] When an admin starts a session, connected clients receive `sessionStarted`.
- [ ] When an admin ends a session, connected clients receive `sessionEnded`.
- [ ] Calling/uncalling tiles emits the corresponding events in order.
- [ ] Events are scoped to a session (clients in other sessions don’t receive them).

## Implementation Tasks

- [ ] Create a hub event contract (DTOs) for each event.
- [ ] Emit events from the admin API handlers.
- [ ] Use SignalR groups per session id.
- [ ] Add tests (or at least deterministic manual verification steps) for broadcasts.

## Notes / Dependencies

- Depends on Epic 3 / Story 4 for session + call endpoints.
- Initial implementation can broadcast to all session clients; per-board targeting can come later.
