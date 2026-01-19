# Epic 6 / Story 2 — Deploy to Azure Container Apps

## User Story

As a developer,
I want the app deployed to Azure Container Apps,
so that the system can run in production-like hosting with managed scaling.

## Scope

- Build/publish containers for API and Web (or a single combined service for v1).
- Deploy to ACA using the Bicep infrastructure from Epic 6 / Story 1.
- Configure environment variables for DB/Redis and admin key.

## Acceptance Criteria

- [ ] API endpoint is reachable publicly.
- [ ] SignalR works in the deployed environment.
- [ ] Postgres + Redis are reachable from the container apps.

## Implementation Tasks

- [ ] Add container build/publish pipeline (local steps or CI).
- [ ] Add ACA deployment configuration.
- [ ] Validate end-to-end flow: create session → create board → tile calls update clients.

## Notes / Dependencies

- Depends on Epic 6 / Story 1.
- SignalR may require sticky sessions depending on scale-out strategy; document the chosen approach.
