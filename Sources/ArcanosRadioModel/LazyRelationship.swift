import Foundation

public enum LazyRelationship<T: Codable & Equatable> {
    case notLoaded(String)
    case loaded(T)

    public func key() -> String? {
        switch self {
        case .notLoaded(let key): return key
        default: return nil
        }
    }

    public func value() -> T? {
        switch self {
        case .loaded(let value): return value
        default: return nil
        }
    }
}

extension LazyRelationship: Codable {
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .notLoaded(let identifier):
            var container = encoder.singleValueContainer()
            try container.encode(identifier)
        case .loaded(let obj):
            try obj.encode(to: encoder)
        }
    }

    public init(from decoder: Decoder) throws {
        if let singleValueContainer = try? decoder.singleValueContainer() {
            self = .notLoaded(try! singleValueContainer.decode(String.self))
            return
        }

        let obj: T = try T(from: decoder)
        self = .loaded(obj)
    }
}

extension LazyRelationship: Equatable {
    public static func == (lhs: LazyRelationship, rhs: LazyRelationship) -> Bool {
        switch (lhs, rhs) {
        case (.notLoaded(let lhs), .notLoaded(let rhs)): return lhs == rhs
        case (.loaded(let lhs), .loaded(let rhs)): return lhs == rhs
        default: return false
        }
    }
}
