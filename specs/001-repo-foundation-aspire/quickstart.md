# Quickstart: Repo Foundation & Aspire Setup

**Feature**: specs/001-repo-foundation-aspire/spec.md
**Date**: 2025-12-20

## Prerequisites

- Install the .NET SDK version pinned by `global.json`.
- Install the Aspire CLI.
- Have a container runtime available if Aspire-managed resources require it (varies by setup).

## Build

From the repository root:

- `dotnet build`
- `dotnet test`

## Run locally

From the repository root:

- `aspire run --project src/Bingo.AppHost/Bingo.AppHost.csproj`

Notes:
- The exact Aspire CLI verb/options can vary by CLI version; docs should remain minimal.
- The expected result is that the Aspire dashboard starts and shows:
  - `Bingo.Api` running as a service
  - Postgres running as an Aspire-managed resource
  - Redis running as an Aspire-managed resource
