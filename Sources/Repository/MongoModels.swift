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

    init?(mongo document: Document) {
        do {
            self.id = Id(rawValue: try document.required(ArtistMapping.id, converter: String.init))!
            self.tags = (try document.required(ArtistMapping.tags, converter: Array.init)).flatMap { String($0) }
            self.name = try document.required(ArtistMapping.name, converter: String.init)
            self.createdAt = try document.required(ArtistMapping.createdAt, converter: Date.init)
            self.updatedAt = try document.required(ArtistMapping.updatedAt, converter: Date.init)
        } catch {
            return nil
        }

        self.url = document.optional(ArtistMapping.url, converter: URL.init)
        self.twitter = document.optional(ArtistMapping.twitter, converter: String.init)
    }
}

extension Song: MongoModel {
    static let collectionName = "Song"

    init?(mongo document: Document) {
        do {
            self.id = Id(rawValue: try document.required(SongMapping.id, converter: String.init))!
            self.tags = (try document.required(SongMapping.tags, converter: Array.init)).flatMap { String($0) }
            self.name = try document.required(SongMapping.name, converter: String.init)
            self.createdAt = try document.required(SongMapping.createdAt, converter: Date.init)
            self.updatedAt = try document.required(SongMapping.updatedAt, converter: Date.init)
            self.hasRightsContract = try document.required(SongMapping.hasRightsContract, converter: Bool.init)
            self.artist = .notLoaded((try document.required(SongMapping.artist, converter: String.init)).components(separatedBy: "$")[1])
        } catch {
            return nil
        }

        self.albumArt = document.optional(SongMapping.albumArt, converter: String.init)
        self.albumArtState = document.optional(SongMapping.albumArtState, converter: Int.init)
        self.lyrics = document.optional(SongMapping.lyrics, converter: String.init)
        self.lyricsState = document.optional(SongMapping.lyricsState, converter: Int.init)
    }
}

extension Playlist: MongoModel {
    static let collectionName = "Playlist"

    init?(mongo document: Document) {
        do {
            self.id = Id(rawValue: try document.required(PlaylistMapping.id, converter: String.init))!
            self.title = try document.required(PlaylistMapping.title, converter: String.init)
            self.song = .notLoaded((try document.required(PlaylistMapping.song, converter: String.init)).components(separatedBy: "$")[1])
            self.createdAt = try document.required(PlaylistMapping.createdAt, converter: Date.init)
            self.updatedAt = try document.required(PlaylistMapping.updatedAt, converter: Date.init)
        } catch {
            return nil
        }
    }
}

extension GlobalConfig: MongoModel {
    static let collectionName = "_GlobalConfig"

    init?(mongo document: Document) {
        do {
            self.id = Id(rawValue: String(try document.required(GlobalConfigMapping.id, converter: Int.init)))!

            self.iphoneStreamingUrl = try document.required(GlobalConfigMapping.iphoneStreamingUrl, converter: URL.init)

            self.iphonePoolingTimeActive = try document.required(GlobalConfigMapping.iphonePoolingTimeActive, converter: Int.init)
            self.iphonePoolingTimeBackground = try document.required(GlobalConfigMapping.iphonePoolingTimeBackground, converter: Int.init)
            self.iphoneShareUrl = try document.required(GlobalConfigMapping.iphoneShareUrl, converter: URL.init)
            self.androidStreamingUrl = try document.required(GlobalConfigMapping.androidStreamingUrl, converter: URL.init)
            self.androidShareUrl = try document.required(GlobalConfigMapping.androidShareUrl, converter: URL.init)
            self.androidPoolingTimeActive = try document.required(GlobalConfigMapping.androidPoolingTimeActive, converter: Int.init)
            self.iphoneRightsFlag = try document.required(GlobalConfigMapping.iphoneRightsFlag, converter: Bool.init)
            self.serviceUrl = try document.required(GlobalConfigMapping.serviceUrl, converter: URL.init)
        } catch {
            return nil
        }
    }
}
