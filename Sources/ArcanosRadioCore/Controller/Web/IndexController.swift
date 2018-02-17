import Foundation
import Kitura
import KituraContracts

class IndexController {
    static func setupRoutes(app: App) {
        app.router.get("/admin", handler: index)
    }

    static func index(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        let context: [String: Any] = [
            "menu": MenuHelper.items
        ]

        try response.render("index", context: context).end()
        next()
    }
}
