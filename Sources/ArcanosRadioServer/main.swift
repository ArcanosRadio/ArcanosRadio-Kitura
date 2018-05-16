import ArcanosRadioCore
import Foundation
import Kitura
import LoggerAPI

do {
    let envFilePath = URL(fileURLWithPath: #file)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .appendingPathComponent("config.json")

    AppSettings.current = AppSettings.current
        .merging(dictionary: ProcessInfo.processInfo.environment)
        .merging(file: envFilePath)

    let app = try App()
    try app.run()

} catch let error {
    Log.error(error.localizedDescription)
}
