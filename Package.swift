// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "YYUIKit",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "YYUIKit",
            targets: ["YYUIKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1"))
    ],
    targets: [
        .target(
            name: "YYUIKit",
            dependencies: [
                "SnapKit"
            ],
            path: "Sources",
            resources: [
                .copy("PrivacyInfo.xcprivacy"),
                .process("Assets/Assets.xcassets")
                       ]
        ),
        .testTarget(
            name: "YYUIKitTests",
            dependencies: ["YYUIKit"]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
