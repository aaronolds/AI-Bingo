# Feature Specification: Scaffold React + Vite Client App

**Feature Branch**: `005-scaffold-react-vite-client`  
**Created**: 2026-01-23  
**Status**: Draft  
**GitHub Issue**: [#15](https://github.com/aaronolds/AI-Bingo/issues/15)  
**Epic**: 5 — Frontend  
**Story**: 1 — Scaffold React + Vite client app

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Modern React + Vite Client Scaffold (Priority: P1)

As a viewer/admin,  
I want a modern web client built with React + Vite,  
so that the UI is fast, responsive, and easy to iterate on.

**Why this priority**: This is the foundational frontend story that enables all subsequent
UI work (viewer board view, admin dashboard). Without a proper client scaffold, no frontend
features can be built.

**Independent Test**: A developer can start the client app in dev mode and see a working
React application that successfully communicates with the backend API.

**Acceptance Scenarios**:

1. **Given** the repository is cloned and Node.js is installed, **When** a developer runs
   the documented npm commands in the `ClientApp` directory, **Then** the Vite dev server
   starts and serves the React application.

2. **Given** the Vite dev server is running and `Bingo.Api` is running (via Aspire or standalone),
   **When** the client makes a request to `/api/game/current`, **Then** the request is proxied
   to the API and a valid response is returned.

3. **Given** the client app is running, **When** a developer views the home page, **Then**
   the page displays the result of calling `GET /api/game/current` (or a friendly message
   if no active session exists).

---

### User Story 2 - Integrated Developer Experience (Priority: P2)

As a developer,  
I want clear documentation for running the client alongside the backend,  
so that I can iterate on frontend features without confusion.

**Why this priority**: Developer experience is critical for productive iteration. Clear
workflows reduce onboarding friction and prevent configuration issues.

**Independent Test**: A developer can follow the documented workflow to run both the
client and backend with minimal steps.

**Acceptance Scenarios**:

1. **Given** the developer reads the README or quickstart docs, **When** they follow the
   documented steps, **Then** they can run the full stack (Aspire + client dev server)
   with clear commands.

2. **Given** the Vite proxy is configured, **When** the client fetches `/api/*` or
   `/hubs/bingo`, **Then** requests are correctly proxied to the backend without CORS issues.

---

### Edge Cases

- The `Bingo.Api` is not running when the client starts (should show a graceful error).
- The `/api/game/current` endpoint returns no active session (should display a user-friendly message).
- Node.js or npm is not installed on the developer machine.
- The Vite proxy target port conflicts with another service.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The client app MUST be scaffolded using Vite with React.
- **FR-002**: The client MUST use TypeScript for type safety.
- **FR-003**: The client source MUST live under `src/Bingo.Web/ClientApp`.
- **FR-004**: The Vite dev server MUST proxy `/api` requests to the backend API.
- **FR-005**: The Vite dev server MUST proxy `/hubs` requests to the SignalR hub endpoint.
- **FR-006**: The client MUST include a home page component that fetches and displays
  `GET /api/game/current` results.
- **FR-007**: The client MUST handle the "no active session" case gracefully with a
  user-friendly message.
- **FR-008**: The client MUST be a Single Page Application (SPA) — no Server-Side Rendering.

### Non-Functional Requirements

- **NFR-001**: The client dev server MUST support Hot Module Replacement (HMR) for fast
  iteration during development.
- **NFR-002**: The client MUST use modern React patterns (functional components, hooks).
- **NFR-003**: The client structure MUST be organized for scalability (components, hooks,
  services, types directories).

### Technical Constraints

- **TC-001**: Must use Vite as the build tool (not Create React App or Webpack directly).
- **TC-002**: Must use React 18+ with TypeScript.
- **TC-003**: No SSR frameworks (Next.js, Remix) — keep it as a pure SPA.
- **TC-004**: The `Bingo.Web` ASP.NET project remains a placeholder host; the React app
  runs independently via Vite dev server during development.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A developer can start the client in development mode using a single documented command.
- **SC-002**: The client application loads and displays content within 3 seconds on a typical connection.
- **SC-003**: Developers can successfully call `GET /api/game/current` from the client and see the result displayed.
- **SC-004**: The client gracefully handles API unavailability with a user-friendly error message.
- **SC-005**: A new developer can set up and run the client following documentation in under 5 minutes.
- **SC-006**: The client can be built for production without errors.
- **SC-007**: Changes to client code are reflected in the browser without a full page refresh during development.

## Dependencies

### Upstream Dependencies

- **Epic 3 / Story 1**: Public game and board endpoints (`GET /api/game/current`) must exist.
- **Epic 1**: Aspire orchestration for running the backend locally.

### Downstream Dependents

- **Epic 5 / Story 2**: Viewer home and board views (builds on this scaffold).
- **Epic 5 / Story 3**: Admin dashboard view (builds on this scaffold).
- **Epic 5 / Story 4**: SignalR client reconnect and localStorage (requires client scaffold).

## Out of Scope

- Server-Side Rendering (SSR) — SPA only for this story.
- Production build integration with ASP.NET static file serving (deferred).
- Styling framework decisions (CSS-in-JS, Tailwind, etc.) — minimal CSS only.
- State management library (Redux, Zustand) — React state only for now.
- Authentication or protected routes.
- SignalR client integration (covered in Epic 5 / Story 4).

## Assumptions

- Developers have Node.js (LTS version) installed on their development machines.
- The `Bingo.Api` backend will be available at a known local address during development.
- Initial styling will be minimal; design system decisions are deferred to future stories.
- The client will be a pure SPA (Single Page Application) without server-side rendering requirements.
