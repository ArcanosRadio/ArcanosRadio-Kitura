import Foundation

public struct Artist: Codable {
    public let id: Id<Artist>
    public let tags: [String]
    public let name: String
    public let createdAt: Date
    public let updatedAt: Date
    public let url: URL?
    public let twitter: String?
}

extension Artist: Equatable {
    public static func == (lhs: Artist, rhs: Artist) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.tags == rhs.tags &&
            lhs.name == rhs.name &&
            lhs.createdAt == rhs.createdAt &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.url == rhs.url &&
            lhs.twitter == rhs.twitter
    }
}
