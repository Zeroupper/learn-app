#!/usr/bin/env bash
# Build a fresh APK (key from .env) and get it onto the connected device.
# Usage:  ./deploy.sh            # release (default)
#         ./deploy.sh debug      # debug build
set -euo pipefail
cd "$(dirname "$0")"

MODE="${1:-release}"   # release | debug
ADB="$(command -v adb || echo "$HOME/Library/Android/sdk/platform-tools/adb")"
APK="build/app/outputs/flutter-apk/app-$MODE.apk"

echo "▶ Building $MODE APK..."
# Key from the shell env (e.g. ~/.zshrc), else .env. The key ends up inside
# the APK — never publish a build made with it.
if [ -n "${OPENROUTER_API_KEY:-}" ]; then
  flutter build apk --"$MODE" --dart-define=OPENROUTER_API_KEY="$OPENROUTER_API_KEY"
else
  flutter build apk --"$MODE" --dart-define-from-file=.env
fi

echo "▶ Installing on device..."
if "$ADB" install -r "$APK" 2>/dev/null; then
  echo "✓ Installed. Launching..."
  "$ADB" shell monkey -p com.havlik.learn_app -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1 || true
else
  # MIUI/HyperOS blocks adb installs (INSTALL_FAILED_USER_RESTRICTED).
  echo "⚠ adb install blocked — pushing to Downloads instead..."
  "$ADB" push "$APK" /sdcard/Download/learn_app.apk
  echo "✓ Pushed. On the phone: Files → Downloads → tap learn_app.apk to install."
fi
