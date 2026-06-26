#!/usr/bin/env bash
#
# Verify the CocoaPods publishing surface for YYUIKit.
#
# This checks the podspec itself, including all subspecs. It is stricter than
# building the Demo because CocoaPods treats Swift warnings as validation
# failures unless --allow-warnings is used. Keep this script warning-clean.
#
# Usage:
#   scripts/verify_pod_lint.sh
#
# If CocoaPods CDN or GitHub dependency resolution fails:
#   scripts/spm_github_doctor.sh
#
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "${ROOT_DIR}"

pod lib lint YYUIKit.podspec
