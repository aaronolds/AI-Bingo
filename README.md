# AI-Bingo

An AI-powered Bingo game application.

## Getting Started

### Prerequisites

- .NET SDK 10 (pinned via `global.json`)
- Aspire CLI

### Build

`dotnet build`

### Test

`dotnet test`

### Run locally (Aspire)

`aspire run --project src/Bingo.AppHost/Bingo.AppHost.csproj`

### CI

CI enforces:

- No `*.sln` files (use `.slnx` only)
- No `PackageReference` entries with `Version=` (Central Package Management)
- `dotnet build` and `dotnet test`
