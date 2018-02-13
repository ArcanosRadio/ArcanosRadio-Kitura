import Foundation
import KituraContracts

class PlaylistController {
    static func setupRoutes(app: App) {
        app.router.get("/playlist", handler: byId)
        app.router.get("/playlist", handler: list)
        app.router.get("/playlist/current", handler: current)
    }

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

