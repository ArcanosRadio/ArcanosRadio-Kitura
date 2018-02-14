//
//  PlaylistV1.swift
//  Application
//
//  Created by Luiz Rodrigo Martins Barbosa on 14.02.18.
//

import Foundation

fileprivate func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    return formatter.string(from: date)
}

struct PlaylistV1: CustomEncoder {
    enum CodingKeys: String, CodingKey {
        case id = "objectId", title, song, createdAt, updatedAt, className, type = "__type"
    }

    static func encode(entity: Playlist, encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(entity.id, forKey: .id)
        try container.encode(entity.title, forKey: .title)
        if case let .loaded(song) = entity.song {
            try container.encode(LegacyBridge(song, SongV1.self), forKey: .song)
        }
        try container.encode(formatDate(entity.updatedAt), forKey: .updatedAt)
        try container.encode(formatDate(entity.createdAt), forKey: .createdAt)
        try container.encode("Object", forKey: .type)
        try container.encode("Playlist", forKey: .className)
    }
}

struct SongV1: CustomEncoder {
    enum CodingKeys: String, CodingKey {
        case id = "objectId", tags, name = "songName", createdAt, updatedAt, artist, albumArt, albumArtState, lyrics, lyricsState, hasRightsContract, className, type = "__type"
    }

    static func encode(entity: Song, encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(entity.id, forKey: .id)
        try container.encode(entity.tags, forKey: .tags)
        try container.encode(entity.name, forKey: .name)
        try container.encode(formatDate(entity.createdAt), forKey: .createdAt)
        try container.encode(formatDate(entity.updatedAt), forKey: .updatedAt)
        if case let .loaded(artist) = entity.artist {
            try container.encode(LegacyBridge(artist, ArtistV1.self), forKey: .artist)
        }
        if let albumArt = entity.albumArt {
            try container.encode(LegacyBridge(albumArt, FileV1.self), forKey: .albumArt)
        }
        try container.encode(entity.albumArtState, forKey: .albumArtState)
        if let lyrics = entity.lyrics {
            try container.encode(LegacyBridge(lyrics, FileV1.self), forKey: .lyrics)
        }
        try container.encode(entity.lyricsState, forKey: .lyricsState)
        try container.encode(entity.hasRightsContract, forKey: .hasRightsContract)
        try container.encode("Object", forKey: .type)
        try container.encode("Song", forKey: .className)
    }
}

struct ArtistV1: CustomEncoder {
    enum CodingKeys: String, CodingKey {
        case id = "objectId", tags, name = "artistName", createdAt, updatedAt, url, twitter = "twitterTimeline", className, type = "__type"
    }

    static func encode(entity: Artist, encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(entity.id, forKey: .id)
        try container.encode(entity.tags, forKey: .tags)
        try container.encode(entity.name, forKey: .name)
        try container.encode(formatDate(entity.createdAt), forKey: .createdAt)
        try container.encode(formatDate(entity.updatedAt), forKey: .updatedAt)
        try container.encode(entity.url, forKey: .url)
        try container.encode(entity.twitter, forKey: .twitter)
        try container.encode("Object", forKey: .type)
        try container.encode("Artist", forKey: .className)
    }
}

struct FileV1: CustomEncoder {
    enum CodingKeys: String, CodingKey {
        case type = "__type", name, url
    }

    static func encode(entity: String, encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(entity, forKey: .name)
        try container.encode("https://api.arcanosmc.com.br/parse/files/arcanosRadio/\(entity)", forKey: .url)
        try container.encode("File", forKey: .type)
    }
}
/*
{
	"results": [{
		"objectId": "4pHr4wQVTe",
		"title": "Epica - Cry For The Moon",
		"song": {
			"objectId": "xTX53XD115",
			"tags": ["epica - cry for the moon"],
			"songName": "Cry For The Moon",
			"artist": {
				"objectId": "7wlD9Vp2cc",
				"tags": ["epica"],
				"artistName": "Epica",
				"createdAt": "2016-09-21T22:50:52.168Z",
				"updatedAt": "2017-08-18T19:20:27.924Z",
				"twitterTimeline": "@Epica",
				"url": "http://www.epica.nl/",
				"__type": "Object",
				"className": "Artist"
			},
			"albumArt": {
				"__type": "File",
				"name": "81babee38ed1995ff55f8e4c466d1899_cryforthemoon_epica.jpeg",
				"url": "https://api.arcanosmc.com.br/parse/files/arcanosRadio/81babee38ed1995ff55f8e4c466d1899_cryforthemoon_epica.jpeg"
			},
			"lyrics": {
				"__type": "File",
				"name": "f29c5041dc6146f7f07db0f0d009bd3a_cryforthemoon_epica.txt",
				"url": "https://api.arcanosmc.com.br/parse/files/arcanosRadio/f29c5041dc6146f7f07db0f0d009bd3a_cryforthemoon_epica.txt"
			},
			"lyricsState": 3,
			"createdAt": "2016-10-02T17:16:41.274Z",
			"updatedAt": "2016-10-03T00:12:01.426Z",
			"albumArtState": 3,
			"hasRightsContract": false,
			"__type": "Object",
			"className": "Song"
		},
		"createdAt": "2018-02-14T20:00:07.421Z",
		"updatedAt": "2018-02-14T20:00:07.421Z"
	}]
}
*/
