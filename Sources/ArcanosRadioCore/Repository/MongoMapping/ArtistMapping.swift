import ArcanosRadioModel
import Foundation

enum ArtistMapping: String, MappingProtocol {
    typealias Entity = Artist

    case id = "_id"
    case tags
    case name = "artistName"
    case createdAt = "_created_at"
    case updatedAt = "_updated_at"
    case url
    case twitter = "twitterTimeline"
}
