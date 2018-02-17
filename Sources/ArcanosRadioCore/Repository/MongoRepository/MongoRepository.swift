import ArcanosRadioModel
import Foundation
import MongoKitten
import MongoSocket

class MongoRepository {
    private let db: Database
    private let fs: GridFS
    static let shared = try! MongoRepository()

    private init() throws {
        db = try MongoKitten.Database(AppSettings.current.mongoUrl)
        fs = try db.makeGridFS()
    }

    func single<T>(id: String) -> T? where T: MongoModel {
        let results = try? db[T.collectionName].findOne(Query(aqt: .valEquals(key: "_id", val: id)))
        return results?.flatMap(T.init(mongo:))
    }

    func list<T, P>(pageSize: Int, page: Int, sort: [P: SortOrder]) -> [T] where T: MongoModel, P: RawRepresentable, P.RawValue == String {
        let results = try? db[T.collectionName].find(
            sortedBy: sort.reduce(Sort()) { acc, keyValue in
                let (key, value) = keyValue
                var result = acc
                result[key.rawValue] = value
                return result
            },
            skipping: pageSize * page,
            limitedTo: pageSize)
        return results?.flatMap(T.init(mongo:)) ?? []
    }
}

extension MongoRepository: Repository {
    func artist(byId id: String) -> Artist? {
        return single(id: id)
    }

    func listArtists(pageSize: Int, page: Int) -> [Artist] {
        return list(pageSize: pageSize, page: page, sort: [ArtistMapping.name: .ascending])
    }

    func song(byId id: String) -> Song? {
        return single(id: id)
    }

    func listSongs(pageSize: Int, page: Int) -> [Song] {
        return list(pageSize: pageSize, page: page, sort: [SongMapping.name: .ascending])
    }

    func playlist(byId id: String) -> Playlist? {
        return single(id: id)
    }

    func listPlaylists(pageSize: Int, page: Int) -> [Playlist] {
        return list(pageSize: pageSize, page: page, sort: [PlaylistMapping.createdAt: .descending])
    }

    func getGlobalConfig() -> GlobalConfig {
        return list(pageSize: 1, page: 0, sort: [GlobalConfigMapping.id: .ascending]).first!
    }
}

extension MongoRepository: FileRepository {
    func file(byName name: String) -> Data? {
        do {
            let query = try fs.find(.init(aqt: .valEquals(key: "filename", val: name)))
            guard let file = query.next() else { return nil }
            let bytes = try file.read()
            return Data(bytes: bytes)
        } catch { return nil }
    }
}
