# Epic 3 / Story 1 — Public game + board endpoints

## User Story

As a viewer,
I want to fetch the current game and create/view my board via public endpoints,
so that I can play anonymously without an account.

## Scope

Implement the public API endpoints:

- `GET /api/game/current`
- `POST /api/boards`
- `GET /api/boards/{id}`

Include basic validation and consistent error responses.

## Acceptance Criteria

- [ ] `GET /api/game/current` returns the active session (or a clear “no active session” result).
- [ ] `POST /api/boards` creates a board for the active session and returns board id + viewer token.
- [ ] `GET /api/boards/{id}` returns the board, including called tiles and marked cells.
- [ ] Endpoints are discoverable in OpenAPI/Swagger (if enabled).
- [ ] API tests exist in `tests/Bingo.Api.Tests` for happy path + basic failure cases.

## Implementation Tasks

- [ ] Add request/response contracts (DTOs) for the endpoints.
- [ ] Implement endpoint handlers using `Bingo.Core` and `Bingo.Data`.
- [ ] Add validation (route ids, missing session, etc.).
- [ ] Add minimal API tests.

## Notes / Dependencies

- Depends on Epic 2 (domain, DbContext, migrations/seed).
- Viewer identity should be anonymous; use a generated viewer token (no auth system).
