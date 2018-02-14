//
//  Id.swift
//  ArcanosRadio-KituraPackageDescription
//
//  Created by Luiz Rodrigo Martins Barbosa on 14.02.18.
//

import Foundation

public struct Id<Entity> {
    private let id: String
}

extension Id: Hashable {
    public var hashValue: Int {
        return id.hashValue
    }

    public static func == (lhs: Id, rhs: Id) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Id: RawRepresentable {
    public init?(rawValue: String) {
        guard !rawValue.isEmpty else { return nil }
        self.id = rawValue
    }

    public var rawValue: String {
        return id
    }
}

extension Id: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let id = try container.decode(String.self)
        guard !id.isEmpty else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot initialize Id from an empty string"
            )
        }

        self.init(rawValue: id)!
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(id)
    }
}
