import Foundation
import Kitura
import KituraContracts
import LoggerAPI

public class App {
    let router = Router()

    public init() throws {
    }

    func postInit() throws {
        // Endpoints
        ArtistAPIController.setupRoutes(app: self)
        SongAPIController.setupRoutes(app: self)
        PlaylistAPIController.setupRoutes(app: self)
        GlobalConfigAPIController.setupRoutes(app: self)
    }

    public func run() throws {
        try postInit()
        Kitura.addHTTPServer(onPort: Int(AppSettings.current.serverPort)!, with: router)
        Kitura.run()
    }

    let parseAuthenticationMiddleware = ParseAuthMiddleware()
}
