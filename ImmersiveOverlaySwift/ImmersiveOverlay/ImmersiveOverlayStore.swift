import SwiftUI
import Observation

// MARK: - Color Configuration

struct OverlayColors {
    var primary: Color
    var secondary: Color
    var expandingDark: [Color]
    var expandingLight: [Color]

    static let `default` = OverlayColors(
        primary: Color(hex: "#5465ff"),
        secondary: Color(hex: "#5465ff"),
        expandingDark: [.orange, .red, Color(hex: "#5465ff")],
        expandingLight: [.orange, .red, Color(hex: "#0077b6")]
    )
}

// MARK: - Store

@Observable
class ImmersiveOverlayStore {
    var displayImmersiveOverlay: Bool = false
    var contentComponent: AnyView? = nil
    var colors: OverlayColors = .default

    func immerse(component: AnyView? = nil, colors: OverlayColors? = nil) {
        self.contentComponent = component
        self.colors = colors ?? .default
        self.displayImmersiveOverlay = true
    }

    func dismiss() {
        self.displayImmersiveOverlay = false
    }
}
