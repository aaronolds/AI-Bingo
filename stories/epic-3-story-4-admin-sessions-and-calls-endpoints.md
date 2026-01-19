# Epic 3 / Story 4 — Admin sessions + tile call endpoints

## User Story

As a stream admin,
I want to start/end a session and call/uncall tiles,
so that the live show can drive the bingo game in real time.

## Scope

Implement admin endpoints:

- `POST /api/admin/sessions`
- `POST /api/admin/sessions/{id}/end`
- `POST /api/admin/sessions/{id}/calls`
- `DELETE /api/admin/sessions/{id}/calls/{callId}`

## Acceptance Criteria

- [ ] Starting a session creates a GameSession in Active state.
- [ ] Ending a session transitions it to Ended state.
- [ ] Calling a tile creates a DrawEvent with increasing SequenceNumber.
- [ ] Uncalling a tile removes/marks the event so clients reflect the change.
- [ ] Endpoints require the admin API key.

## Implementation Tasks

- [ ] Define DTOs for session start + tile call.
- [ ] Implement handlers and enforce session status invariants.
- [ ] Ensure SequenceNumber is monotonic per session.
- [ ] Add tests for call ordering and end-session behavior.

## Notes / Dependencies

- SignalR broadcasting is handled in Epic 4; here we focus on persistence + correctness.
