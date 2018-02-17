import Foundation
import Kitura
import KituraContracts

class MenuHelper {
    static let items = [
        ["href": "/admin", "text": "Current"],
        ["href": "/admin/playlist", "text": "Playlist"],
        ["href": "/admin/artists", "text": "Artists"],
        ["href": "/admin/songs", "text": "Songs"],
        ["href": "/admin/settings", "text": "Settings"]
    ]
}
