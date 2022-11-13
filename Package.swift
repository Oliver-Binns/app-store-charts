// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "AppStoreCharts",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/1024jp/GzipSwift.git", branch: "develop"),
        .package(url: "https://github.com/AvdLee/appstoreconnect-swift-sdk.git", from: "2.2.0")
    ],
    targets: [
        .executableTarget(
            name: "AppStoreCharts",
            dependencies: [
                .product(name: "AppStoreConnect-Swift-SDK",
                         package: "appstoreconnect-swift-sdk"),
                .product(name: "Gzip", package: "GzipSwift")
            ],
            path: "Sources"
        )
    ]
)
