// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "InjectableLoggers",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(name: "InjectableLoggers", targets: ["InjectableLoggers"])
    ],
    targets: [
        .target(
            name: "InjectableLoggers",
            path: "InjectableLoggers"
        )
    ],
    swiftLanguageVersions: [.v5]
)
