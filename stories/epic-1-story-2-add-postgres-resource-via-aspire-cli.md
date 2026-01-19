# Epic 1 / Story 2 — Add Postgres resource via Aspire CLI

## User Story

As a developer,
I want Postgres provisioned as an Aspire-managed resource,
so that local development uses consistent infrastructure and connection wiring.

## Scope

- Use Aspire CLI to add a Postgres container resource.
- Expose a connection string to dependent services via Aspire conventions.

## Acceptance Criteria

- [x] AppHost defines a Postgres resource managed by Aspire.
- [x] Running the distributed app starts Postgres automatically.
- [x] Connection information is discoverable by services via Aspire wiring (no manual env var docs required beyond “run CLI”).

## Implementation Tasks

- [x] Add Postgres resource using Aspire CLI.
- [x] Configure persistence/volume defaults as appropriate for dev.
- [x] Verify Postgres shows up in the Aspire dashboard.

## Notes / Dependencies

- Depends on Epic 1 / Story 1 (AppHost exists).
- Provider choice impacts EF provider package selection (see Epic 0 / Story 3).
