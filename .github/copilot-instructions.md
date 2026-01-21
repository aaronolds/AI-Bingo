# Copilot instructions (AI-Bingo)

## Tech + repo guardrails

- .NET SDK pinned via `global.json` (10.0.100, roll-forward latest patch)
- All projects target `net10.0` and `LangVersion=latest` (see `Directory.Build.props`)
- Central Package Management is required (`Directory.Packages.props`):
	- Add/update package versions in `Directory.Packages.props`
	- Never put `Version="..."` on `<PackageReference ... />` in `*.csproj`
- Solution file is `.slnx` only (see `Bingo.slnx`); CI guardrails: `eng/ci/guardrails.sh`

## Big picture architecture

- `src/Bingo.AppHost` is the .NET Aspire distributed app entrypoint:
	- Defines Postgres + Redis resources and wires the API (`bingo-api`) in `src/Bingo.AppHost/AppHost.cs`
- `src/Bingo.Api` is an ASP.NET Core Minimal API service:
	- Calls `builder.AddServiceDefaults()` and `app.MapDefaultEndpoints()` (see `src/Bingo.Api/Program.cs`)
	- OpenAPI is enabled via `builder.Services.AddOpenApi()`; dev maps `/openapi`
- `src/Bingo.ServiceDefaults` centralizes cross-cutting concerns (see `src/Bingo.ServiceDefaults/Extensions.cs`):
	- OpenTelemetry (OTLP exporter enabled when `OTEL_EXPORTER_OTLP_ENDPOINT` is set)
	- Service discovery + default HTTP client resilience
	- Dev-only health endpoints: `/health` and `/alive`

## Common dev commands

- Build: `dotnet build`
- Test: `dotnet test` (xUnit + coverlet collector)
- Run locally (recommended): `aspire run --project src/Bingo.AppHost/Bingo.AppHost.csproj`
- Run a single service: `dotnet run --project src/Bingo.Api/Bingo.Api.csproj`

## Conventions when adding new services

- Reference `Bingo.ServiceDefaults` and follow the `AddServiceDefaults` + `MapDefaultEndpoints` pattern from `Bingo.Api`.
- Prefer `IHttpClientFactory`-based clients; defaults include resilience + service discovery from service defaults.

<!-- MANUAL ADDITIONS START -->
- Frontend standard: `Bingo.Web` uses React + Vite (not Vue/Nuxt). Currently `src/Bingo.Web/Program.cs` is a placeholder host.
<!-- MANUAL ADDITIONS END -->
