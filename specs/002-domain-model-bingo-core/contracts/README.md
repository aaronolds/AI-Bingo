# API Contracts

This feature (002-domain-model-bingo-core) implements the domain model layer only.

**No API contracts** are included in this iteration because:
- Domain entities are internal to the application
- API endpoints will be defined in Epic 3 (API layer)
- This layer provides types and business logic for use by the API

## Future API Contracts

When API endpoints are added in Epic 3, contracts will include:
- OpenAPI/Swagger definitions for REST endpoints
- Request/Response DTOs
- Validation rules at the API boundary

The domain model defined in this feature will be used by those APIs but does not expose HTTP endpoints directly.
