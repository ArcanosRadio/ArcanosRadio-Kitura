import Foundation
import Kitura

class ParseAuthMiddleware: RouterMiddleware {

    static func configure(_ path: String, app: App) {
        app.router.all(path, allowPartialMatch: true, middleware: ParseAuthMiddleware())
    }

    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        guard request.headers["X-Parse-Application-Id"] == AppSettings.current.parseApplicationId,
            request.headers["X-Parse-Client-Key"] == AppSettings.current.parseClientKey
            else {
                response.send(json: ["error": "unauthorized"])
                response.status(.forbidden)
                return
        }
        next()
    }
}
