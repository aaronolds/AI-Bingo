# Epic 2 / Story 5 — Redis integration for lightweight state

## User Story

As a developer,
I want a minimal Redis integration layer,
so that we can cache “current session” and/or broadcast lightweight state updates.

## Scope

- Add a small Redis abstraction in `Bingo.Data` (or a dedicated `Bingo.Infrastructure` later).
- Store/retrieve:
  - current active session id
  - set/list of called tiles for a session
- Keep it simple and scoped to what the API needs.

## Acceptance Criteria

- [ ] `Bingo.Api` can read/write a “current session” marker in Redis.
- [ ] Called tiles can be stored and read back consistently.
- [ ] Works against the Aspire-provisioned Redis instance.

## Implementation Tasks

- [ ] Add StackExchange.Redis package reference (central versioning).
- [ ] Add a small service (e.g., `ISessionStateStore`) and implementation.
- [ ] Wire Redis connection string from Aspire configuration.
- [ ] Add a basic integration test or local validation steps.

## Notes / Dependencies

- Depends on Epic 1 / Story 3 (Redis resource exists in Aspire).
- Prefer small, testable methods; avoid over-abstracting early.
