// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XCEvents",
    platforms: [
        .iOS(.v15),
        .macOS(.v10_15),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "XCEvents",
            targets: ["XCEvents"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk", .upToNextMajor(from: "12.4.0")),
        .package(url: "https://github.com/GameAnalytics/GA-SDK-IOS", .upToNextMajor(from: "5.0.0")),
    ],
    targets: [
        .target(
            name: "XCEvents",
            dependencies: [
                .product(name: "FirebaseCore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk"),
                .product(name: "FirebasePerformance", package: "firebase-ios-sdk"),
                .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                .product(name: "GameAnalytics", package: "GA-SDK-IOS")
            ]
        ),
        .testTarget(
            name: "XCEventsTests",
            dependencies: ["XCEvents"]
        ),
    ]
)
