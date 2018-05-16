import Foundation
import Kitura
import KituraContracts

class IndexController {
    static func setupRoutes(app: App) {
        app.router.get("/admin", handler: index)
    }

    static func index(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        defer { next() }

        let context: [String: Any] = [
            "menu": MenuHelper.forHref(request.route)
        ]

        try response.render("index", context: context).end()
    }
}
