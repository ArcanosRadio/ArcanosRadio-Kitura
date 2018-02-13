// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "ArcanosRadio-Kitura",
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/Kitura.git", .branch("master")),
        .package(url: "https://github.com/IBM-Swift/HeliumLogger.git", .branch("master")),
        .package(url: "https://github.com/IBM-Swift/CloudEnvironment.git", .branch("master")),
        .package(url: "https://github.com/RuntimeTools/SwiftMetrics.git", .branch("master")),
        .package(url: "https://github.com/IBM-Swift/Health.git", .branch("master")),
        .package(url: "https://github.com/IBM-Swift/CommonCrypto.git", .branch("master")),
        .package(url: "https://github.com/IBM-Swift/Kitura-CORS", .branch("master")),
        .package(url: "https://github.com/OpenKitten/MongoKitten.git", from: "4.0.0")
    ],
    targets: [
        .target(name: "ArcanosRadio-Kitura", dependencies: [ .target(name: "Application"), "Kitura" , "HeliumLogger"]),
        .target(name: "Application", dependencies: [
            "Kitura",
            "KituraCORS",
            "CloudEnvironment",
            "SwiftMetrics",
            "MongoKitten",
            "Health"
        ]),
        .testTarget(name: "ApplicationTests" , dependencies: [.target(name: "Application"), "Kitura","HeliumLogger" ])
    ]
)
