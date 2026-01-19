# Epic 5 / Story 2 — Viewer HomeView + BoardView

## User Story

As a viewer,
I want a simple flow to create or resume a board and then play,
so that I can join the game quickly without logging in.

## Scope

- Implement the viewer UI views:
  - HomeView: shows current session state and a “Create board” button
  - BoardView: renders the board grid, called tiles, and win state
- Integrate with the public API endpoints.

## Acceptance Criteria

- [ ] HomeView displays “active session” vs “no active session”.
- [ ] Clicking “Create board” calls `POST /api/boards` and routes to BoardView.
- [ ] BoardView loads board data from `GET /api/boards/{id}`.
- [ ] Marking a cell updates the UI (client-side for v1; server persistence can come later).

## Implementation Tasks

- [ ] Add basic routing (HomeView, BoardView).
- [ ] Add API client helpers.
- [ ] Implement board grid UI with responsive layout.

## Notes / Dependencies

- Real-time updates will be added in Epic 5 / Story 4 after SignalR is ready.
