#!/usr/bin/env bash
#
# Verify YYUIKit as a Swift Package for iOS.
#
# Why not `swift test`?
#   YYUIKit is an iOS/UIKit package. `swift test` defaults to the host platform
#   on macOS, so it can fail with "no such module 'UIKit'" even when the package
#   is valid for iOS. Use xcodebuild with an iOS destination instead.
#
# Usage:
#   scripts/verify_spm_ios.sh
#
# If GitHub dependency resolution fails:
#   scripts/spm_github_doctor.sh
#   scripts/spm_github_doctor.sh --fix-git-proxy
#
set -euo pipefail

SCHEME="${SCHEME:-YYUIKit}"
DESTINATION="${DESTINATION:-generic/platform=iOS}"

echo "Verifying Swift Package scheme: ${SCHEME}"
echo "Destination: ${DESTINATION}"

xcodebuild \
  -scheme "${SCHEME}" \
  -destination "${DESTINATION}" \
  build
