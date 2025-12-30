# Epic 0 / Story 1 — Pin .NET 10 SDK

## User Story
As a developer,
I want the repository to pin a specific .NET 10 SDK version,
so that builds are repeatable across machines and CI.

## Scope
- Add `global.json` at repo root pointing to a chosen .NET 10 SDK version.
- Ensure the pinned SDK is compatible with the team’s environments and CI runners.

## Acceptance Criteria
- [ ] `global.json` exists at repo root and pins a .NET 10 SDK version.
- [ ] Running `dotnet --version` in the repo uses the pinned SDK version (when installed).
- [ ] `dotnet build` succeeds using the pinned SDK version on a clean machine.
- [ ] Documentation (README) states the single expected local install step: install the pinned .NET SDK.

## Implementation Tasks
- [ ] Choose the .NET 10 SDK version to pin (e.g., `10.0.x`).
- [ ] Create `global.json` with the pinned SDK version.
- [ ] Validate local build with the pinned SDK.
- [ ] Update README with the pinned SDK requirement (no extra manual Aspire steps).

## Notes / Dependencies
- Depends on the availability of the selected .NET 10 SDK on all target dev machines and CI.
- If multiple SDKs are installed, `global.json` should ensure selection consistency.
