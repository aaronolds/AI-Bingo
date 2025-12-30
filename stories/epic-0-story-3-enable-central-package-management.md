# Epic 0 / Story 3 — Enable Central Package Management

## User Story
As a developer,
I want package versions defined centrally,
so that dependencies are consistent and easy to manage across projects.

## Scope
- Add `Directory.Packages.props` at repo root.
- Configure projects for central package management.
- Remove `Version="..."` from all `<PackageReference />` entries.

## Acceptance Criteria
- [ ] `Directory.Packages.props` exists at repo root.
- [ ] All projects set `ManagePackageVersionsCentrally=true`.
- [ ] No `<PackageReference Include="..." Version="...">` appears anywhere in the repository.
- [ ] `dotnet restore` and `dotnet build` succeed.

## Implementation Tasks
- [ ] Create `Directory.Packages.props` and define initial package version set:
  - `Microsoft.AspNetCore.SignalR`
  - `Microsoft.EntityFrameworkCore.*`
  - `Npgsql.EntityFrameworkCore.PostgreSQL` (or SQL Server provider)
  - `StackExchange.Redis`
  - `OpenTelemetry.*`
  - Aspire packages (service defaults, hosting, etc.)
- [ ] Update all `.csproj` files:
  - add `ManagePackageVersionsCentrally=true`
  - remove package version attributes
- [ ] Add a quick validation step (script/CI) to fail builds if `Version=` appears in any `PackageReference`.

## Notes / Dependencies
- Package choices may depend on whether Postgres vs SQL Server is selected.
- Keep the list minimal at first; expand as projects are introduced.
