# Ultimate Privacy Communication Platform

## Architecture v1.1

This document is the current technical foundation for the project.

### Client
- Flutter / Dart
- Android and Windows targets
- Native platform integrations where required
- Local encrypted application data
- OS-backed secure key storage

### Backend
- Go modular backend
- HTTPS REST API for request/response operations
- WebSocket for real-time events
- PostgreSQL for control-plane metadata
- Redis-compatible temporary state/cache

### Communication
- End-to-end encryption for user content
- TLS for device-to-server transport
- Device-specific cryptographic identities
- Separate account, device, conversation, group, file and backup key domains

### Files
- Client-side encryption before transfer
- Chunked and resumable uploads/downloads
- Integrity verification
- Account-level daily transfer quotas
- Temporary encrypted relay/storage
- Delivery-aware deletion pipeline

### Calling
- WebRTC
- SFU architecture for group calls
- No ordinary persistent recording/storage by default

### Infrastructure
- Docker for reproducible environments
- Reverse proxy / TLS termination
- Horizontally scalable services
- Development, staging and production environments
- GitHub Actions for CI/CD

### Privacy principles
1. User content remains primarily on user devices.
2. Servers should receive only the minimum information required to operate the service.
3. Plaintext message/file content must not be stored server-side unnecessarily.
4. Encryption keys must remain under client-controlled security boundaries.
5. Temporary server-side content must have explicit retention and deletion rules.
6. Security claims must be testable; the product must not promise absolute or 100% security.

### Initial implementation strategy
Start as a modular Go backend rather than many microservices. Split components only when scale or isolation requirements justify it.

### Initial milestone
Google authentication -> account creation -> device registration -> authenticated Go API -> PostgreSQL metadata persistence -> first Android test build.

### Important
Cryptographic protocol selection must be finalized and reviewed before production E2EE implementation. We will use established cryptographic protocols/primitives and will not invent cryptography.
