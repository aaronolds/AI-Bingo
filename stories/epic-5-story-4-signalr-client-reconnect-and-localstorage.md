# Epic 5 / Story 4 — SignalR client + reconnect + local storage

## User Story

As a viewer,
I want my client to auto-reconnect and remember my board id,
so that refreshes and brief disconnects don’t interrupt gameplay.

## Scope

- Add SignalR client integration to the web app.
- Store the viewer’s board id/token in local storage.
- On load:
  - restore board
  - connect to hub
  - join session
  - receive state snapshot + incremental events

## Acceptance Criteria

- [ ] Board id/token persist in local storage and restore the user’s board.
- [ ] SignalR reconnects automatically after a dropped connection.
- [ ] Real-time events update the UI within 500ms in local testing.

## Implementation Tasks

- [ ] Add SignalR client package and connection management.
- [ ] Implement event handlers for session/tile events.
- [ ] Add local storage persistence for board identity.

## Notes / Dependencies

- Depends on Epic 4 (SignalR hub + events + snapshot).
