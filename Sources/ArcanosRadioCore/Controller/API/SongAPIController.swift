import ArcanosRadioModel
import Foundation
import Kitura
import KituraContracts

class SongAPIController {
    static func setupRoutes(app: App) {
        // v1
        app.router.get("/parse/files/arcanosRadio/:name", handler: V1.file)

        // v2
        app.router.get("/api/song", handler: V2.byId)
        app.router.get("/api/song", handler: V2.list)
        app.router.get("/api/albumArt/:name", handler: V2.file)
        app.router.get("/api/lyrics/:name", handler: V2.file)
    }
}

extension SongAPIController {
    class V2 {
        static func byId(id: StringIdentifier, completion: @escaping (Result<Song, RequestError>) -> Void) {
            let repository = inject(Repository.self)
            guard let song = repository.song(byId: id.value) else {
                completion(.failure(.notFound))
                return
            }

            completion(.success(song))
        }

        static func list(urlParams: PageURLParams, completion: @escaping (Result<[Song], RequestError>) -> Void) {
            let repository = inject(Repository.self)
            let songs = repository.listSongs(pageSize: urlParams.pageSize ?? 30,
                                             page: urlParams.page ?? 0)
            completion(.success(songs))
        }

        static func file(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
            defer { next() }

            guard let name = request.parameters["name"] else {
                _ = response.send(status: .badRequest)
                return
            }

            let fs = inject(FileRepository.self)
            guard let data = fs.file(byName: name) else {
                _ = response.send(status: .notFound)
                return
            }

            let contentType = ContentType.sharedInstance.getContentType(forFileName: name)
            if  let contentType = contentType {
                response.headers["Content-Type"] = contentType
            }

            response.statusCode = .OK
            response.send(data: data)
        }
    }
}

extension SongAPIController {
    class V1 {
        static func file(req: RouterRequest, resp: RouterResponse, next: @escaping () -> Void) throws {
            return try V2.file(request: req, response: resp, next: next)
        }
    }
}
