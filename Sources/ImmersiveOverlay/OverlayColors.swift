import SwiftUI

/// Color configuration for the immersive overlay.
///
/// Pass a custom instance to `ImmersiveOverlayStore.immerse(colors:)` or to the
/// `.immersiveOverlay(colors:)` view modifier to control the visual palette.
public struct OverlayColors {

    /// Color of the large blurred blob in the top-left corner.
    public var primary: Color

    /// Color of the large blurred blob in the bottom-right corner.
    public var secondary: Color

    /// Color stops for the expanding circle in dark mode.
    public var expandingDark: [Color]

    /// Color stops for the expanding circle in light mode.
    public var expandingLight: [Color]

    /// Creates a custom color configuration.
    public init(
        primary: Color,
        secondary: Color,
        expandingDark: [Color],
        expandingLight: [Color]
    ) {
        self.primary = primary
        self.secondary = secondary
        self.expandingDark = expandingDark
        self.expandingLight = expandingLight
    }

    /// The built-in default palette: blue/indigo primary, orange → red → blue expanding.
    public static let `default` = OverlayColors(
        primary: Color(hex: "#5465ff"),
        secondary: Color(hex: "#5465ff"),
        expandingDark: [.orange, .red, Color(hex: "#5465ff")],
        expandingLight: [.orange, .red, Color(hex: "#0077b6")]
    )
}
