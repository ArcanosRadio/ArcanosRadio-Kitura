import Foundation
import Kitura
import KituraContracts

class SongAPIController {
    static func setupRoutes(app: App) {
        // v1
        app.router.get("/parse/files/arcanosRadio/:name", allowPartialMatch: false, middleware: app.parseAuthenticationMiddleware)
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
        static func byId(id: StringIdentifier, completion: @escaping (Song?, RequestError?) -> Void) {
            let repository = inject(Repository.self)
            let song = repository.song(byId: id.value)
            completion(song, nil)
        }

        static func list(urlParams: PageURLParams, completion: @escaping ([Song]?, RequestError?) -> Void) {
            let repository = inject(Repository.self)
            let songs = repository.listSongs(pageSize: urlParams.pageSize ?? 30,
                                             page: urlParams.page ?? 0)
            completion(songs, nil)
        }

        static func file(req: RouterRequest, resp: RouterResponse, next: @escaping () -> Void) throws {
            guard let name = req.parameters["name"] else {
                _ = resp.send(status: .badRequest)
                next()
                return
            }

            let fs = inject(FileRepository.self)
            guard let data = fs.file(byName: name) else {
                _ = resp.send(status: .notFound)
                next()
                return
            }

            let contentType = ContentType.sharedInstance.getContentType(forFileName: name)
            if  let contentType = contentType {
                resp.headers["Content-Type"] = contentType
            }

            resp.statusCode = .OK
            resp.send(data: data)
            next()
        }
    }
}

extension SongAPIController {
    class V1 {
        static func file(req: RouterRequest, resp: RouterResponse, next: @escaping () -> Void) throws {
            return try V2.file(req: req, resp: resp, next: next)
        }
    }
}
