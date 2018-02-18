import KituraStencil
import KituraTemplateEngine
import Stencil

class Template {
    static func setupTemplates(app: App) {
        let ext = Extension()
        escapeFilter(ext)

        app.router.setDefault(templateEngine: StencilTemplateEngine(extension: ext))
    }

    private static let escapeFilter: (Extension) -> Void = { ext in
        ext.registerFilter("escape") { (value: Any?) in
            if let value = value as? String {
                return "{{ \(value) }}"
            }

            return value
        }
    }
}
