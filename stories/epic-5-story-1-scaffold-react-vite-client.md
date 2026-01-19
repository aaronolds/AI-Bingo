# Epic 5 / Story 1 — Scaffold React + Vite client app

## User Story

As a viewer/admin,
I want a modern web client built with React + Vite,
so that the UI is fast, responsive, and easy to iterate on.

## Scope

- Establish a React + Vite client (TypeScript optional).
- Decide how it lives in the repo (recommended: `src/Bingo.Web/ClientApp` or similar).
- Support local development against `Bingo.Api` (proxy for `/api` + `/hubs/bingo`).

## Acceptance Criteria

- [ ] `Bingo.Web` has a clear place for the client app source.
- [ ] Dev workflow documented minimally (e.g., one command for client dev, one for Aspire).
- [ ] Client can call `GET /api/game/current` and display result.

## Implementation Tasks

- [ ] Scaffold Vite React app.
- [ ] Add dev proxy config for `/api` and `/hubs`.
- [ ] Add a simple home page that pings the API.

## Notes / Dependencies

- Depends on Epic 3 / Story 1 for the public endpoints.
- Keep SSR out of scope; SPA only.
