import Foundation
import MongoKitten

enum DocumentConvertionError: Error {
    case propertyNotFound
    case invalidConvertion
}

extension Document {
    func required<T, P>(_ property: P, converter: (Primitive) -> T?) throws -> T where P: MappingProtocol {
        let levels = property.rawValue.components(separatedBy: ".")
        return try required(levels: levels, converter: converter)
    }

    func required<T>(levels: [String], converter: (Primitive) -> T?) throws -> T {
        let currentLevel = levels.first!
        guard let propertyValue = self[currentLevel] else { throw DocumentConvertionError.propertyNotFound }

        if levels.count > 1 {
            guard let document = Document(propertyValue) else { throw DocumentConvertionError.invalidConvertion }
            return try document.required(levels: Array(levels.dropFirst()), converter: converter)
        } else {
            guard let value = converter(propertyValue) else { throw DocumentConvertionError.invalidConvertion }
            return value
        }
    }

    func optional<T, P>(_ property: P, converter: (Primitive) -> T?) -> T? where P: RawRepresentable, P.RawValue == String {
        guard let primitive = self[property.rawValue] else { return nil }
        return converter(primitive)
    }
}

extension URL {
    init?(value: Primitive) {
        guard let string = String(value) else { return nil }
        self.init(string: string)
    }
}
