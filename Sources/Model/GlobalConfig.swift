//
//  GlobalConfig.swift
//  Application
//
//  Created by Luiz Rodrigo Martins Barbosa on 16.02.18.
//

import Foundation

public struct GlobalConfig: Codable {
    public let id: Id<GlobalConfig>
    public let iphoneStreamingUrl: URL
    public let iphonePoolingTimeActive: Int
    public let iphonePoolingTimeBackground: Int
    public let iphoneShareUrl: URL
    public let androidStreamingUrl: URL
    public let androidShareUrl: URL
    public let androidPoolingTimeActive: Int
    public let iphoneRightsFlag: Bool
}

extension GlobalConfig: Equatable {
    public static func == (lhs: GlobalConfig, rhs: GlobalConfig) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.iphoneStreamingUrl == rhs.iphoneStreamingUrl &&
            lhs.iphonePoolingTimeActive == rhs.iphonePoolingTimeActive &&
            lhs.iphonePoolingTimeBackground == rhs.iphonePoolingTimeBackground &&
            lhs.iphoneShareUrl == rhs.iphoneShareUrl &&
            lhs.androidStreamingUrl == rhs.androidStreamingUrl &&
            lhs.androidShareUrl == rhs.androidShareUrl &&
            lhs.androidPoolingTimeActive == rhs.androidPoolingTimeActive &&
            lhs.iphoneRightsFlag == rhs.iphoneRightsFlag
    }
}
