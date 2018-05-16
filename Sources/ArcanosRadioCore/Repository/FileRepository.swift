import Foundation

protocol FileRepository {
    func file(byName name: String) -> Data?
}
