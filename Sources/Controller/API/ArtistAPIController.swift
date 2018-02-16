import Foundation
import KituraContracts

class ArtistAPIController {
    static func setupRoutes(app: App) {
        app.router.get("/api/artist", handler: byId)
        app.router.get("/api/artist", handler: list)
    }

    static func byId(id: StringIdentifier, completion: @escaping (Artist?, RequestError?) -> Void) {
        let repository = inject(Repository.self)
        let artist = repository.artist(byId: id.value)
        completion(artist, nil)
    }

    static func list(urlParams: PageURLParams, completion: @escaping ([Artist]?, RequestError?) -> Void) {
        let repository = inject(Repository.self)
        let artists = repository.listArtists(pageSize: urlParams.pageSize ?? 30,
                                             page: urlParams.page ?? 0)
        completion(artists, nil)
    }
}
