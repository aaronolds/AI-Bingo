# Feature Specification: Azure Infrastructure and Deployment

**Feature Branch**: `006-azure-infra-deployment`  
**Created**: 2026-01-23  
**Status**: Draft  
**Input**: GitHub Issues #19, #20, #21 (Epic 6)

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Azure Infrastructure Foundation (Priority: P1)

As a developer, I want an initial Azure Bicep infrastructure skeleton so that we can deploy the app consistently to cloud environments.

**Why this priority**: Without infrastructure-as-code, no cloud deployment is possible. This is the foundational requirement that enables all other deployment stories.

**Independent Test**: Can be fully tested by running `az bicep build` on the templates and validating parameters for dev/prod environments. Delivers deployable infrastructure definition.

**Acceptance Scenarios**:

1. **Given** the `infra/` directory exists with Bicep templates, **When** I run `az bicep build --file infra/main.bicep`, **Then** the compilation succeeds with no errors.
2. **Given** a Bicep template with environment parameters, **When** I specify `env=dev` or `env=prod`, **Then** appropriate SKU tiers and resource names are applied.
3. **Given** the infrastructure templates, **When** I review the source code, **Then** no secrets or connection strings are hardcoded.

---

### User Story 2 - Deploy to Azure Container Apps (Priority: P2)

As a developer, I want the app deployed to Azure Container Apps so that the system can run in production-like hosting with managed scaling.

**Why this priority**: Deployment is the natural next step after infrastructure exists. Without this, the infrastructure has no purpose.

**Independent Test**: Can be validated by deploying containers and confirming the API endpoint is publicly reachable and SignalR connections work.

**Acceptance Scenarios**:

1. **Given** containerized API and Web apps, **When** I deploy to Azure Container Apps, **Then** the API endpoint is publicly reachable via HTTPS.
2. **Given** a deployed Container App, **When** a client connects to `/hubs/bingo`, **Then** SignalR connections are established successfully.
3. **Given** a deployed environment, **When** the API attempts to connect to Postgres and Redis, **Then** connections succeed using managed service credentials.
4. **Given** a complete deployment, **When** an admin starts a session and calls tiles, **Then** connected viewer clients receive real-time updates.

---

### User Story 3 - Production Configuration and Observability (Priority: P3)

As a developer, I want production-ready configuration patterns so that deployments are secure, diagnosable, and maintainable.

**Why this priority**: Observability and secure configuration are essential for production operations but can be layered on after basic deployment works.

**Independent Test**: Can be validated by checking that no secrets exist in source, health endpoints respond, and traces appear in Application Insights or OTLP collector.

**Acceptance Scenarios**:

1. **Given** a deployed application, **When** I inspect the source repository, **Then** no production secrets (connection strings, API keys) are found.
2. **Given** a running application, **When** I call `/health` and `/alive` endpoints, **Then** appropriate health status responses are returned.
3. **Given** OpenTelemetry instrumentation, **When** requests flow through the system, **Then** traces and metrics are emitted and visible in the observability backend.
4. **Given** structured logging is enabled, **When** the application logs events, **Then** logs are in JSON format with correlation IDs.

---

### Edge Cases

- What happens when Azure Container Apps cannot pull the container image? → Deployment fails with clear error; rollback to previous version if available.
- How does the system handle Redis connection failures? → Graceful degradation with fallback to database-only operations where possible.
- What happens when PostgreSQL is temporarily unavailable? → Health check fails, traffic is rerouted, retries with exponential backoff.
- How are secrets rotated without downtime? → Use Azure Key Vault with managed identities; secrets refresh without app restart.

## Requirements *(mandatory)*

### Functional Requirements

#### Infrastructure (Story 1)

- **FR-001**: System MUST have an `infra/` directory with a clear entrypoint Bicep file (`main.bicep`)
- **FR-002**: System MUST define Bicep resources for Azure Database for PostgreSQL Flexible Server
- **FR-003**: System MUST define Bicep resources for Azure Cache for Redis
- **FR-004**: System MUST define Bicep resources for Azure Container Apps Environment and Container Apps
- **FR-005**: Infrastructure templates MUST compile successfully via `az bicep build`
- **FR-006**: Infrastructure MUST support environment-specific parameters (dev/prod) for naming and SKU tiers
- **FR-007**: Infrastructure MUST NOT contain hardcoded secrets; use Key Vault or ACA secrets

#### Deployment (Story 2)

- **FR-008**: System MUST support building and publishing container images for API and Web services
- **FR-009**: Container Apps MUST be configured with appropriate ingress for public API access
- **FR-010**: SignalR MUST function correctly in the Container Apps environment (sticky sessions if required)
- **FR-011**: Container Apps MUST have network access to PostgreSQL and Redis managed services
- **FR-012**: Environment variables for database connection strings and admin API key MUST be configured via ACA secrets

#### Configuration and Observability (Story 3)

- **FR-013**: Application MUST use environment-based configuration (no environment-specific values in source)
- **FR-014**: Connection strings MUST be retrieved from managed service configuration or Key Vault
- **FR-015**: Admin API key MUST be stored in and retrieved from a secrets store (Key Vault or ACA secrets)
- **FR-016**: Application MUST emit OpenTelemetry traces, metrics, and logs
- **FR-017**: Application MUST expose `/health` and `/alive` endpoints for container orchestration
- **FR-018**: Logging MUST be structured (JSON) with request correlation

### Key Entities

- **Container App**: Represents the deployed API or Web service with ingress, scaling, and environment configuration
- **Container Apps Environment**: Shared hosting environment for Container Apps with networking and log analytics
- **PostgreSQL Flexible Server**: Managed database service with configured firewall rules and connection pooling
- **Redis Cache**: Managed caching service for session state and lightweight data
- **Key Vault**: Secure storage for secrets, connection strings, and certificates
- **Log Analytics Workspace**: Centralized logging and monitoring for all deployed resources

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Infrastructure templates deploy successfully to Azure in under 15 minutes for a new environment
- **SC-002**: Deployed API responds to health checks within 30 seconds of container start
- **SC-003**: End-to-end flow (create session → create board → tile calls update clients) works in deployed environment
- **SC-004**: SignalR real-time updates reach connected clients within 1 second in the deployed environment
- **SC-005**: Zero secrets are stored in version control (validated by secret scanning)
- **SC-006**: Traces are visible in the observability backend within 5 minutes of request execution
- **SC-007**: Application can be deployed to a new environment using only documented commands (no manual portal steps)

## Assumptions

- Azure subscription is available with appropriate permissions for resource creation
- Container registry (Azure Container Registry or GitHub Container Registry) is available for image storage
- .NET Aspire local development environment is already functional (Epic 1 complete)
- The application (API, SignalR hub, Web) is functional locally before deployment
- Azure CLI and Bicep CLI are available in the deployment environment

## Dependencies

- **Epic 4** (SignalR hub and events) must be complete for SignalR deployment validation
- **Epic 5** (React/Vite client) should be complete for full end-to-end testing
- Aspire service defaults already include OpenTelemetry scaffolding (from `Bingo.ServiceDefaults`)

## Out of Scope

- Multi-region deployment and geo-redundancy
- Blue-green or canary deployment strategies
- Custom domain and SSL certificate configuration
- Cost optimization and reserved instance configuration
- Disaster recovery and backup automation
- CI/CD pipeline creation (deployment commands only; automation is separate)
