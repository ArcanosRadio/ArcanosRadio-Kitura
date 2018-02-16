import CloudEnvironment
import Configuration
import Foundation
import Health
import Kitura
import KituraContracts
import KituraCORS
import LoggerAPI

public let projectPath = ConfigurationManager.BasePath.project.path
public let health = Health()

public class App {
    let router = Router()
    let cloudEnv = CloudEnv()

    public init() throws {
        // Run the metrics initializer
        initializeMetrics(router: router)
    }

    func postInit() throws {
        // Endpoints
        initializeHealthRoutes(app: self)
        ArtistController.setupRoutes(app: self)
        SongController.setupRoutes(app: self)
        PlaylistController.setupRoutes(app: self)
        GlobalConfigController.setupRoutes(app: self)

        let options = Options(allowedOrigin: .all)
        let cors = CORS(options: options)
        router.all("/*", middleware: cors)
    }

    public func run() throws {
        try postInit()
        Kitura.addHTTPServer(onPort: cloudEnv.port, with: router)
        Kitura.run()
    }
}
