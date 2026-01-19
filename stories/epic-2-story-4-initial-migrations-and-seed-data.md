# Epic 2 / Story 4 — Initial EF migrations + seed data

## User Story

As a developer,
I want migrations and seed data for a baseline game template,
so that local development has a working game without manual DB setup.

## Scope

- Create initial EF Core migration for the Bingo schema.
- Implement seed data for:
  - at least 1 GameTemplate
  - enough TemplateTiles to generate a board (e.g., 40+)
- Ensure seed runs in development only (or is idempotent).

## Acceptance Criteria

- [ ] `dotnet ef migrations add InitialCreate` (or equivalent) is represented in source control outputs.
- [ ] `aspire run` brings up Postgres and the API can apply migrations on startup (dev-only).
- [ ] Seed data exists and results in at least one usable template.
- [ ] Rerunning the app does not duplicate seed data.

## Implementation Tasks

- [ ] Add EF Core design-time tooling setup (if required).
- [ ] Create the initial migration in `Bingo.Data`.
- [ ] Add dev-time migration apply + seed step in `Bingo.Api` startup.
- [ ] Add a small smoke test that validates the template exists.

## Notes / Dependencies

- Depends on Epic 2 / Story 3 (DbContext exists).
- Seed content can be simple and refined later; focus on repeatability.
