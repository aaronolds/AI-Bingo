# Epic 6 / Story 1 — Bicep infrastructure skeleton

## User Story

As a developer,
I want an initial Azure Bicep infrastructure skeleton,
so that we can deploy the app consistently to cloud environments.

## Scope

- Add an `infra/` folder with Bicep templates for:
  - Azure Database for PostgreSQL
  - Azure Cache for Redis
  - Hosting target (Container Apps or App Service — pick one for v1)
- Include parameters for environment naming and SKU tiers.

## Acceptance Criteria

- [ ] `infra/` exists with a clear entrypoint Bicep (e.g., `main.bicep`).
- [ ] Templates compile via `az bicep build`.
- [ ] Parameters support dev/prod environments.

## Implementation Tasks

- [ ] Choose initial hosting target (recommend: Azure Container Apps).
- [ ] Create Bicep modules/resources.
- [ ] Add minimal documentation on how to deploy (commands only).

## Notes / Dependencies

- Keep secrets out of source; use Key Vault or ACA secrets.
