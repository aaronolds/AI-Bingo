# AI-Bingo

An AI-powered Bingo game application (work-in-progress), built as a .NET Aspire distributed app.

Today, this repo focuses on a solid foundation: pinned SDK, centralized packages, an Aspire AppHost, and a minimal API wired into Aspire.

## What's in the box

- **.NET 10** (pinned via `global.json`)
- **.NET Aspire** AppHost orchestration (`src/Bingo.AppHost`)
- **ASP.NET Core Minimal API** service (`src/Bingo.Api`)
	- OpenAPI enabled in development (`/openapi`)
	- Dev-only health endpoints (`/health`, `/alive`)
- **Service defaults** (`src/Bingo.ServiceDefaults`) for:
	- OpenTelemetry (OTLP exporter enabled when configured)
	- Service discovery + default HTTP client resilience
- Aspire-managed **Postgres** and **Redis** resources (defined in AppHost)

> Note: `src/Bingo.Web` currently contains a placeholder host. The React + Vite client work is tracked in `stories/`.

## Repo layout

- `src/Bingo.AppHost`: Aspire distributed app entry point (wires API + Postgres + Redis)
- `src/Bingo.Api`: Minimal API service (currently includes a sample `/weatherforecast` endpoint)
- `src/Bingo.ServiceDefaults`: Shared defaults (health checks, OpenTelemetry, discovery, resilience)
- `src/Bingo.Core`: Domain/core logic (evolves as game features land)
- `src/Bingo.Web`: Placeholder web host (frontend scaffolding is planned)
- `tests/*`: xUnit test projects
- `stories/*`: Incremental implementation stories
- `specs/*`: Specs, plans, and checklists

## Getting started

### Prerequisites

- Install the .NET SDK version pinned by `global.json`.
- Install the Aspire CLI.
- Have a container runtime available (Aspire-managed Postgres/Redis typically run as containers).

### Build

```bash
dotnet build
```

### Test

```bash
dotnet test
```

### Run locally (recommended: Aspire)

From the repo root:

```bash
aspire run --project src/Bingo.AppHost/Bingo.AppHost.csproj
```

Expected result:

- Aspire dashboard starts
- `bingo-api` service is running
- `postgres` and `redis` resources are provisioned and running

### Run a single service (API only)

```bash
dotnet run --project src/Bingo.Api/Bingo.Api.csproj
```

## Useful dev endpoints

When running `Bingo.Api` in **Development**:

- OpenAPI: `/openapi`
- Health (ready): `/health`
- Alive: `/alive`

The API also exposes a sample endpoint:

- `GET /weatherforecast`

## Observability configuration

`Bingo.ServiceDefaults` enables OpenTelemetry instrumentation by default.

- To export to an OTLP collector, set `OTEL_EXPORTER_OTLP_ENDPOINT` in your environment (non-empty value enables the OTLP exporter).

## Repo guardrails (CI)

CI enforces:

- No `*.sln` files (use `Bingo.slnx` only)
- Central Package Management (no `<PackageReference ... Version="..." />` in `*.csproj`)
- `dotnet build` and `dotnet test`

See `eng/ci/guardrails.sh` for the exact checks.
