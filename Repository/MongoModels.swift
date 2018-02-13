//
//  MongoModels.swift
//  Application
//
//  Created by Luiz Rodrigo Martins Barbosa on 13.02.18.
//

import Foundation
import MongoKitten

protocol MongoModel {
    static var collectionName: String { get }
    init?(mongo document: Document)
}

extension Artist: MongoModel {
    static let collectionName = "Artist"

    enum Mapping: String {
        case id = "_id"
        case tags
        case name = "artistName"
        case createdAt = "_created_at"
        case updatedAt = "_updated_at"
        case url
        case twitter = "twitterTimeline"
    }

    init?(mongo document: Document) {
        do {
            self.id = try document.required(Mapping.id, converter: String.init)
            self.tags = (try document.required(Mapping.tags, converter: Array.init)).flatMap { String($0) }
            self.name = try document.required(Mapping.name, converter: String.init)
            self.createdAt = try document.required(Mapping.createdAt, converter: Date.init)
            self.updatedAt = try document.required(Mapping.updatedAt, converter: Date.init)
        } catch {
            return nil
        }

        self.url = document.optional(Mapping.url, converter: URL.init)
        self.twitter = document.optional(Mapping.twitter, converter: String.init)
    }
}

extension Song: MongoModel {
    static let collectionName = "Song"

    enum Mapping: String {
        case id = "_id"
        case tags
        case name = "songName"
        case artist = "_p_artist"
        case albumArt
        case albumArtState
        case lyrics
        case lyricsState
        case createdAt = "_created_at"
        case updatedAt = "_updated_at"
        case hasRightsContract
    }

    init?(mongo document: Document) {
        do {
            self.id = try document.required(Mapping.id, converter: String.init)
            self.tags = (try document.required(Mapping.tags, converter: Array.init)).flatMap { String($0) }
            self.name = try document.required(Mapping.name, converter: String.init)
            self.createdAt = try document.required(Mapping.createdAt, converter: Date.init)
            self.updatedAt = try document.required(Mapping.updatedAt, converter: Date.init)
            self.hasRightsContract = try document.required(Mapping.hasRightsContract, converter: Bool.init)
            self.artist = .notLoaded((try document.required(Mapping.artist, converter: String.init)).components(separatedBy: "$")[1])
        } catch {
            return nil
        }

        self.albumArt = document.optional(Mapping.albumArt, converter: String.init)
        self.albumArtState = document.optional(Mapping.albumArtState, converter: Int.init)
        self.lyrics = document.optional(Mapping.lyrics, converter: String.init)
        self.lyricsState = document.optional(Mapping.lyricsState, converter: Int.init)
    }
}

extension Playlist: MongoModel {
    static let collectionName = "Playlist"

    enum Mapping: String {
        case id = "_id"
        case title
        case song = "_p_song"
        case createdAt = "_created_at"
        case updatedAt = "_updated_at"
    }

    init?(mongo document: Document) {
        do {
            self.id = try document.required(Mapping.id, converter: String.init)
            self.title = try document.required(Mapping.title, converter: String.init)
            self.song = .notLoaded((try document.required(Mapping.song, converter: String.init)).components(separatedBy: "$")[1])
            self.createdAt = try document.required(Mapping.createdAt, converter: Date.init)
            self.updatedAt = try document.required(Mapping.updatedAt, converter: Date.init)
        } catch {
            return nil
        }
    }
}
