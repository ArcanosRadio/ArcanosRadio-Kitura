//
//  Song.swift
//  Application
//
//  Created by Luiz Rodrigo Martins Barbosa on 13.02.18.
//

import Foundation

public struct Song: Codable {
    public let id: String
    public let tags: [String]
    public let name: String
    public var artist: LazyRelationship<Artist>
    public let albumArt: String?
    public let albumArtState: Int?
    public let lyrics: String?
    public let lyricsState: Int?
    public let createdAt: Date
    public let updatedAt: Date
    public let hasRightsContract: Bool
}

extension Song: Equatable {
    public static func == (lhs: Song, rhs: Song) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.tags == rhs.tags &&
            lhs.name == rhs.name &&
            lhs.artist == rhs.artist &&
            lhs.albumArt == rhs.albumArt &&
            lhs.albumArtState == rhs.albumArtState &&
            lhs.lyrics == rhs.lyrics &&
            lhs.lyricsState == rhs.lyricsState &&
            lhs.createdAt == rhs.createdAt &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.hasRightsContract == rhs.hasRightsContract
    }
}
