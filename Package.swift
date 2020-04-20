// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppCenterSDK",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "AppCenter",
            targets: ["AppCenter"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "AppCenter",
            dependencies: [],         
            path: "AppCenter/AppCenter",
            cSettings: [
                .define("APP_CENTER_C_NAME", to: "\"appcenter.ios\""),
                .define("APP_CENTER_C_VERSION", to:"\"3.1.1\""),
                .define("APP_CENTER_C_BUILD", to:"\"1\""),
                .headerSearchPath("**"),
                .headerSearchPath("Model"),
                .headerSearchPath("Internals/**")
            ],
            linkerSettings: [
                .linkedLibrary("z"),
                .linkedLibrary("sqlite3"),
                .linkedFramework("Foundation"),
                .linkedFramework("SystemConfiguration"),
                .linkedFramework("AppKit", .when(platforms: [.macOS]))
            ]
        ),
    ]
)


