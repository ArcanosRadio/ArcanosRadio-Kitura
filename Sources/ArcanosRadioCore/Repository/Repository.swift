import Foundation
import ArcanosRadioModel

protocol Repository {
    func artist(byId id: String) -> Artist?
    func listArtists(pageSize: Int, page: Int) -> [Artist]
    func song(byId id: String) -> Song?
    func listSongs(pageSize: Int, page: Int) -> [Song]
    func playlist(byId id: String) -> Playlist?
    func listPlaylists(pageSize: Int, page: Int) -> [Playlist]
    func getGlobalConfig() -> GlobalConfig
}
