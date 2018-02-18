import KituraContracts

public typealias CodableResultClosureEx<O: Codable> = (Result<O, RequestError>) -> Void
public typealias CodableArrayResultClosureEx<O: Codable> = (Result<[O], RequestError>) -> Void
public typealias IdentifierCodableResultClosureEx<Id: Identifier, O: Codable> = (Id?, Result<O, RequestError>) -> Void
public typealias IdentifierCodableClosureEx<Id: Identifier, I: Codable, O: Codable> = (Id, I, @escaping CodableResultClosureEx<O>) -> Void
public typealias CodableClosureEx<I: Codable, O: Codable> = (I, @escaping CodableResultClosureEx<O>) -> Void
public typealias CodableIdentifierClosureEx<I: Codable, Id: Identifier, O: Codable> =
    (I, @escaping IdentifierCodableResultClosureEx<Id, O>) -> Void
public typealias CodableArrayClosureEx<O: Codable> = (@escaping CodableArrayResultClosureEx<O>) -> Void
public typealias SimpleCodableClosureEx<O: Codable> = (@escaping CodableResultClosureEx<O>) -> Void
public typealias IdentifierSimpleCodableClosureEx<Id: Identifier, O: Codable> = (Id, @escaping CodableResultClosureEx<O>) -> Void
