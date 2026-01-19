# Epic 2+ — Placeholder (superseded)

## Summary

This file was the original placeholder for the build-out epics.
It is now superseded by authored story files for Epic 2–6.

## Global Rule

Use the official Aspire CLI + docs for orchestration steps; keep repo docs limited to “install CLI, run CLI”.

## Authored Stories

### Epic 2: Domain and data

- Epic 2 / Story 1 — Implement domain model in Bingo.Core
- Epic 2 / Story 2 — Board generation + bingo rules
- Epic 2 / Story 3 — Create Bingo.Data (EF Core DbContext)
- Epic 2 / Story 4 — Initial EF migrations + seed data
- Epic 2 / Story 5 — Redis integration for lightweight state

### Epic 3: API

- Epic 3 / Story 1 — Public game + board endpoints
- Epic 3 / Story 2 — Admin API key authentication
- Epic 3 / Story 3 — Admin template endpoints
- Epic 3 / Story 4 — Admin sessions + tile call endpoints
- Epic 3 / Story 5 — Board export endpoint

### Epic 4: Real time

- Epic 4 / Story 1 — Add SignalR Bingo hub
- Epic 4 / Story 2 — Broadcast server events over SignalR
- Epic 4 / Story 3 — Late join sync (state snapshot)

### Epic 5: Frontend

- Epic 5 / Story 1 — Scaffold React + Vite client app
- Epic 5 / Story 2 — Viewer HomeView + BoardView
- Epic 5 / Story 3 — AdminDashboardView
- Epic 5 / Story 4 — SignalR client + reconnect + local storage

### Epic 6: Deployment

- Epic 6 / Story 1 — Bicep infrastructure skeleton
- Epic 6 / Story 2 — Deploy to Azure Container Apps
- Epic 6 / Story 3 — Production config, secrets, and observability
