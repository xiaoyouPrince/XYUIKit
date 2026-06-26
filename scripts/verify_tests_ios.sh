#!/usr/bin/env bash
#
# Build YYUIKit's test bundle for iOS.
#
# Why build-for-testing instead of `swift test`?
#   YYUIKit is an iOS/UIKit package. `swift test` defaults to the host platform
#   on macOS and can fail with "no such module 'UIKit'". Building the test
#   bundle with xcodebuild verifies the XCTest target against the iOS SDK.
#   The package-generated YYUIKit-Package scheme includes YYUIKitTests.
#
# Usage:
#   scripts/verify_tests_ios.sh
#
# Override destination:
#   DESTINATION='generic/platform=iOS Simulator' scripts/verify_tests_ios.sh
#
set -euo pipefail

SCHEME="${SCHEME:-YYUIKit-Package}"
DESTINATION="${DESTINATION:-generic/platform=iOS}"

echo "Building tests for Swift Package scheme: ${SCHEME}"
echo "Destination: ${DESTINATION}"

xcodebuild \
  -scheme "${SCHEME}" \
  -destination "${DESTINATION}" \
  build-for-testing
