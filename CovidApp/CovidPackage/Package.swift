// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CovidPackage",
    platforms: [
        SupportedPlatform.iOS(.v11)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "CovidPackage",
            targets: ["CovidPackage"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/lachlanbell/SwiftOTP.git", .upToNextMinor(from: "2.0.0")),
        .package(url: "https://github.com/datatheorem/TrustKit.git", .upToNextMinor(from: "1.6.5"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "CovidPackage",
            dependencies: ["SwiftOTP", "TrustKit"]),
        .testTarget(
            name: "CovidPackageTests",
            dependencies: ["CovidPackage"]),
    ]
)
