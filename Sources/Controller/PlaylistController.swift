import Foundation
import KituraContracts

class PlaylistController {
    static func setupRoutes(app: App) {
        // v1
        let repository = inject(Repository.self)
        let url = repository.getGlobalConfig().serviceUrl
        app.router.post("/parse/classes/Playlist", handler: V1.current(url: url))

        // v2
        app.router.get("/playlist", handler: V2.byId)
        app.router.get("/playlist", handler: V2.list)
        app.router.get("/playlist/current", handler: V2.current)
    }
}

extension PlaylistController {
    class V2 {
        static func byId(id: StringIdentifier, completion: @escaping (Playlist?, RequestError?) -> Void) {
            let repository = inject(Repository.self)
            let playlist = repository.playlist(byId: id.value)
            completion(playlist, nil)
        }

        static func list(urlParams: PageURLParams, completion: @escaping ([Playlist]?, RequestError?) -> Void) {
            let repository = inject(Repository.self)
            let playlists = repository.listPlaylists(pageSize: urlParams.pageSize ?? 30,
                                                     page: urlParams.page ?? 0)
            completion(playlists, nil)
        }

        static func current(completion: @escaping (Playlist, RequestError?) -> Void) {
            let repository = inject(Repository.self)
            var playlist = repository.listPlaylists(pageSize: 1, page: 0).first!

            if let songId = playlist.song.key() {
                let song = repository.song(byId: songId)!
                playlist.song = .loaded(song)
            }

            var song = playlist.song.value()!
            if let artistId = song.artist.key() {
                let artist = repository.artist(byId: artistId)!
                song.artist = .loaded(artist)
                playlist.song = .loaded(song)
            }

            completion(playlist, nil)
        }
    }
}

extension PlaylistController {
    class V1 {
        typealias LegacyPlaylistJson = [String: [LegacyBridge<Playlist>]]
        typealias LegacyPlaylistCompletion = (LegacyPlaylistJson?, RequestError?) -> Void
        struct ParseRequest: Codable {
            let include: String?
            let order: String?
            let method: String?
            let limit: String?

            enum CodingKeys: String, CodingKey {
                case include, order, method = "_method", limit
            }
        }

        static func current(url: URL) -> (ParseRequest, @escaping LegacyPlaylistCompletion) -> Void {
            return { requestBody, completion in
                let repository = inject(Repository.self)
                var playlist = repository.listPlaylists(pageSize: 1, page: 0).first!

                if let songId = playlist.song.key() {
                    let song = repository.song(byId: songId)!
                    playlist.song = .loaded(song)
                }

                var song = playlist.song.value()!
                if let artistId = song.artist.key() {
                    let artist = repository.artist(byId: artistId)!
                    song.artist = .loaded(artist)
                    playlist.song = .loaded(song)
                }

                let filePath = "\(url)/parse/files/arcanosRadio/%@"
                completion(["results": [LegacyBridge(playlist, { PlaylistV1(filePath: filePath) })]], nil)
            }
        }
    }
}
