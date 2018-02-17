// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "ArcanosRadio-Kitura",
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/Kitura.git", .branch("master")),
        .package(url: "https://github.com/OpenKitten/MongoKitten.git", from: "4.0.0"),
        .package(url: "https://github.com/IBM-Swift/Kitura-StencilTemplateEngine.git", .upToNextMinor(from: "1.8.4"))
    ],
    targets: [
        .target(name: "Application",
                dependencies: [ "Kitura",
                                "MongoKitten" ]),
        .target(name: "ArcanosRadio-Kitura",
                dependencies: [ .target(name: "Application"),
                                "Kitura" ]),
        .testTarget(name: "ApplicationTests",
                    dependencies: [ .target(name: "Application"),
                                    "Kitura" ])
    ]
)
