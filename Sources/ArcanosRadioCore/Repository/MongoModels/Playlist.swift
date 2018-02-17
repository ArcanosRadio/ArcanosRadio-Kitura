import ArcanosRadioModel
import Foundation
import MongoKitten

extension Playlist: MongoModel {
    static let collectionName = "Playlist"

    init?(mongo document: Document) {
        do {
            self.id = Id(rawValue: try document.required(PlaylistMapping.id, converter: String.init))!
            self.title = try document.required(PlaylistMapping.title, converter: String.init)
            self.song = .notLoaded((try document.required(PlaylistMapping.song, converter: String.init)).components(separatedBy: "$")[1])
            self.createdAt = try document.required(PlaylistMapping.createdAt, converter: Date.init)
            self.updatedAt = try document.required(PlaylistMapping.updatedAt, converter: Date.init)
        } catch {
            return nil
        }
    }
}
