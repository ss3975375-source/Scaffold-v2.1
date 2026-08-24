# Android identity for Google OAuth

The Android OAuth client must use the exact application ID and signing certificate used by the APK. Do not guess these values.

## Current build

The CI workflow generates the Flutter Android platform files before building. The package/application ID is expected to be `com.example.ultimate_privacy` unless the generated Android project reports otherwise.

For the debug APK, obtain the exact SHA-1 with:

```bash
cd client/android
./gradlew signingReport
```

Use the SHA-1 from the `debug` variant. For a production/Play Store build, a separate release/Play App Signing SHA-1 will be required and must also be registered in Google Cloud.

Never commit private keys, keystores, passwords, OAuth client secrets, or service-account credentials to this repository.
