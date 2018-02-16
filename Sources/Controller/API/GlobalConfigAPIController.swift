import Foundation
import KituraContracts

class GlobalConfigAPIController {
    static func setupRoutes(app: App) {
        // v1
        app.router.get("/parse/config", allowPartialMatch: false, middleware: app.parseAuthenticationMiddleware)
        app.router.get("/parse/config", handler: V1.listOne)

        // v2
        app.router.get("/api/config", handler: V2.listOne)
    }
}

extension GlobalConfigAPIController {
    class V2 {
        static func listOne(completion: @escaping (GlobalConfig, RequestError?) -> Void) {
            let repository = inject(Repository.self)
            let config = repository.getGlobalConfig()
            completion(config, nil)
        }
    }
}

extension GlobalConfigAPIController {
    class V1 {
        static func listOne(completion: @escaping ([String: GlobalConfig], RequestError?) -> Void) {
            let repository = inject(Repository.self)
            let config = repository.getGlobalConfig()
            completion(["params": config], nil)
        }
    }
}

