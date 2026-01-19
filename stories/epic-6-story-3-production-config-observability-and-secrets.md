# Epic 6 / Story 3 — Production config, secrets, and observability

## User Story

As a developer,
I want production-ready configuration patterns,
so that deployments are secure, diagnosable, and maintainable.

## Scope

- Configuration:
  - environment-based settings
  - connection strings from managed services
  - admin API key from secrets store
- Observability:
  - OpenTelemetry for logs/traces/metrics
  - Aspire dashboard-friendly defaults locally

## Acceptance Criteria

- [ ] No production secrets are stored in repo.
- [ ] App emits traces/metrics suitable for debugging.
- [ ] Health checks and structured logging are enabled.

## Implementation Tasks

- [ ] Add OpenTelemetry instrumentation to API.
- [ ] Add health endpoints.
- [ ] Document required environment variables and secret handling.

## Notes / Dependencies

- Can be started earlier if needed for debugging; keeping it in Epic 6 keeps scope focused.
