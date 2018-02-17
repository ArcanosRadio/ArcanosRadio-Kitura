import Foundation
import KituraContracts

struct PageURLParams: QueryParams {
    var page: Int?
    var pageSize: Int?
}

struct StringIdentifier: Identifier {
    init(value: String) throws {
        self.value = value
    }

    let value: String
}
