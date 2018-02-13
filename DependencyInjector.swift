//
//  DependencyInjector.swift
//  Application
//
//  Created by Luiz Rodrigo Martins Barbosa on 13.02.18.
//

import Foundation

func inject<T>(_ type: T.Type) -> T {
    if let mongo = MongoRepository.shared as? T { return mongo }
    fatalError("Dependency injection error. Type: \(type)")
}
