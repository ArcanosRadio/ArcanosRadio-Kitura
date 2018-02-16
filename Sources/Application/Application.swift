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
        ArtistController.setupRoutes(app: self)
        SongController.setupRoutes(app: self)
        PlaylistController.setupRoutes(app: self)
        GlobalConfigController.setupRoutes(app: self)
    }

    public func run() throws {
        try postInit()
        Kitura.addHTTPServer(onPort: 8080, with: router)
        Kitura.run()
    }

    let parseAuthenticationMiddleware = ParseAuthMiddleware()
}
