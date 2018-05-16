import Foundation

public class LegacyBridge<T: Codable>: Codable {
    let entity: T
    private var customEncoder: ((T, Encoder) throws -> Void)?

    public init(_ entity: T) {
        self.entity = entity
    }

    public init<X>(_ entity: T, _ customEncoder: () -> X) where X: CustomEncoder, X.Entity == T {
        self.entity = entity
        self.customEncoder = customEncoder().encode
    }

    required public init(from decoder: Decoder) throws {
        entity = try T(from: decoder)
    }

    public func encode(to encoder: Encoder) throws {
        if let customEncoder = customEncoder {
            try customEncoder(entity, encoder)
        } else {
            try entity.encode(to: encoder)
        }
    }
}

public protocol CustomEncoder {
    associatedtype Entity
    func encode(entity: Entity, encoder: Encoder) throws
}
