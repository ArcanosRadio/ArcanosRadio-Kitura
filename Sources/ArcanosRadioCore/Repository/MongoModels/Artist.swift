import ArcanosRadioModel
import Foundation
import MongoKitten

extension Artist: MongoModel {
    static let collectionName = "Artist"

    init?(mongo document: Document) {
        do {
            self.id = Id(rawValue: try document.required(ArtistMapping.id, converter: String.init))!
            self.tags = (try document.required(ArtistMapping.tags, converter: Array.init)).flatMap { String($0) }
            self.name = try document.required(ArtistMapping.name, converter: String.init)
            self.createdAt = try document.required(ArtistMapping.createdAt, converter: Date.init)
            self.updatedAt = try document.required(ArtistMapping.updatedAt, converter: Date.init)
        } catch {
            return nil
        }

        self.url = document.optional(ArtistMapping.url, converter: URL.init)
        self.twitter = document.optional(ArtistMapping.twitter, converter: String.init)
    }
}
