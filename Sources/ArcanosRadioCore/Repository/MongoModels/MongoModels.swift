import Foundation
import MongoKitten

protocol MongoModel {
    static var collectionName: String { get }
    init?(mongo document: Document)
}
