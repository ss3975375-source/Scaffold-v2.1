# Google authentication setup

This document is the next manual configuration step for the Android development build.

## Important

Do not put a Google service-account private key, client secret, or other server credential inside the Flutter application.

The Android OAuth client is identified by the Android package name plus the SHA-1 fingerprint of the certificate used to sign the build. Development and production builds use different signing certificates, so both must eventually be registered separately.

## Development setup

1. Open Google Cloud Console.
2. Create a dedicated project for Ultimate Privacy (or use the existing project for this application).
3. Configure the OAuth consent/branding information.
4. Create an OAuth client of type **Android**.
5. Enter the exact Android package/application ID used by the build.
6. Enter the SHA-1 fingerprint of the debug signing certificate.
7. Create a second OAuth client of type **Web application** for the backend server.
8. Keep the Web client ID non-secret; never place a server client secret in the mobile application.
9. The Flutter client will request only the minimum identity information needed for sign-in.

## Before production

Create and register the production signing certificate separately. If Google Play App Signing is enabled, the Play Console provides the app-signing certificate fingerprint. The production OAuth configuration must not rely on the debug certificate.

## Current application state

The Flutter code already contains a Google authentication service using the current `google_sign_in` initialization/authentication API. The service accepts a server client ID through configuration, but no real OAuth client ID is committed to source control.

The next implementation step after OAuth configuration is backend token validation, user creation/update, device registration, and issuance of the application's own session. Google remains the identity provider; it is not the application's messaging encryption identity.
