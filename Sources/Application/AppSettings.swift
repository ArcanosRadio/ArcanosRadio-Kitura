//
//  AppSettings.swift
//  Application
//
//  Created by Luiz Rodrigo Martins Barbosa on 16.02.18.
//

import Foundation

public struct AppSettings: Codable {
    public var serverPort: String
    public var mongoUrl: String
    public var parseApplicationId: String
    public var parseClientKey: String

    public static let `default`: AppSettings = {
        return .init(
            serverPort: "8080",
            mongoUrl: "mongodb://localhost/",
            parseApplicationId: "appId",
            parseClientKey: "clientKey")
    }()

    public static var current: AppSettings = .default

    public func merging(_ other: AppSettings) -> AppSettings {
        return AppSettings.fromDictionary(
            self.toDictionary().merging(other.toDictionary(), uniquingKeysWith: { $1 })
            )!
    }

    public func merging(dictionary: [String: String]) -> AppSettings {
        let selfDict = self.toDictionary()
        let mergedDict = selfDict.merging(dictionary, uniquingKeysWith: { $1 })
        return AppSettings.fromDictionary(mergedDict)!
    }

    public func merging(file: URL) -> AppSettings {
        guard let data = try? Data(contentsOf: file),
            let dictionary = try? JSONDecoder().decode([String: String].self, from: data) else { return self }

        return self.merging(dictionary: dictionary)
    }

    private func toDictionary() -> [String: String] {
        let encoder = JSONEncoder(), decoder = JSONDecoder()
        return (try? encoder.encode(self))
            .flatMap { try? decoder.decode([String: String].self, from: $0) }
            ?? [:]
    }

    private static func fromDictionary(_ dictionary: [String: String]) -> AppSettings? {
        let encoder = JSONEncoder()
        return (try? encoder.encode(dictionary))
            .flatMap { AppSettings.fromData($0) }
    }

    private static func fromData(_ data: Data) -> AppSettings? {
        let decoder = JSONDecoder()
        return try? decoder.decode(AppSettings.self, from: data)
    }
}
