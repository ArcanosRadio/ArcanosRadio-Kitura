//
//  DocumentExtensions.swift
//  Application
//
//  Created by Luiz Rodrigo Martins Barbosa on 13.02.18.
//

import Foundation
import MongoKitten

enum DocumentConvertionError: Error {
    case propertyNotFound
    case invalidConvertion
}

extension Document {
    func required<T, P>(_ property: P, converter: (Primitive) -> T?) throws -> T where P: MappingProtocol {
        guard let primitive = self[property.rawValue] else { throw DocumentConvertionError.propertyNotFound }
        guard let value = converter(primitive) else { throw DocumentConvertionError.invalidConvertion }

        return value
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
