# Epic 2 / Story 3 — Create Bingo.Data (EF Core DbContext)

## User Story

As a developer,
I want a dedicated data access project with EF Core mappings,
so that persistence concerns stay separated from domain logic.

## Scope

- Create `src/Bingo.Data` targeting `net10.0`.
- Add EF Core DbContext for the domain model.
- Configure Npgsql (PostgreSQL) provider.
- Add basic repository-style access patterns (optional) or expose DbContext directly.

## Acceptance Criteria

- [ ] `Bingo.Data` project exists, targets `net10.0`, and builds.
- [ ] EF Core mappings exist for all Epic 2 domain entities.
- [ ] No package versions are specified in any `.csproj` (central package management only).
- [ ] `Bingo.Api` can reference `Bingo.Data` and connect to the Aspire-provisioned Postgres instance.

## Implementation Tasks

- [ ] Create `Bingo.Data` project and add to `Bingo.slnx`.
- [ ] Add EF Core + Npgsql package references (no inline versions).
- [ ] Implement `BingoDbContext` with DbSets.
- [ ] Create mapping configuration (Fluent API) for keys/relationships/indexes.

## Notes / Dependencies

- Depends on Epic 1 / Story 2 (Postgres resource exists in Aspire).
- Keep Redis integration out of this story (see Epic 2 / Story 5).
