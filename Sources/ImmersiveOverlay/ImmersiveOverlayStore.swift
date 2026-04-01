import SwiftUI
import Observation

/// Observable state container for the immersive overlay.
///
/// Inject an instance into your view hierarchy via `.environment(store)` (or use the
/// `.immersiveOverlay()` modifier which does this automatically), then read it anywhere
/// with `@Environment(ImmersiveOverlayStore.self)`.
@Observable
public class ImmersiveOverlayStore {

    /// Whether the overlay is currently presented.
    public var displayImmersiveOverlay: Bool = false

    /// Optional custom content rendered inside the overlay.
    public var contentComponent: AnyView? = nil

    /// Active color palette.
    public var colors: OverlayColors = .default

    public init(defaultColors: OverlayColors = .default) {
        self.colors = defaultColors
    }

    /// Triggers the immersive overlay, optionally providing custom content and/or a color palette.
    public func immerse(component: AnyView? = nil, colors: OverlayColors? = nil) {
        self.contentComponent = component
        self.colors = colors ?? self.colors
        self.displayImmersiveOverlay = true
    }

    /// Dismisses the overlay.
    public func dismiss() {
        self.displayImmersiveOverlay = false
    }
}
