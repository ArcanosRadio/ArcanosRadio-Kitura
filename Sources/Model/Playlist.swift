//
//  Playlist.swift
//  Application
//
//  Created by Luiz Rodrigo Martins Barbosa on 13.02.18.
//

import Foundation

public struct Playlist: Codable {
    public let id: Id<Playlist>
    public let title: String
    public var song: LazyRelationship<Song>
    public let createdAt: Date
    public let updatedAt: Date
}

extension Playlist: Equatable {
    public static func == (lhs: Playlist, rhs: Playlist) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.song == rhs.song &&
            lhs.createdAt == rhs.createdAt &&
            lhs.updatedAt == rhs.updatedAt
    }
}
