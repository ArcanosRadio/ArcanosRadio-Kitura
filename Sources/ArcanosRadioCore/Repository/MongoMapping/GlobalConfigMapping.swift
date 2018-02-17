import Foundation
import ArcanosRadioModel

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
    case serviceUrl = "params.serviceUrl"
}
