# Epic 5 / Story 3 — AdminDashboardView

## User Story

As a stream admin,
I want a basic admin dashboard in the web UI,
so that I can start/end sessions and call tiles during the show.

## Scope

- Implement AdminDashboardView:
  - start session (choose template)
  - end session
  - call tile
  - uncall tile
- Use the admin API key (local dev only for v1).

## Acceptance Criteria

- [ ] AdminDashboardView can start a session via `POST /api/admin/sessions`.
- [ ] AdminDashboardView can end a session.
- [ ] AdminDashboardView can call/uncall tiles.
- [ ] Admin calls require the configured admin API key.

## Implementation Tasks

- [ ] Add admin API client that sends `X-Admin-Api-Key`.
- [ ] Build simple forms/buttons for session and calls.
- [ ] Show current called tiles list.

## Notes / Dependencies

- Depends on Epic 3 / Stories 2–4.
- Keep admin UX minimal but reliable (big buttons, low friction).
