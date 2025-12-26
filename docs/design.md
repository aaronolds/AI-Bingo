Below is the **full, updated design plan** rewritten cleanly so you can copy it directly into a repo, doc, or GitHub discussion.

---

# Aspireify Clone

## Full Architecture and Design Plan (Updated)

## 1. Overview

This project is a functional clone of [https://aspireify.live](https://aspireify.live).
It provides a real time bingo experience for livestream viewers, with an admin interface used during the stream to trigger events.

Primary goals:

* Real time bingo gameplay for anonymous viewers.
* Simple admin control during live shows.
* Clean, modern .NET 10 architecture.
* Aspire-first local development and orchestration.
* Repo structure optimized for GitHub Copilot driven development.

Non-goals:

* No complex authentication for viewers.
* No native mobile app.
* No advanced analytics or monetization features.

Confidence: 9/10
Reference: [https://aspireify.live](https://aspireify.live)

---

## 2. Technology Stack

### Platform

* .NET SDK: **.NET 10**
* Language: C#, `LangVersion=latest`
* Frontend: Vue 3, Vite, TypeScript optional
* Backend: ASP.NET Core Minimal APIs
* Real time: SignalR
* Persistence: PostgreSQL
* Cache and pub or sub: Redis
* Orchestration: .NET Aspire
* Infrastructure as Code: Azure Bicep

Confidence: 9/10
Reference: [https://learn.microsoft.com/en-us/dotnet/aspire/](https://learn.microsoft.com/en-us/dotnet/aspire/)

---

## 3. Repository Structure

```
/
|-- src/
|   |-- Bingo.Api
|   |-- Bingo.Web
|   |-- Bingo.Core
|   |-- Bingo.Data
|   |-- Bingo.AppHost
|
|-- tests/
|   |-- Bingo.Core.Tests
|   |-- Bingo.Api.Tests
|
|-- Directory.Packages.props
|-- Directory.Build.props
|-- global.json
|-- Bingo.slnx
```

Rules:

* Only `.slnx` solution file. No `.sln`.
* All projects target `net10.0`.
* No package versions in `.csproj` files.

Confidence: 8/10
Reference: [https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-sln](https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-sln)

---

## 4. Central Package Management

Central package management is mandatory.

### Root file

`Directory.Packages.props`

### Enabled globally

```xml
<ManagePackageVersionsCentrally>true</ManagePackageVersionsCentrally>
```

### Example packages managed centrally

* Microsoft.AspNetCore.SignalR
* Microsoft.EntityFrameworkCore
* Microsoft.EntityFrameworkCore.Design
* Npgsql.EntityFrameworkCore.PostgreSQL
* StackExchange.Redis
* OpenTelemetry.Extensions.Hosting
* Aspire.Hosting
* Aspire.ServiceDefaults

Acceptance rules:

* No `<PackageReference Version="...">` anywhere.
* CI fails if versions are detected in project files.

Confidence: 9/10
Reference: [https://learn.microsoft.com/en-us/nuget/consume-packages/central-package-management](https://learn.microsoft.com/en-us/nuget/consume-packages/central-package-management)

---

## 5. Aspire Usage Model

Aspire CLI is the only supported way to manage the distributed app.

### Aspire responsibilities

* Create the AppHost project
* Add Postgres and Redis resources
* Wire service references
* Run the distributed app locally
* Open Aspire dashboard

### Forbidden

* Manual docker compose files
* Manual container wiring documentation
* Non-Aspire local orchestration

Local development command example:

```
aspire run
```

Confidence: 7/10
Reference: [https://learn.microsoft.com/en-us/dotnet/aspire/cli/](https://learn.microsoft.com/en-us/dotnet/aspire/cli/)

---

## 6. Logical Components

### Bingo.AppHost

* Aspire entry point
* Registers API, Web, Postgres, Redis
* Defines resource relationships

### Bingo.Api

* ASP.NET Core Minimal APIs
* SignalR hub
* Domain orchestration
* Stateless and horizontally scalable

### Bingo.Web

* Vue 3 SPA
* Static assets served via API or CDN
* SignalR client

### Bingo.Core

* Domain logic
* Board generation
* Bingo rules and validation

### Bingo.Data

* EF Core DbContext
* Entity mappings
* Migrations
* Redis integration

Confidence: 8/10

---

## 7. Domain Model

### GameTemplate

* TemplateId
* Name
* Description

### TemplateTile

* TemplateTileId
* TemplateId
* Text
* Category
* Weight

### GameSession

* SessionId
* TemplateId
* Status
* StartTime
* EndTime

### Board

* BoardId
* SessionId
* ViewerToken
* Seed
* CreatedAt

### BoardCell

* BoardId
* Row
* Column
* TemplateTileId
* IsMarked

### DrawEvent

* DrawEventId
* SessionId
* TemplateTileId
* SequenceNumber
* DrawnAt

Confidence: 8/10

---

## 8. API Design

### Public Endpoints

* `GET /api/game/current`
* `POST /api/boards`
* `GET /api/boards/{id}`
* `GET /api/boards/{id}/export`

### Admin Endpoints

* `POST /api/admin/templates`
* `PUT /api/admin/templates/{id}`
* `POST /api/admin/sessions`
* `POST /api/admin/sessions/{id}/end`
* `POST /api/admin/sessions/{id}/calls`
* `DELETE /api/admin/sessions/{id}/calls/{callId}`

Admin auth:

* Initial version can use static API key.
* Can later evolve to OAuth or Entra ID.

Confidence: 8/10

---

## 9. SignalR Hub

### Hub

`/hubs/bingo`

### Server to Client Events

* sessionStarted
* sessionEnded
* tileCalled
* tileUncalled
* boardUpdated
* announcement

### Client to Server Calls

* JoinSession
* RegisterBoard

Latency target:

* Under 500 ms for live updates.

Confidence: 8/10

---

## 10. Frontend Architecture

### Views

* HomeView
* BoardView
* AdminDashboardView

### State Management

* Pinia or equivalent
* Session state
* Board state
* Called tiles
* Connection status

### Behavior

* Board id stored in local storage
* Auto reconnect to SignalR
* Responsive layout

Confidence: 7/10

---

## 11. Deployment Model

### Local

* Aspire CLI
* Postgres container
* Redis container
* Aspire dashboard

### Cloud

* Azure Container Apps or App Service
* Azure Database for PostgreSQL
* Azure Cache for Redis
* Bicep templates for infra

Confidence: 7/10
Reference: [https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/)

---

## 12. GitHub Epics and Stories

### Epic 0: Repo foundation

* .NET 10 global.json
* .slnx solution
* Central package management
* CI pipeline

### Epic 1: Aspire setup

* AppHost creation
* Postgres resource
* Redis resource
* Local run validation

### Epic 2: Domain and data

* Domain entities
* EF Core mappings
* Migrations
* Seed data

### Epic 3: API

* Public endpoints
* Admin endpoints
* Validation and error handling

### Epic 4: Real time

* SignalR hub
* Client integration
* Event broadcasting

### Epic 5: Frontend

* Viewer UI
* Admin UI
* Export functionality

### Epic 6: Deployment

* Bicep templates
* Environment configuration
* Production readiness

Confidence: 9/10

---

## 13. Acceptance Criteria Summary

* Single Aspire CLI command runs entire app.
* All projects target .NET 10.
* Only `.slnx` solution file exists.
* Central package management enforced.
* Real time updates work under load.
* Repo is Copilot friendly and issue driven.

Confidence: 9/10

---

If you want, next steps I can:

* Convert this directly into GitHub issues as Markdown.
* Produce an initial `Directory.Packages.props`.
* Produce the `Bingo.AppHost` Aspire CLI command sequence.
* Generate a Copilot prompt pack per epic.

Overall confidence: **8.5/10**
