# Epic 3 / Story 2 — Admin API key authentication

## User Story

As a stream admin,
I want admin endpoints protected by a simple static API key,
so that viewers cannot start/end games or call tiles.

## Scope

- Protect all `/api/admin/*` endpoints behind a static API key.
- Configure key via configuration (e.g., environment variable / appsettings).
- Return clear 401/403 responses.

## Acceptance Criteria

- [ ] Requests to `/api/admin/*` without a valid key are rejected.
- [ ] Requests with a valid key succeed.
- [ ] API key is not hard-coded in source.
- [ ] Minimal tests cover missing/invalid/valid key scenarios.

## Implementation Tasks

- [ ] Define an auth scheme (simple header check) e.g. `X-Admin-Api-Key`.
- [ ] Add middleware/endpoint filter to enforce the key.
- [ ] Add configuration wiring and local dev documentation note (minimal).
- [ ] Add API tests.

## Notes / Dependencies

- Keep this intentionally simple; can be replaced later with Entra ID/OAuth.
