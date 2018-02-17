import ArcanosRadioModel
import Foundation

enum PlaylistMapping: String, MappingProtocol {
    typealias Entity = Playlist

    case id = "_id"
    case title
    case song = "_p_song"
    case createdAt = "_created_at"
    case updatedAt = "_updated_at"
}
