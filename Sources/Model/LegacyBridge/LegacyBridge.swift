//
//  LegacyBridge.swift
//  Application
//
//  Created by Luiz Rodrigo Martins Barbosa on 14.02.18.
//

import Foundation

class LegacyBridge<T: Codable>: Codable {
    let entity: T
    private var customEncoder: ((T, Encoder) throws -> Void)?

    init(_ entity: T) {
        self.entity = entity
    }

    init<X>(_ entity: T, _ customEncoder: () -> X) where X: CustomEncoder, X.Entity == T {
        self.entity = entity
        self.customEncoder = customEncoder().encode
    }

    required init(from decoder: Decoder) throws {
        entity = try T(from: decoder)
    }

    func encode(to encoder: Encoder) throws {
        if let customEncoder = customEncoder {
            try customEncoder(entity, encoder)
        } else {
            try entity.encode(to: encoder)
        }
    }
}

protocol CustomEncoder {
    associatedtype Entity
    func encode(entity: Entity, encoder: Encoder) throws
}
