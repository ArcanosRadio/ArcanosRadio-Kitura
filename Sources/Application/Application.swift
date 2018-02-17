import Foundation
import Kitura
import KituraTemplateEngine

public class App {
    let router = Router()

    public init() throws {
    }

    func postInit() throws {
        // Auth
        ParseAuthMiddleware.configure("/parse/:path*", app: self)
        
        // Endpoints
        ArtistAPIController.setupRoutes(app: self)
        SongAPIController.setupRoutes(app: self)
        PlaylistAPIController.setupRoutes(app: self)
        GlobalConfigAPIController.setupRoutes(app: self)

        // Static
        router.all("/static", middleware: StaticFileServer(path: "./static"))
    }

    public func run() throws {
        try postInit()
        Kitura.addHTTPServer(onPort: Int(AppSettings.current.serverPort)!, with: router)
        Kitura.run()
    }
}
