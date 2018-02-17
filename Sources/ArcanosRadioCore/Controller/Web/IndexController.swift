import Foundation
import Kitura
import KituraContracts

class IndexController {
    static func setupRoutes(app: App) {
        app.router.get("/", handler: index)
    }

    static func index(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        var context2 = [
            "articles": [
                ["title": "Migrating from OCUnit to XCTest", "author": "Kyle Fuller"],
                ["title": "Memory Management with ARC", "author": "Kyle Fuller" ]
            ]
        ]

        try response.render("index", context: context2).end()
        next()
    }
}

