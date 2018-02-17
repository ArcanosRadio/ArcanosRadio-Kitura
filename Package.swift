// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "ArcanosRadioServer",
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/Kitura.git", .branch("master")),
        .package(url: "https://github.com/OpenKitten/MongoKitten.git", from: "4.0.0"),
        .package(url: "https://github.com/IBM-Swift/Kitura-StencilTemplateEngine.git", .upToNextMinor(from: "1.8.4"))
    ],
    targets: [
        .target(name: "ArcanosRadioModel"),
        .target(name: "ArcanosRadioCore",
                dependencies: [ "Kitura", "MongoKitten", .target(name: "ArcanosRadioModel") ]),
        .target(name: "ArcanosRadioServer",
                dependencies: [ "Kitura", .target(name: "ArcanosRadioCore") ]),
        .testTarget(name: "ApplicationTests",
                    dependencies: [ "Kitura", .target(name: "ArcanosRadioCore"), .target(name: "ArcanosRadioModel") ])
    ]
)
