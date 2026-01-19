# Epic 3 / Story 5 — Board export endpoint

## User Story

As a viewer,
I want to export my board,
so that I can share it or capture it for offline viewing.

## Scope

Implement:

- `GET /api/boards/{id}/export`

Export format can start as JSON (or a simple image/PDF later).

## Acceptance Criteria

- [ ] Export endpoint returns a stable representation of the board (cells + marks + template name).
- [ ] Export works for anonymous viewers (no auth), but uses viewer token if needed.
- [ ] Export returns appropriate status codes for missing board / invalid token.

## Implementation Tasks

- [ ] Decide an initial export format (JSON recommended for v1).
- [ ] Implement handler and DTOs.
- [ ] Add tests for export output shape and basic validation.

## Notes / Dependencies

- Can be expanded later to produce a shareable image.
