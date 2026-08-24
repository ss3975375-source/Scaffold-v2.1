#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../client"
flutter create . --platforms=android --project-name ultimate_privacy >/dev/null
cd android
chmod +x gradlew
./gradlew signingReport
