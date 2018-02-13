import Foundation
import Kitura
import KituraContracts

class SongController {
    static func setupRoutes(app: App) {
        app.router.get("/song", handler: byId)
        app.router.get("/song", handler: list)
        app.router.get("/lyrics/:name", handler: lyrics)
        app.router.get("/albumArt/:name", handler: albumArt)
    }

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

    static func lyrics(req: RouterRequest, resp: RouterResponse, next: @escaping () -> Void) throws {
        guard let data = file(req: req, resp: resp, next: next) else { return }

        guard let lyrics = String(data: data, encoding: .utf8) else {
            _ = resp.send(status: .noContent)
            next()
            return
        }

        resp.send(lyrics)
        resp.statusCode = .OK
        next()
    }

    static func albumArt(req: RouterRequest, resp: RouterResponse, next: @escaping () -> Void) throws {
        guard let data = file(req: req, resp: resp, next: next) else { return }

        resp.headers["Content-Type"] = "image/jpeg"
        resp.send(data: data)
        resp.statusCode = .OK
        next()
    }

    private static func file(req: RouterRequest, resp: RouterResponse, next: @escaping () -> Void) -> Data? {
        guard let name = req.parameters["name"] else {
            _ = resp.send(status: .badRequest)
            next()
            return nil
        }

        let fs = inject(FileRepository.self)
        guard let data = fs.lyrics(byName: name) else {
            _ = resp.send(status: .notFound)
            next()
            return nil
        }

        return data
    }
}
