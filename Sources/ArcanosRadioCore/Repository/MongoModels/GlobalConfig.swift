import Foundation
import MongoKitten
import ArcanosRadioModel

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
