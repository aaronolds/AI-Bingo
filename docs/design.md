# Bingo Design

## Platform
 • .NET SDK: target .NET 10 for all projects (API, domain, data, tests, Aspire host).
 • C#: latest supported by .NET 10 (set LangVersion to latest unless you need fixed).
 • Containers: dev orchestration via Aspire (no hand-written docker compose).

## Solution and Repo Layout
 • Solution file: use .slnx instead of .sln.
 • Suggested layout:
 • /src/Bingo.Api
 • /src/Bingo.Web
 • /src/Bingo.Core
 • /src/Bingo.Data
 • /src/Bingo.AppHost (Aspire app host)
 • /tests/Bingo.*.Tests
 • /Directory.Packages.props (central package management)
 • /global.json (pins SDK version)
 • /.config/dotnet-tools.json (optional, if pinning aspire CLI tool)

## Central Package Management
 • Use Directory.Packages.props at repo root.
 • All projects:
 • ManagePackageVersionsCentrally=true
 • Remove version attributes from <PackageReference /> entries.
 • Keep package versions in one place:
 • Microsoft.AspNetCore.SignalR
 • Microsoft.EntityFrameworkCore.*
 • Npgsql.EntityFrameworkCore.PostgreSQL (or SQL Server provider)
 • StackExchange.Redis
 • OpenTelemetry.*
 • Aspire packages (hosting, service defaults, etc)

## Aspire Workflow
 • Use Aspire CLI for:
 • scaffolding new Aspire app host
 • adding resources (Postgres, Redis)
 • running the distributed app locally
 • generating deployment assets (if supported by the CLI version you choose)
 • Rule: no manual “Aspire steps” documented in readme beyond “install CLI, run CLI”.

---

## Updated Epics and Stories

### Epic 0: Repo Foundation (dotnet 10, slnx, central packages)

#### Story 1: Pin .NET 10 SDK
 • Add global.json pointing to the chosen .NET 10 SDK version.

#### Story 2: Create Solution in .slnx FgetFramework=net10.0 defaults where appropriate.
 2. Story: Create solution in .slnx format

#### Story 3 root solution file Bingo.slnx.
 • Add all projects to .slnx (no .sln committed).
 3. Story: Enable Central Package Management

#### Story 4: Baseline Build and Test P initial package list.
 • Update all csproj files to remove package versions.
 • Add CI step to fail if package versions appear in csproj (simple grep).
**Confidence: 9/10**

---

### Epic 1: Aspire-First Distributed App Setup (CLI D

⸻

Epic 1: Aspire-first distributed app setup (CLI driven)

#### Story 2: Add Postgres Rire app host using Aspire CLI
 • Use CLI to create Bingo.AppHost and wire service defaults.

#### Story 3: Add Redis Rd path to run locally.
 2. Story: Add Postgres resource via Aspire CLI
 • Add Postgres container resource.

#### Story 4: Aspire Run Pring to Bingo.Api.
 3. Story: Add Redis resource via Aspire CLI
 • Add Redis container resource.
**Confidence: 7/10**

(Exact CLI verbs vary by Aspire CLI version, so we will follow the official docs for the installed version.)

---

### Epic 2: Services and Web App (Unchanged Functional S
(Exact CLI verbs vary by Aspire CLI version, so we will follow the official docs for the installed version.)

⸻

Epic 2: Services and web app (unchanged functional scope)

Keep the same epics from before (domain/data, API, SignalR, web UI, admin UI, deployment), with one global rule:
**Confidence: 8/10**

---
⸻

Repo-level acceptance criteria
 • dotnet --version aligns with global.json pinned SDK.
 • dotnet build succeeds on clean machine.
 • No <PackageReference Include="..." Version="..."> exists anywhere.
 • Only Bingo.slnx exists (no .sln).
 • “Run locally” is a single Aspire CLI command and it launches:
 • API
---

## External R
 • Aspire dashboard

⸻

External references
 • .NET central package management overview: <https://learn.microsoft.com/en-us/nuget/consume-packages/central-package-management>
 • .NET solution filter and solution formats (Microsoft docs hub): <https://learn.microsoft.com/en-us/dotnet/core/tools/>
 • .NET Aspire docs (entry point): <https://learn.microsoft.com/en-us/dotnet/aspire/>
