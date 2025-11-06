#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./release_build.sh \
#     --sign-id "Developer ID Application: Your Name (TEAMID)" \
#     --keychain-profile "Profile Name" \
#     [--project QuickShelf.xcodeproj] [--scheme QuickShelf]
#
# Prepare:
#   xcrun notarytool store-credentials "Profile Name" \
#     --apple-id "you@example.com" --team-id TEAMID --password app-specific-password

PROJECT="QuickShelf.xcodeproj"
SCHEME="QuickShelf"
CONFIG="Release"

ARCHIVE_DIR="build"
ARCHIVE_PATH="${ARCHIVE_DIR}/QuickShelf.xcarchive"
APP_PATH="${ARCHIVE_PATH}/Products/Applications/QuickShelf.app"

ENTITLEMENTS="QuickShelf/QuickShelf.entitlements"

ZIP_FOR_NOTARY="QuickShelf.notarize.zip"
ZIP_FINAL="QuickShelf.zip"

SIGN_ID=""
KEYCHAIN_PROFILE=""

# --------- Args parsing ---------
while [[ $# -gt 0 ]]; do
  case "$1" in
    --sign-id)
      SIGN_ID="${2:-}"; shift 2;;
    --keychain-profile)
      KEYCHAIN_PROFILE="${2:-}"; shift 2;;
    --project)
      PROJECT="${2:-}"; shift 2;;
    --scheme)
      SCHEME="${2:-}"; shift 2;;
    --config)
      CONFIG="${2:-}"; shift 2;;
    --entitlements)
      ENTITLEMENTS="${2:-}"; shift 2;;
    --help|-h)
      sed -n '1,60p' "$0"; exit 0;;
    *)
      echo "Unknown arg: $1"; exit 1;;
  esac
done

if [[ -z "${SIGN_ID}" || -z "${KEYCHAIN_PROFILE}" ]]; then
  echo "Error: --sign-id and --keychain-profile are required." >&2
  exit 1
fi

need() { command -v "$1" >/dev/null 2>&1 || { echo "Error: $1 not found in PATH" >&2; exit 1; }; }
need xcodebuild
need codesign
need xcrun
need ditto
need spctl

echo "==> Clean ${ARCHIVE_DIR}"
rm -rf "${ARCHIVE_DIR:?}"

echo "==> 1) xcodebuild archive"
xcodebuild -project "${PROJECT}" \
  -scheme "${SCHEME}" \
  -configuration "${CONFIG}" \
  -archivePath "${ARCHIVE_PATH}" \
  clean archive \
  ARCHS="arm64 x86_64" \
  ONLY_ACTIVE_ARCH=NO

echo "==> 2) codesign (hardened runtime + timestamp)"
codesign --force --deep \
  --timestamp \
  --options runtime \
  --entitlements "${ENTITLEMENTS}" \
  --sign "${SIGN_ID}" "${APP_PATH}"

echo "==> (verify signature)"
codesign --verify --deep --strict --verbose=2 "${APP_PATH}"

echo "==> 3) zip for notarization"
rm -f "${ZIP_FOR_NOTARY}" "${ZIP_FINAL}"
ditto -c -k --keepParent "${APP_PATH}" "${ZIP_FOR_NOTARY}"

echo "==> 4) notarytool submit --wait"
xcrun notarytool submit "${ZIP_FOR_NOTARY}" \
  --keychain-profile "${KEYCHAIN_PROFILE}" \
  --wait

echo "==> 5) stapler staple .app"
xcrun stapler staple -v "${APP_PATH}"

echo "==> (Gatekeeper assess)"
spctl --assess --type execute -vv --ignore-cache --no-cache "${APP_PATH}"

echo "==> 6) make final distributable zip"
ditto -c -k --keepParent "${APP_PATH}" "${ZIP_FINAL}"

echo "✅ Done"
echo "Archive : ${ARCHIVE_PATH}"
echo "App     : ${APP_PATH}"
echo "ZIP     : ${ZIP_FINAL}"
