import ArcanosRadioModel
import Foundation

enum SongMapping: String, MappingProtocol {
    typealias Entity = Song

    case id = "_id"
    case tags
    case name = "songName"
    case artist = "_p_artist"
    case albumArt
    case albumArtState
    case lyrics
    case lyricsState
    case createdAt = "_created_at"
    case updatedAt = "_updated_at"
    case hasRightsContract
}
