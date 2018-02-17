import Foundation

protocol MappingProtocol: RawRepresentable where RawValue == String {
    associatedtype Entity
}
