import Foundation

public struct PlaylistV1: CustomEncoder {
    let filePath: String
    public init(filePath: String) {
        self.filePath = filePath
    }

    public enum CodingKeys: String, CodingKey {
        case id = "objectId", title, song, createdAt, updatedAt, className, type = "__type"
    }

    public func encode(entity: Playlist, encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(entity.id, forKey: .id)
        try container.encode(entity.title, forKey: .title)
        if case let .loaded(song) = entity.song {
            try container.encode(LegacyBridge(song, { SongV1(filePath: filePath) }), forKey: .song)
        }
        try container.encode(entity.updatedAt.toPosixDateString(), forKey: .updatedAt)
        try container.encode(entity.createdAt.toPosixDateString(), forKey: .createdAt)
        try container.encode("Object", forKey: .type)
        try container.encode("Playlist", forKey: .className)
    }
}

public struct SongV1: CustomEncoder {
    let filePath: String
    public init(filePath: String) {
        self.filePath = filePath
    }

    public enum CodingKeys: String, CodingKey {
        case id = "objectId", tags, name = "songName", createdAt, updatedAt, artist, albumArt,
             albumArtState, lyrics, lyricsState, hasRightsContract, className, type = "__type"
    }

    public func encode(entity: Song, encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(entity.id, forKey: .id)
        try container.encode(entity.tags, forKey: .tags)
        try container.encode(entity.name, forKey: .name)
        try container.encode(entity.createdAt.toPosixDateString(), forKey: .createdAt)
        try container.encode(entity.updatedAt.toPosixDateString(), forKey: .updatedAt)
        if case let .loaded(artist) = entity.artist {
            try container.encode(LegacyBridge(artist, ArtistV1.init), forKey: .artist)
        }
        if let albumArt = entity.albumArt {
            try container.encode(LegacyBridge(albumArt, { FileV1(filePath: filePath) }), forKey: .albumArt)
        }
        try container.encode(entity.albumArtState, forKey: .albumArtState)
        if let lyrics = entity.lyrics {
            try container.encode(LegacyBridge(lyrics, { FileV1(filePath: filePath) }), forKey: .lyrics)
        }
        try container.encode(entity.lyricsState, forKey: .lyricsState)
        try container.encode(entity.hasRightsContract, forKey: .hasRightsContract)
        try container.encode("Object", forKey: .type)
        try container.encode("Song", forKey: .className)
    }
}

public struct ArtistV1: CustomEncoder {
    public enum CodingKeys: String, CodingKey {
        case id = "objectId", tags, name = "artistName", createdAt, updatedAt, url,
             twitter = "twitterTimeline", className, type = "__type"
    }

    public func encode(entity: Artist, encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(entity.id, forKey: .id)
        try container.encode(entity.tags, forKey: .tags)
        try container.encode(entity.name, forKey: .name)
        try container.encode(entity.createdAt.toPosixDateString(), forKey: .createdAt)
        try container.encode(entity.updatedAt.toPosixDateString(), forKey: .updatedAt)
        try container.encode(entity.url, forKey: .url)
        try container.encode(entity.twitter, forKey: .twitter)
        try container.encode("Object", forKey: .type)
        try container.encode("Artist", forKey: .className)
    }
}

public struct FileV1: CustomEncoder {
    let filePath: String
    public init(filePath: String) {
        self.filePath = filePath
    }

    public enum CodingKeys: String, CodingKey {
        case type = "__type", name, url
    }

    public func encode(entity: String, encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(entity, forKey: .name)
        try container.encode(String(format: filePath, entity), forKey: .url)
        try container.encode("File", forKey: .type)
    }
}
