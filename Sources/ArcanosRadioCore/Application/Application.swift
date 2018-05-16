import Foundation
import Kitura

public class App {
    let router = Router()

    public init() throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        HttpEncoder.default = encoder
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
        Template.setupTemplates(app: self)
    }

    public func run() throws {
        try postInit()
        Kitura.addHTTPServer(onPort: Int(AppSettings.current.serverPort)!, with: router)
        Kitura.run()
    }
}
