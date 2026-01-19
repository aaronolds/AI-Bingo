# Epic 3 / Story 3 — Admin template endpoints

## User Story

As a stream admin,
I want to create and update game templates,
so that each show can run with a different tile set.

## Scope

Implement admin endpoints:

- `POST /api/admin/templates`
- `PUT /api/admin/templates/{id}`

Templates include metadata + tiles.

## Acceptance Criteria

- [ ] Creating a template persists a GameTemplate and TemplateTiles.
- [ ] Updating a template updates metadata and tiles safely (no orphaned data).
- [ ] Requests validate required fields and return useful error messages.
- [ ] Endpoints require the admin API key (Epic 3 / Story 2).

## Implementation Tasks

- [ ] Define request DTOs for template create/update (including tile list).
- [ ] Implement handlers using EF Core transactions.
- [ ] Add validation (empty tiles, duplicate tile text, weights).
- [ ] Add API tests for create/update.

## Notes / Dependencies

- Depends on Epic 3 / Story 2 for auth.
- Consider how updates affect existing sessions (initially: prevent updating templates used by active sessions).
