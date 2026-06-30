# AI Project Context

> This file is the project-specific AI entry point for XYUIKit / YYUIKit.  
> General AI collaboration rules live in `/Users/quxiaoyou/Documents/AI`.

## Must Read First

1. `/Users/quxiaoyou/Documents/AI/README.md`
2. `/Users/quxiaoyou/Documents/AI/AI协作问题复盘与实践指南.md`
3. `README.md`
4. `PROJECT_ANALYSIS_AND_ROADMAP.md`
5. `AI_COLLABORATION_REVIEW_GUIDE.md` when touching public API, crash-risk cleanup, UIKit utilities, image utilities, or compatibility-sensitive code

## Project Shape

The repository name is `XYUIKit`; the published library name is `YYUIKit`.

This is an iOS Swift UIKit/Foundation utility library that supports CocoaPods and Swift Package Manager. It is not a normal app-only codebase. Public API compatibility matters.

## Build And Verify

Do not use plain `swift test` as the primary verification command. This is an iOS/UIKit package and macOS host builds can fail because UIKit is unavailable.

Preferred project scripts:

```bash
scripts/verify_spm_ios.sh
scripts/verify_demo_ios.sh
scripts/verify_tests_ios.sh
scripts/run_tests_ios_simulator.sh
scripts/verify_pod_lint.sh
```

If GitHub/SPM dependency fetching fails, use:

```bash
scripts/spm_github_doctor.sh
```

## Project-Specific Rules

- Treat `public` and `open` declarations as external contracts.
- Do not change public method names, parameters, return types, optionality, access levels, callback semantics, or thread behavior unless explicitly approved.
- For safety fixes, prefer adding a safer API while preserving the old API. Migrate internal code first.
- Do not replace an existing algorithm with a shorter "equivalent" implementation unless semantic equivalence and edge cases are explained.
- Public callbacks and error behavior need explicit compatibility review.
- Keep Foundation utilities as independent from UIKit as practical.
- Be cautious with `Auth`: permissions can affect App Store review and should remain modular.
- Keep CocoaPods and SPM behavior aligned where possible.

## Important Paths

| Area | Path |
| --- | --- |
| Package manifest | `Package.swift` |
| Podspec | `YYUIKit.podspec` |
| Library source | `Sources/Classes/` |
| Tests | `Tests/YYUIKitTests/` |
| Demo app | `YYUIKitDemo/` |
| Roadmap | `PROJECT_ANALYSIS_AND_ROADMAP.md` |
| AI compatibility review source | `AI_COLLABORATION_REVIEW_GUIDE.md` |
| Verification scripts | `scripts/` |

## Documentation Maintenance

Keep general AI collaboration rules in `/Users/quxiaoyou/Documents/AI`.

Keep this file focused on YYUIKit-specific context: public API compatibility, package verification, module boundaries, Demo validation, and release risks.

If a public API intentionally changes, update README, roadmap or migration notes, and explain whether it is a minor or major-version change.
