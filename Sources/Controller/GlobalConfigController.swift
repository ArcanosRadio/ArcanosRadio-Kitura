import Foundation
import KituraContracts

class GlobalConfigController {
    static func setupRoutes(app: App) {
        // v1
        app.router.get("/parse/config", handler: V1.listOne)

        // v2
        app.router.get("/config", handler: V2.listOne)
    }
}

extension GlobalConfigController {
    class V2 {
        static func listOne(completion: @escaping (GlobalConfig, RequestError?) -> Void) {
            let repository = inject(Repository.self)
            let config = repository.getGlobalConfig()
            completion(config, nil)
        }
    }
}

extension GlobalConfigController {
    class V1 {
        static func listOne(completion: @escaping ([String: GlobalConfig], RequestError?) -> Void) {
            let repository = inject(Repository.self)
            let config = repository.getGlobalConfig()
            completion(["params": config], nil)
        }
    }
}

