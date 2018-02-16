//
//  ParseAuthMiddleware.swift
//  Application
//
//  Created by Luiz Rodrigo Martins Barbosa on 16.02.18.
//

import Foundation
import Kitura

class ParseAuthMiddleware: RouterMiddleware {
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
