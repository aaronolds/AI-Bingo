# Epic 1 / Story 3 — Add Redis resource via Aspire CLI

## User Story
As a developer,
I want Redis provisioned as an Aspire-managed resource,
so that caching/backplane scenarios work consistently in local orchestration.

## Scope
- Use Aspire CLI to add a Redis container resource.
- Make it available for services via Aspire wiring.

## Acceptance Criteria
- [ ] AppHost defines a Redis resource managed by Aspire.
- [ ] Running the distributed app starts Redis automatically.
- [ ] Redis is visible in the Aspire dashboard.

## Implementation Tasks
- [ ] Add Redis resource using Aspire CLI.
- [ ] Configure basic dev defaults (ports, persistence policy if needed).
- [ ] Verify connectivity from a sample consumer (optional if consumer not yet exists).

## Notes / Dependencies
- Depends on Epic 1 / Story 1 (AppHost exists).
- If SignalR backplane is planned, this resource will be used later.
