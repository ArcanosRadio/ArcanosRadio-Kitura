//
//  PageURLParams.swift
//  Application
//
//  Created by Luiz Rodrigo Martins Barbosa on 13.02.18.
//

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
