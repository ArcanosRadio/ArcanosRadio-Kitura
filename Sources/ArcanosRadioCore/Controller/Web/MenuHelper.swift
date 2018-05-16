import Foundation
import Kitura
import KituraContracts

class MenuHelper {
    static let items: [[String: Any]] = [
        ["href": "/admin", "text": "Current", "current": false ],
        ["href": "/admin/playlist", "text": "Playlist", "current": false ],
        ["href": "/admin/artists", "text": "Artists", "current": false ],
        ["href": "/admin/songs", "text": "Songs", "current": false ],
        ["href": "/admin/settings", "text": "Settings", "current": false ]
    ]

    static func forHref(_ href: String?) -> [[String: Any]] {
        return items.map {
            guard let lhsHref = $0["href"] as? String,
                let rhsHref = href,
                lhsHref == rhsHref else { return $0 }

            var item = $0
            item["current"] = true
            return item
        }
    }
}
