import Foundation
import Kitura
import KituraContracts
import KituraNet
import LoggerAPI

class HttpEncoder {
    static var `default` = JSONEncoder()
}

// MARK: - Public GET
extension Router {
    // GET
    public func get<O: Codable>(_ route: String, handler: @escaping CodableArrayClosureEx<O>) {
        getSafely(route, handler: handler)
    }

    public func get<O: Codable>(_ route: String, handler: @escaping SimpleCodableClosureEx<O>) {
        getSafely(route, handler: handler)
    }

    public func get<Id: Identifier, O: Codable>(_ route: String, handler: @escaping IdentifierSimpleCodableClosureEx<Id, O>) {
        getSafely(route, handler: handler)
    }

    public func get<Q: QueryParams, O: Codable>(_ route: String, handler: @escaping (Q, @escaping CodableArrayResultClosureEx<O>) -> Void) {
        getSafely(route, handler: handler)
    }
}

// MARK: - Public POST
extension Router {
    public func post<I: Codable, O: Codable>(_ route: String, handler: @escaping CodableClosureEx<I, O>) {
        postSafely(route, handler: handler)
    }

    public func post<I: Codable, Id: Identifier, O: Codable>(_ route: String, handler: @escaping CodableIdentifierClosureEx<I, Id, O>) {
        postSafelyWithId(route, handler: handler)
    }
}

// MARK: - Public PUT
extension Router {
    public func put<Id: Identifier, I: Codable, O: Codable>(_ route: String, handler: @escaping IdentifierCodableClosureEx<Id, I, O>) {
        putSafely(route, handler: handler)
    }
}

// MARK: - Public PATCH
extension Router {
    public func patch<Id: Identifier, I: Codable, O: Codable>(_ route: String, handler: @escaping IdentifierCodableClosureEx<Id, I, O>) {
        patchSafely(route, handler: handler)
    }
}

// MARK: - Private POST
extension Router {
    private func postSafely<I: Codable, O: Codable>(_ route: String, handler: @escaping CodableClosureEx<I, O>) {
        post(route) { request, response, next in
            Log.verbose("Received POST type-safe request")
            guard self.isContentTypeJson(request) else {
                response.status(.unsupportedMediaType)
                next()
                return
            }
            guard !request.hasBodyParserBeenUsed else {
                Log.error("No data in request. Codable routes do not allow the use of a BodyParser.")
                response.status(.internalServerError)
                return
            }
            do {
                // Process incoming data from client
                let param = try request.read(as: I.self)

                // Define handler to process result from application
                let resultHandler: CodableResultClosureEx<O> = { result in
                    do {
                        switch result {
                        case let .failure(error):
                            let status = self.httpStatusCode(from: error)
                            response.status(status)
                        case let .success(content):
                            let encoded = try HttpEncoder.default.encode(content)
                            response.status(.created)
                            response.headers.setType("json")
                            response.send(data: encoded)
                        }
                    } catch {
                        // Http 500 error
                        response.status(.internalServerError)
                    }
                    next()

                }
                // Invoke application handler
                handler(param, resultHandler)
            } catch {
                // Http 400 error
                //response.status(.badRequest)
                // Http 422 error
                response.status(.unprocessableEntity)
                next()
            }
        }
    }

    private func postSafelyWithId<I: Codable, Id: Identifier, O: Codable>(
        _ route: String, handler: @escaping CodableIdentifierClosureEx<I, Id, O>) {
        post(route) { request, response, next in
            Log.verbose("Received POST type-safe request")
            guard self.isContentTypeJson(request) else {
                response.status(.unsupportedMediaType)
                next()
                return
            }
            guard !request.hasBodyParserBeenUsed else {
                Log.error("No data in request. Codable routes do not allow the use of a BodyParser.")
                response.status(.internalServerError)
                return
            }
            do {
                // Process incoming data from client
                let param = try request.read(as: I.self)

                // Define handler to process result from application
                let resultHandler: IdentifierCodableResultClosureEx<Id, O> = { id, result in
                    do {
                        switch result {
                        case let .failure(error):
                            let status = self.httpStatusCode(from: error)
                            response.status(status)
                        case let .success(content):
                            guard let id = id else {
                                Log.error("No id (unique identifier) value provided.")
                                response.status(.internalServerError)
                                next()
                                return
                            }
                            let encoded = try HttpEncoder.default.encode(content)
                            response.status(.created)
                            response.headers["Location"] = id.value
                            response.headers.setType("json")
                            response.send(data: encoded)
                        }
                    } catch {
                        // Http 500 error
                        response.status(.internalServerError)
                    }
                    next()
                }
                // Invoke application handler
                handler(param, resultHandler)
            } catch {
                // Http 422 error
                response.status(.unprocessableEntity)
                next()
            }
        }
    }
}

// MARK: - Private PUT
extension Router {
    // PUT with Identifier
    private func putSafely<Id: Identifier, I: Codable, O: Codable>(_ route: String, handler: @escaping IdentifierCodableClosureEx<Id, I, O>) {
        if parameterIsPresent(in: route) {
            return
        }
        put(join(path: route, with: ":id")) { request, response, next in
            Log.verbose("Received PUT type-safe request")
            guard self.isContentTypeJson(request) else {
                response.status(.unsupportedMediaType)
                next()
                return
            }
            guard !request.hasBodyParserBeenUsed else {
                Log.error("No data in request. Codable routes do not allow the use of a BodyParser.")
                response.status(.internalServerError)
                return
            }
            do {
                // Process incoming data from client
                let id = request.parameters["id"] ?? ""
                let identifier = try Id(value: id)
                let param = try request.read(as: I.self)

                let resultHandler: CodableResultClosureEx<O> = { result in
                    do {
                        switch result {
                        case let .failure(error):
                            let status = self.httpStatusCode(from: error)
                            response.status(status)
                        case let .success(content):
                            let encoded = try HttpEncoder.default.encode(content)
                            response.status(.OK)
                            response.headers.setType("json")
                            response.send(data: encoded)
                        }
                    } catch {
                        // Http 500 error
                        response.status(.internalServerError)
                    }
                    next()
                }
                // Invoke application handler
                handler(identifier, param, resultHandler)
            } catch {
                response.status(.unprocessableEntity)
                next()
            }
        }
    }
}

// MARK: - Private PATCH
extension Router {
    // PATCH
    private func patchSafely<Id: Identifier, I: Codable, O: Codable>(_ route: String, handler: @escaping IdentifierCodableClosureEx<Id, I, O>) {
        if parameterIsPresent(in: route) {
            return
        }
        patch(join(path: route, with: ":id")) { request, response, next in
            Log.verbose("Received PATCH type-safe request")
            guard self.isContentTypeJson(request) else {
                response.status(.unsupportedMediaType)
                next()
                return
            }
            guard !request.hasBodyParserBeenUsed else {
                Log.error("No data in request. Codable routes do not allow the use of a BodyParser.")
                response.status(.internalServerError)
                return
            }
            do {
                // Process incoming data from client
                let id = request.parameters["id"] ?? ""
                let identifier = try Id(value: id)
                let param = try request.read(as: I.self)

                // Define handler to process result from application
                let resultHandler: CodableResultClosureEx<O> = { result in
                    do {
                        switch result {
                        case let .failure(error):
                            let status = self.httpStatusCode(from: error)
                            response.status(status)
                        case let .success(content):
                            let encoded = try HttpEncoder.default.encode(content)
                            response.status(.OK)
                            response.headers.setType("json")
                            response.send(data: encoded)
                        }
                    } catch {
                        // Http 500 error
                        response.status(.internalServerError)
                    }
                    next()
                }
                // Invoke application handler
                handler(identifier, param, resultHandler)
            } catch {
                // Http 422 error
                response.status(.unprocessableEntity)
                next()
            }
        }
    }
}

// MARK: - Private GET
extension Router {
    // Get single
    private func getSafely<O: Codable>(_ route: String, handler: @escaping SimpleCodableClosureEx<O>) {
        get(route) { _, response, next in
            Log.verbose("Received GET (single no-identifier) type-safe request")
            // Define result handler
            let resultHandler: CodableResultClosureEx<O> = { result in
                do {
                    switch result {
                    case let .failure(error):
                        let status = self.httpStatusCode(from: error)
                        response.status(status)
                    case let .success(content):
                        let encoded = try HttpEncoder.default.encode(content)
                        response.status(.OK)
                        response.headers.setType("json")
                        response.send(data: encoded)
                    }
                } catch {
                    // Http 500 error
                    response.status(.internalServerError)
                }
                next()
            }
            handler(resultHandler)
        }
    }

    // Get array
    private func getSafely<O: Codable>(_ route: String, handler: @escaping CodableArrayClosureEx<O>) {
        get(route) { _, response, next in
            Log.verbose("Received GET (plural) type-safe request")
            // Define result handler
            let resultHandler: CodableArrayResultClosureEx<O> = { result in
                do {
                    switch result {
                    case let .failure(error):
                        let status = self.httpStatusCode(from: error)
                        response.status(status)
                    case let .success(content):
                        let encoded = try HttpEncoder.default.encode(content)
                        response.status(.OK)
                        response.headers.setType("json")
                        response.send(data: encoded)
                    }
                } catch {
                    // Http 500 error
                    response.status(.internalServerError)
                }
                next()
            }
            handler(resultHandler)
        }
    }

    // Get w/Query Parameters
    private func getSafely<Q: QueryParams, O: Codable>(
        _ route: String,
        handler: @escaping (Q, @escaping CodableArrayResultClosureEx<O>) -> Void) {
        get(route) { request, response, next in
            Log.verbose("Received GET (plural) type-safe request with Query Parameters")
            // Define result handler
            let resultHandler: CodableArrayResultClosureEx<O> = { result in
                do {
                    switch result {
                    case let .failure(error):
                        let status = self.httpStatusCode(from: error)
                        response.status(status)
                    case let .success(content):
                        let encoded = try HttpEncoder.default.encode(content)
                        response.status(.OK)
                        response.headers.setType("json")
                        response.send(data: encoded)
                    }
                } catch {
                    // Http 500 error
                    response.status(.internalServerError)
                }
                next()
            }
            Log.verbose("Query Parameters: \(request.queryParameters)")
            do {
                let query: Q = try QueryDecoder(dictionary: request.queryParameters).decode(Q.self)
                handler(query, resultHandler)
            } catch {
                // Http 400 error
                response.status(.badRequest)
                next()
            }
        }
    }

    // GET single identified element
    private func getSafely<Id: Identifier, O: Codable>(_ route: String, handler: @escaping IdentifierSimpleCodableClosureEx<Id, O>) {
        if parameterIsPresent(in: route) {
            return
        }
        get(join(path: route, with: ":id")) { request, response, next in
            Log.verbose("Received GET (singular with identifier) type-safe request")
            do {
                // Define result handler
                let resultHandler: CodableResultClosureEx<O> = { result in
                    do {
                        switch result {
                        case let .failure(error):
                            let status = self.httpStatusCode(from: error)
                            response.status(status)
                        case let .success(content):
                            let encoded = try HttpEncoder.default.encode(content)
                            response.status(.OK)
                            response.headers.setType("json")
                            response.send(data: encoded)
                        }
                    } catch {
                        // Http 500 error
                        response.status(.internalServerError)
                    }
                    next()
                }
                // Process incoming data from client
                let id = request.parameters["id"] ?? ""
                let identifier = try Id(value: id)
                handler(identifier, resultHandler)
            } catch {
                // Http 422 error
                response.status(.unprocessableEntity)
                next()
            }
        }
    }
}

// MARK: - Private Helpers
extension Router {
    private func parameterIsPresent(in route: String) -> Bool {
        if route.contains(":") {
            let paramaterString = route.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: false)
            let parameter = !paramaterString.isEmpty ? paramaterString[1] : ""
            Log.error("Erroneous path '\(route)', parameter ':\(parameter)' is not allowed. Codable routes do not allow parameters.")
            return true
        }
        return false
    }

    private func isContentTypeJson(_ request: RouterRequest) -> Bool {
        guard let contentType = request.headers["Content-Type"] else {
            return false
        }
        return (contentType.hasPrefix("application/json"))
    }

    private func httpStatusCode(from error: RequestError) -> HTTPStatusCode {
        let status: HTTPStatusCode = HTTPStatusCode(rawValue: error.rawValue) ?? .unknown
        return status
    }

    private func join(path base: String, with component: String) -> String {
        let strippedBase = base.hasSuffix("/") ? String(base.dropLast()) : base
        let strippedComponent = component.hasPrefix("/") ? String(component.dropFirst()) : component
        return "\(strippedBase)/\(strippedComponent)"
    }
}
