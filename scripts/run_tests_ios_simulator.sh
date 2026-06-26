#!/usr/bin/env bash
#
# Run YYUIKit's XCTest bundle on an iOS Simulator.
#
# This is stronger than scripts/verify_tests_ios.sh:
#   - verify_tests_ios.sh only runs build-for-testing against a generic iOS SDK.
#   - this script boots/uses a concrete simulator destination and executes tests.
#
# Usage:
#   scripts/run_tests_ios_simulator.sh
#
# Override destination:
#   DESTINATION='platform=iOS Simulator,name=iPhone 17 Pro,OS=latest' scripts/run_tests_ios_simulator.sh
#
# Override scheme:
#   SCHEME='YYUIKit-Package' scripts/run_tests_ios_simulator.sh
#
set -euo pipefail

SCHEME="${SCHEME:-YYUIKit-Package}"
DESTINATION="${DESTINATION:-platform=iOS Simulator,name=iPhone 17,OS=latest}"

echo "Running tests for Swift Package scheme: ${SCHEME}"
echo "Destination: ${DESTINATION}"

xcodebuild \
  -scheme "${SCHEME}" \
  -destination "${DESTINATION}" \
  test
