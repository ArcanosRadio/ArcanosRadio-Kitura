import Foundation
import Kitura
import KituraStencil
import KituraTemplateEngine

public class App {
    let router = Router()

    public init() throws {
    }

    func postInit() throws {
        // Auth
        ParseAuthMiddleware.configure("/parse/:path*", app: self)

        // API Endpoints
        ArtistAPIController.setupRoutes(app: self)
        SongAPIController.setupRoutes(app: self)
        PlaylistAPIController.setupRoutes(app: self)
        GlobalConfigAPIController.setupRoutes(app: self)

        // Web Endpoints
        IndexController.setupRoutes(app: self)

        // Static
        router.all("/static", middleware: StaticFileServer(path: "./static"))
        router.setDefault(templateEngine: StencilTemplateEngine())
    }

    public func run() throws {
        try postInit()
        Kitura.addHTTPServer(onPort: Int(AppSettings.current.serverPort)!, with: router)
        Kitura.run()
    }
}
