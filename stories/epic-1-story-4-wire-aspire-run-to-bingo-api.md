# Epic 1 / Story 4 — Wire Aspire run to Bingo.Api

## User Story
As a developer,
I want the distributed app to start the API via Aspire,
so that “run locally” is a single Aspire CLI command that launches the API and its dependencies.

## Scope
- Create `src/Bingo.Api` (if not already present) targeting `net10.0`.
- Add the API project to the AppHost so it starts with the distributed app.
- Ensure Postgres/Redis dependencies can be consumed once used.

## Acceptance Criteria
- [ ] The distributed app starts Bingo.Api and it is reachable locally.
- [ ] A single Aspire CLI command starts the system (API + resources).
- [ ] No manual run steps beyond “install CLI, run CLI” are required.

## Implementation Tasks
- [ ] Scaffold `src/Bingo.Api` targeting `net10.0`.
- [ ] Add Bingo.Api to the AppHost.
- [ ] Verify the API appears as a running service in the Aspire dashboard.

## Notes / Dependencies
- Depends on Epic 1 / Story 1 (AppHost exists).
- Postgres/Redis wiring may be validated later once the API actually consumes them.
