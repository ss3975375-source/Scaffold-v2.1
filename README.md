# Relay 2.0 — production-ready messaging foundation

Relay is an Expo React Native client backed by Node/Express, PostgreSQL and Socket.IO. This rebuild adds the missing application layer from the v1 scaffold: contacts, direct chats, groups, encrypted messages, receipts, typing/presence, push-token registration, attachment storage hooks, migrations, session revocation, validation, rate limiting, privacy/terms endpoints and EAS build configuration.

## What is implemented

- Google authentication with server-side ID-token verification
- Persistent JWT sessions stored as revocable session records
- Profile editing and account deletion
- Device-generated X25519-style `tweetnacl.box` identity keys and Ed25519 signing keys stored in OS secure storage
- Per-message ephemeral public-key encryption and signatures
- Direct conversations and groups
- Contacts and user search
- Message persistence with one encrypted envelope per recipient
- Socket.IO real-time delivery
- Typing indicators and online/offline presence
- Delivered/read receipts
- Expo push-token registration
- S3-compatible encrypted attachment upload endpoint (client must upload ciphertext)
- PostgreSQL migration schema and indexes
- API rate limiting and input validation
- Health endpoint
- EAS Android build profiles

## Security boundary

The server never receives plaintext message text. It stores encrypted envelopes. The current crypto layer provides authenticated encryption and per-message ephemeral keys, but it is not a Signal Protocol implementation and does not provide a full multi-device ratchet. Do not market the product as Signal-equivalent until a formal protocol review is completed.

## Backend

```bash
cd backend
npm install
cp .env.example .env
npm run db:migrate
npm start
```

Required environment variables:

- `DATABASE_URL`
- `GOOGLE_CLIENT_ID`
- `JWT_SECRET`

Optional S3-compatible attachment storage:

- `S3_ENDPOINT`
- `S3_REGION`
- `S3_BUCKET`
- `S3_ACCESS_KEY_ID`
- `S3_SECRET_ACCESS_KEY`

## Mobile

```bash
cd mobile
npm install
cp .env.example .env
npx expo start
```

Set `EXPO_PUBLIC_API_URL` to your API URL. For a physical phone during local development, use your computer's LAN address rather than `localhost`.

## Android production build

```bash
cd mobile
npm install -g eas-cli
eas login
eas build:configure
eas build --platform android --profile production
```

Change the Android package in `mobile/app.json` before publishing. Configure Google Cloud Android OAuth using the production signing certificate fingerprint from EAS.

## Deployment

Recommended first deployment:

1. GitHub for source control.
2. Neon/Supabase PostgreSQL.
3. Render/Railway/Fly.io persistent Node service for the API and Socket.IO.
4. S3/R2/Supabase Storage for encrypted attachment blobs.
5. Expo EAS for Android builds.
6. Google Cloud OAuth for sign-in.

Run the database migration once against the production database before starting the API.

## Before public launch

- Replace `/privacy` and `/terms` placeholders with final legal documents.
- Complete Google OAuth verification and Play Console data-safety declarations.
- Configure production S3 bucket lifecycle/backup policy.
- Add monitoring (Sentry/OpenTelemetry or equivalent).
- Add automated integration tests against a disposable PostgreSQL instance.
- Perform a professional cryptographic review and threat model.
- Add multi-device key management before supporting multiple phones per account.
- Add encrypted attachment chunking and decryption UI.
- Configure a real push-notification service policy and notification categories.
