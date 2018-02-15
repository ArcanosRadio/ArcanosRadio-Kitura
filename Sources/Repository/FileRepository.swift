//
//  FileRepository.swift
//  Application
//
//  Created by Luiz Rodrigo Martins Barbosa on 13.02.18.
//

import Foundation

protocol FileRepository {
    func file(byName name: String) -> Data?
}
