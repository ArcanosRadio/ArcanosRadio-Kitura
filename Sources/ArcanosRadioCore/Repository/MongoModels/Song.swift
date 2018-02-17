import Foundation
import MongoKitten
import ArcanosRadioModel

extension Song: MongoModel {
    static let collectionName = "Song"

    init?(mongo document: Document) {
        do {
            self.id = Id(rawValue: try document.required(SongMapping.id, converter: String.init))!
            self.tags = (try document.required(SongMapping.tags, converter: Array.init)).flatMap { String($0) }
            self.name = try document.required(SongMapping.name, converter: String.init)
            self.createdAt = try document.required(SongMapping.createdAt, converter: Date.init)
            self.updatedAt = try document.required(SongMapping.updatedAt, converter: Date.init)
            self.hasRightsContract = try document.required(SongMapping.hasRightsContract, converter: Bool.init)
            self.artist = .notLoaded((try document.required(SongMapping.artist, converter: String.init)).components(separatedBy: "$")[1])
        } catch {
            return nil
        }

        self.albumArt = document.optional(SongMapping.albumArt, converter: String.init)
        self.albumArtState = document.optional(SongMapping.albumArtState, converter: Int.init)
        self.lyrics = document.optional(SongMapping.lyrics, converter: String.init)
        self.lyricsState = document.optional(SongMapping.lyricsState, converter: Int.init)
    }
}
