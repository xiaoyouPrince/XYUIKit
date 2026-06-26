#!/usr/bin/env bash
#
# Verify the repository's built-in YYUIKitDemo project.
#
# This is the main validation entry for feature work in YYUIKit:
#   - The Demo consumes YYUIKit through CocoaPods with `pod 'YYUIKit', :path => '../.'`.
#   - The build uses a generic iOS destination so it does not depend on a local
#     simulator runtime.
#   - Code signing is disabled because this is a compile/integration check.
#
# Usage:
#   scripts/verify_demo_ios.sh
#
# Force reinstall Pods before building:
#   scripts/verify_demo_ios.sh --pod-install
#
# Override build destination:
#   DESTINATION='generic/platform=iOS Simulator' scripts/verify_demo_ios.sh
#
# If CocoaPods or GitHub download fails, diagnose network/proxy first:
#   scripts/spm_github_doctor.sh
#
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEMO_DIR="${ROOT_DIR}/YYUIKitDemo"
WORKSPACE="${WORKSPACE:-YYUIKitDemo.xcworkspace}"
SCHEME="${SCHEME:-YYUIKitDemo}"
DESTINATION="${DESTINATION:-generic/platform=iOS}"

needs_pod_install=false
if [[ "${1:-}" == "--pod-install" ]]; then
  needs_pod_install=true
elif [[ ! -d "${DEMO_DIR}/Pods/Pods.xcodeproj" ]]; then
  needs_pod_install=true
fi

cd "${DEMO_DIR}"

if [[ "${needs_pod_install}" == "true" ]]; then
  echo "Installing CocoaPods dependencies..."
  pod install
fi

echo "Verifying Demo workspace: ${WORKSPACE}"
echo "Scheme: ${SCHEME}"
echo "Destination: ${DESTINATION}"

xcodebuild \
  -workspace "${WORKSPACE}" \
  -scheme "${SCHEME}" \
  -destination "${DESTINATION}" \
  CODE_SIGNING_ALLOWED=NO \
  build
