// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "E2ETesting",
    platforms: [.macOS(.v15), .iOS(.v18)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "E2ETesting",
            targets: ["E2ETesting"]
        ),
        .executable(
            name: "E2ETestingClient",
            targets: ["E2ETestingClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "602.0.0-latest"),
        .package(url: "https://github.com/swiftlang/swift-markdown", .upToNextMajor(from: "0.7.3")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        // Macro implementation that performs the source transformation of a macro.
        .macro(
            name: "E2ETestingMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),

        // Library that exposes a macro as part of its API, which is used in client programs.
        .target(
            name: "E2ETesting",
            dependencies: [
                "E2ETestingMacros",
                .product(name: "Markdown", package: "swift-markdown"),
            ],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),

        // A client of the library, which is able to use the macro in its own code.
        .executableTarget(name: "E2ETestingClient", dependencies: ["E2ETesting"], swiftSettings: [.swiftLanguageMode(.v6)]),

        // A test target used to develop the macro implementation.
        .testTarget(
            name: "E2ETestingTests",
            dependencies: [
                "E2ETesting"
            ]
        ),
    ]
)
