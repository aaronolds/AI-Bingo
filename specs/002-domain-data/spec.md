# Feature Specification: Domain and Data Layer Implementation

**Feature Branch**: `002-domain-data`  
**Created**: January 23, 2026  
**Status**: Draft  
**Input**: User description: "Implement domain model, data access, board generation, migrations, and Redis integration for the AI Bingo game system"

## User Scenarios & Testing *(mandatory)*

<!--
  IMPORTANT: User stories should be PRIORITIZED as user journeys ordered by importance.
  Each user story/journey must be INDEPENDENTLY TESTABLE - meaning if you implement just ONE of them,
  you should still have a viable MVP (Minimum Viable Product) that delivers value.
  
  Assign priorities (P1, P2, P3, etc.) to each story, where P1 is the most critical.
  Think of each story as a standalone slice of functionality that can be:
  - Developed independently
  - Tested independently
  - Deployed independently
  - Demonstrated to users independently
-->

### User Story 1 - Persistent Game Data (Priority: P1)

As a developer, I want the core bingo domain model and data access layer fully implemented so that game templates, sessions, and boards can be reliably persisted and retrieved to support all downstream features.

**Why this priority**: This is the foundational data layer that all other features depend on. Without persistent storage for game state, no other feature can function properly.

**Independent Test**: Can be fully tested by creating a game template with tiles, persisting it to the database, retrieving it, and verifying all data integrity constraints are enforced. Delivers the ability to store and manage bingo game configurations.

**Acceptance Scenarios**:

1. **Given** a new game template with 50 tiles, **When** the template is saved to the database, **Then** all tiles are persisted with correct relationships and can be queried back
2. **Given** an existing template, **When** a game session is created referencing that template, **Then** the session is persisted with correct status (Draft/Active/Ended) and timestamps
3. **Given** invalid domain data (e.g., empty template name, negative tile weight), **When** attempting to create entities, **Then** invariant validation prevents persistence and returns clear error messages
4. **Given** the application starts up in development mode, **When** connecting to the Aspire-provisioned PostgreSQL database, **Then** migrations are automatically applied and seed data is loaded

---

### User Story 2 - Deterministic Board Generation (Priority: P2)

As a viewer, I want my bingo board generated deterministically from a seed value so that if I disconnect and reconnect, or if I need to export my board, I can always reproduce the exact same board layout.

**Why this priority**: Board generation is essential for the core bingo gameplay experience. Determinism ensures reliability and enables features like reconnection and board verification.

**Independent Test**: Can be fully tested by generating boards with the same seed multiple times and verifying identical output, then testing with different seeds to verify variation. Delivers the core board creation capability.

**Acceptance Scenarios**:

1. **Given** a template with 50 tiles and a specific seed value, **When** generating a board, **Then** the same 5×5 board layout is produced every time with that seed
2. **Given** different seed values, **When** generating multiple boards, **Then** each board has a statistically different tile arrangement
3. **Given** a generated board, **When** checking for duplicate tiles, **Then** no tile appears more than once on the board
4. **Given** a board is configured with a free center cell, **When** generating the board, **Then** the center position (3,3) is marked as the free space

---

### User Story 3 - Bingo Win Detection (Priority: P2)

As a viewer, I want the system to automatically detect when I've achieved bingo (row, column, or diagonal) so that I know immediately when I've won without manual verification.

**Why this priority**: Win detection is core to the game experience and must be accurate and reliable to maintain player trust and engagement.

**Independent Test**: Can be fully tested by creating boards with known marked patterns (complete rows, columns, diagonals) and verifying correct win detection in all scenarios. Delivers the core win validation logic.

**Acceptance Scenarios**:

1. **Given** a board with all cells in any row marked, **When** evaluating for bingo, **Then** the system correctly identifies a winning row
2. **Given** a board with all cells in any column marked, **When** evaluating for bingo, **Then** the system correctly identifies a winning column
3. **Given** a board with all cells in either diagonal marked, **When** evaluating for bingo, **Then** the system correctly identifies a winning diagonal
4. **Given** a board with 24 marked cells but no complete line, **When** evaluating for bingo, **Then** the system correctly reports no bingo

---

### User Story 4 - Session State Caching (Priority: P3)

As a developer, I want lightweight session state cached in Redis so that current session information and called tiles can be quickly accessed without database queries, enabling real-time responsiveness.

**Why this priority**: Redis caching improves performance and enables efficient real-time updates, but the system can function with database-only access initially.

**Independent Test**: Can be fully tested by storing session state in Redis, retrieving it, and verifying consistency with database state. Delivers performance optimization for session data access.

**Acceptance Scenarios**:

1. **Given** a newly started game session, **When** the session ID is written to Redis as "current session", **Then** the value can be retrieved consistently
2. **Given** an active session with called tiles, **When** tiles are added to the Redis called-tiles set, **Then** all called tiles can be retrieved in order
3. **Given** the Aspire-provisioned Redis instance, **When** the API starts up, **Then** the Redis connection is established successfully using configuration-provided connection strings
4. **Given** cached session data in Redis, **When** comparing with database state, **Then** the data remains consistent

---

### User Story 5 - Development Environment Ready (Priority: P1)

As a developer, I want the local development environment to automatically set up with seed data so that I can immediately test game functionality without manual database configuration.

**Why this priority**: A working development environment is critical for team productivity and enables rapid iteration on features.

**Independent Test**: Can be fully tested by running `aspire run` from a clean state and verifying that the database is created, migrations are applied, and seed data is present. Delivers a working development setup.

**Acceptance Scenarios**:

1. **Given** a clean local environment, **When** running `aspire run`, **Then** PostgreSQL starts, migrations apply automatically, and at least one game template with 40+ tiles is available
2. **Given** the development environment has been run before, **When** running `aspire run` again, **Then** seed data is not duplicated (idempotent seed logic)
3. **Given** the seeded template, **When** attempting to generate a board, **Then** the board is successfully created with 25 unique tiles
4. **Given** the development environment, **When** running unit tests, **Then** test database migrations apply successfully

---

### Edge Cases

- What happens when a template has fewer than 25 tiles but a 5×5 board is requested? (Should validate minimum tile count)
- How does the system handle concurrent session creation attempts? (Database constraints should prevent duplicates)
- What happens when Redis is unavailable but the database is accessible? (Should degrade gracefully or fail with clear error)
- How does the system handle migration failures during startup? (Should log clearly and prevent startup rather than run with inconsistent schema)
- What happens when attempting to generate a board with a null or invalid seed? (Should use a default deterministic fallback)
- How does the system handle special characters or very long text in tile content? (Should enforce reasonable length limits and character validation)

## Requirements *(mandatory)*

### Functional Requirements

#### Domain Model (Bingo.Core)

- **FR-001**: System MUST define a GameTemplate entity with name, description, and a collection of TemplateTile entities
- **FR-002**: System MUST define a TemplateTile entity with text content, optional weight for selection probability, and relationship to GameTemplate
- **FR-003**: System MUST define a GameSession entity with template reference, status (Draft/Active/Ended), start time, end time, and created/updated timestamps
- **FR-004**: System MUST define a Board entity with session reference, viewer identifier, seed value, and collection of BoardCell entities
- **FR-005**: System MUST define a BoardCell entity with row/column position, tile reference, and marked status
- **FR-006**: System MUST define a DrawEvent entity to track tile calls with session reference, tile reference, call number, and timestamp
- **FR-007**: Domain entities MUST enforce invariants through constructors and methods (e.g., required fields, valid status transitions)
- **FR-008**: Domain entities MUST remain persistence-agnostic with no EF Core attributes or database-specific logic
- **FR-009**: Session status transitions MUST be controlled (Draft→Active, Active→Ended) with invalid transitions rejected

#### Board Generation

- **FR-010**: System MUST provide a board generation service that accepts a template and seed value as input
- **FR-011**: Board generation MUST produce a 5×5 grid of cells with tiles selected from the template
- **FR-012**: Board generation MUST be deterministic - the same seed and template MUST always produce the identical board
- **FR-013**: Board generation MUST ensure no tile appears more than once on a single board
- **FR-014**: Board generation MUST support marking the center cell (position 3,3) as a free space when configured
- **FR-015**: System MUST provide bingo rule evaluation that detects wins based on marked cells
- **FR-016**: Win detection MUST identify complete rows (any of 5 rows)
- **FR-017**: Win detection MUST identify complete columns (any of 5 columns)
- **FR-018**: Win detection MUST identify complete diagonals (top-left to bottom-right, top-right to bottom-left)

#### Data Access (Bingo.Data)

- **FR-019**: System MUST provide a dedicated Bingo.Data project targeting .NET 10.0
- **FR-020**: System MUST implement a DbContext with DbSets for all domain entities
- **FR-021**: System MUST use Entity Framework Core with the Npgsql (PostgreSQL) provider
- **FR-022**: System MUST define entity mappings using Fluent API for keys, relationships, and indexes
- **FR-023**: System MUST support connection to the Aspire-provisioned PostgreSQL instance via configuration
- **FR-024**: All package references MUST use central package management without inline versions in .csproj files

#### Migrations and Seed Data

- **FR-025**: System MUST provide an initial EF Core migration representing the complete schema
- **FR-026**: System MUST apply migrations automatically on startup in development environments
- **FR-027**: System MUST provide seed data with at least one complete game template containing 40+ tiles
- **FR-028**: Seed data execution MUST be idempotent - running multiple times MUST NOT create duplicate data
- **FR-029**: Seed data MUST only run in development environments or use environment-based configuration

#### Redis Integration

- **FR-030**: System MUST provide a service abstraction for session state storage using Redis
- **FR-031**: System MUST store and retrieve the current active session identifier in Redis
- **FR-032**: System MUST store and retrieve the set of called tiles for a session in Redis
- **FR-033**: Redis integration MUST use StackExchange.Redis library with central package management
- **FR-034**: Redis connection MUST be configured via Aspire-provided connection strings
- **FR-035**: Redis operations MUST remain simple and focused on current session and called tiles caching

### Key Entities

- **GameTemplate**: Represents a bingo game configuration with a name, description, and collection of possible tiles. One template can be used for multiple sessions.
- **TemplateTile**: Individual tile content within a template. Includes text that appears on the tile and optional weight for probability-based selection during board generation.
- **GameSession**: Represents a single live or completed game instance. References a template, tracks status lifecycle (Draft→Active→Ended), and has start/end timestamps.
- **Board**: Represents a viewer's personal bingo board for a session. Contains a seed value for deterministic reproduction and a 5×5 grid of cells.
- **BoardCell**: Individual cell within a board grid. Has a row/column position (0-4), references a tile, and tracks whether the cell has been marked by the viewer.
- **DrawEvent**: Audit log of tile calls during a session. Records which tile was called, the sequence number, and exact timestamp for replay and verification.

### Data Relationships

- GameTemplate (1) → (many) TemplateTile: A template owns its tiles
- GameTemplate (1) → (many) GameSession: A template can be used for multiple game sessions
- GameSession (1) → (many) Board: A session can have multiple viewer boards
- GameSession (1) → (many) DrawEvent: A session tracks all tile calls
- Board (1) → (many) BoardCell: A board owns 25 cells in a 5×5 grid
- TemplateTile (1) → (many) BoardCell: A tile can appear on many different boards

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Developers can create a complete game template with 50 tiles and persist it to the database in under 10 seconds
- **SC-002**: Board generation with the same seed produces byte-for-byte identical results across 1000 iterations (100% determinism)
- **SC-003**: Board generation with different seeds produces unique boards with at least 80% different tile positions across 100 samples
- **SC-004**: Win detection correctly identifies all 12 possible winning patterns (5 rows + 5 columns + 2 diagonals) with 100% accuracy
- **SC-005**: Development environment setup via `aspire run` completes successfully within 2 minutes on first run with automatic migrations and seed data
- **SC-006**: Unit tests achieve at least 90% code coverage for domain logic (Bingo.Core) including board generation and win detection
- **SC-007**: Integration tests verify end-to-end data persistence and retrieval for all domain entities with 100% success rate
- **SC-008**: Redis session state operations (read/write current session and called tiles) complete in under 50 milliseconds for 95% of operations
- **SC-009**: The data layer supports at least 100 concurrent board generations without degradation
- **SC-010**: Seed data idempotency is verified - running seed logic 10 times results in exactly the same database state as running once

## Assumptions

- **Assumption 1**: The .NET Aspire AppHost is already configured and operational from Epic 1, providing PostgreSQL and Redis resources
- **Assumption 2**: The repository follows central package management conventions specified in Directory.Packages.props
- **Assumption 3**: All projects target .NET 10.0 (net10.0) as specified in Directory.Build.props
- **Assumption 4**: Standard 5×5 bingo board format is used (not configurable board sizes in v1)
- **Assumption 5**: Tile weights are optional; if not specified, uniform probability is assumed for board generation
- **Assumption 6**: Free center cell is a configuration option but defaults to enabled for traditional bingo gameplay
- **Assumption 7**: Development environment uses local Aspire-provisioned infrastructure; production deployment is handled separately in Epic 6
- **Assumption 8**: The viewer identifier in Board entity is a simple string token, not a full authentication system
- **Assumption 9**: Seed values for board generation are strings that can be hashed to produce deterministic random number sequences
- **Assumption 10**: Redis is used for caching only; the database remains the source of truth for all persistent data

## Dependencies

### External Dependencies

- **Epic 1 Completion**: Requires Aspire AppHost with PostgreSQL and Redis resources configured and functional
- **PostgreSQL Database**: Running instance accessible via Aspire connection string
- **Redis Cache**: Running instance accessible via Aspire connection string
- **.NET 10.0 SDK**: Development and build environment requirement
- **Entity Framework Core Tools**: Required for migration generation during development

### Internal Dependencies

- **Bingo.Core project must exist before Bingo.Data**: Data layer depends on domain models
- **Central Package Management configuration**: Directory.Packages.props must define versions for EF Core, Npgsql, and StackExchange.Redis
- **Bingo.ServiceDefaults**: May be needed for service registration patterns
- **Test projects structure**: Bingo.Core.Tests and Bingo.Api.Tests projects must exist or be created

### Downstream Impact

- **Epic 3 (API Layer)**: Public and admin endpoints will depend on the domain model and data access layer
- **Epic 4 (Real-time)**: SignalR hub will use Redis for pub/sub messaging
- **Epic 5 (Frontend)**: UI will consume board and session data structures
- **Epic 6 (Deployment)**: Migration and seed strategies must work in containerized production environment
