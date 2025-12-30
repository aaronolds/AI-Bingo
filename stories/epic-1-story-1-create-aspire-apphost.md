# Epic 1 / Story 1 — Create Aspire AppHost via CLI

## User Story
As a developer,
I want an Aspire AppHost project created via the Aspire CLI,
so that local orchestration is standardized and doesn’t rely on hand-written docker compose.

## Scope
- Use Aspire CLI to scaffold `src/Bingo.AppHost`.
- Wire up Aspire service defaults as supported by the installed CLI version.
- Keep repo docs minimal: “install CLI, run CLI”.

## Acceptance Criteria
- [ ] `src/Bingo.AppHost` exists and builds.
- [ ] The distributed app can be started using a single Aspire CLI command.
- [ ] README contains only minimal Aspire guidance:
  - install Aspire CLI
  - run the single command to start locally
- [ ] No hand-written docker compose files are added.

## Implementation Tasks
- [ ] Determine required Aspire CLI version (or compatible range) for .NET 10.
- [ ] Scaffold AppHost via Aspire CLI.
- [ ] Add/verify Aspire service defaults integration.
- [ ] Verify local run starts the Aspire dashboard.

## Notes / Dependencies
- CLI verbs/options vary by Aspire CLI version; use official docs for the installed version.
- May depend on Story 1 (pinned SDK) if CLI needs a specific SDK.
