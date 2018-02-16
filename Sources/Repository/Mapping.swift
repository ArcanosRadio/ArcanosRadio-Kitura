//
//  Mapping.swift
//  ArcanosRadio-KituraPackageDescription
//
//  Created by Luiz Rodrigo Martins Barbosa on 14.02.18.
//

import Foundation

protocol MappingProtocol: RawRepresentable where RawValue == String {
    associatedtype Entity
}

enum ArtistMapping: String, MappingProtocol {
    typealias Entity = Artist

    case id = "_id"
    case tags
    case name = "artistName"
    case createdAt = "_created_at"
    case updatedAt = "_updated_at"
    case url
    case twitter = "twitterTimeline"
}

enum PlaylistMapping: String, MappingProtocol {
    typealias Entity = Playlist

    case id = "_id"
    case title
    case song = "_p_song"
    case createdAt = "_created_at"
    case updatedAt = "_updated_at"
}

enum SongMapping: String, MappingProtocol {
    typealias Entity = Song

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

enum GlobalConfigMapping: String, MappingProtocol {
    typealias Entity = GlobalConfig

    case id = "_id"
    case iphoneStreamingUrl = "params.iphoneStreamingUrl"
    case iphonePoolingTimeActive = "params.iphonePoolingTimeActive"
    case iphonePoolingTimeBackground = "params.iphonePoolingTimeBackground"
    case iphoneShareUrl = "params.iphoneShareUrl"
    case androidStreamingUrl = "params.androidStreamingUrl"
    case androidShareUrl = "params.androidShareUrl"
    case androidPoolingTimeActive = "params.androidPoolingTimeActive"
    case iphoneRightsFlag = "params.iphoneRightsFlag"
}
