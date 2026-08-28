# Google Sign-In CI setup

The Android OAuth client is bound to the app package name and the SHA-1 of the certificate that signs the APK. Google documents this requirement and recommends using `signingReport` or `keytool` to obtain the signing certificate SHA-1.

This repository builds Android on a GitHub-hosted runner. Those runners are ephemeral, so the automatically generated Android debug keystore is not a safe identity to register permanently in Google Cloud. The workflow therefore restores one stable debug keystore from the repository Actions secret `ANDROID_DEBUG_KEYSTORE_BASE64` before building.

## One-time setup

### 1. Generate the stable debug keystore

On the computer where you can run Java/keytool:

```bash
mkdir -p ~/.android
keytool -genkeypair \
  -v \
  -keystore ~/.android/debug.keystore \
  -storepass android \
  -keypass android \
  -alias androiddebugkey \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -dname "CN=Android Debug,O=Android,C=US"
```

If a debug keystore already exists and you want to use it, do not overwrite it. The important part is that the same file is used by every CI build.

### 2. Get its SHA-1

```bash
keytool -list -v \
  -keystore ~/.android/debug.keystore \
  -alias androiddebugkey \
  -storepass android \
  -keypass android
```

Copy the `SHA1:` value.

### 3. Google Cloud

In the Ultimate Privacy Google Cloud project, open the Android OAuth client and make sure these values are exactly:

- Package name: `com.example.ultimate_privacy`
- SHA-1: the SHA-1 printed from the stable keystore above

Keep the Web OAuth client as the server client ID used by the Flutter code.

### 4. Create the GitHub Actions secret

Base64 encode the keystore:

Linux/macOS:

```bash
base64 -w 0 ~/.android/debug.keystore
```

If `-w` is unavailable:

```bash
base64 ~/.android/debug.keystore | tr -d '\n'
```

Windows PowerShell:

```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("$env:USERPROFILE\.android\debug.keystore"))
```

Then open the repository on GitHub:

`Settings` → `Secrets and variables` → `Actions` → `New repository secret`

Use:

- Name: `ANDROID_DEBUG_KEYSTORE_BASE64`
- Secret: paste the complete base64 value

Do not commit the keystore itself to GitHub.

### 5. Run the workflow

Open:

`Actions` → `Flutter Android build` → `Run workflow`

The workflow will:

1. generate the Android project;
2. restore the stable debug keystore;
3. run `flutter analyze`;
4. run `flutter test`;
5. build the APK;
6. print the keystore SHA-1;
7. print the APK SHA-1;
8. fail if the APK was not signed by the expected keystore;
9. upload the APK and Google Sign-In diagnostics.

The APK SHA-1 must match the SHA-1 registered for `com.example.ultimate_privacy` in Google Cloud.
