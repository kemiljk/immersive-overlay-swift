import SwiftUI

// MARK: - Modifier

/// Internal ViewModifier that owns the `ImmersiveOverlayStore` and injects it into the environment.
private struct ImmersiveOverlayModifier: ViewModifier {

    @State private var store: ImmersiveOverlayStore

    init(colors: OverlayColors) {
        _store = State(initialValue: ImmersiveOverlayStore(defaultColors: colors))
    }

    func body(content: Content) -> some View {
        ImmersiveOverlayView {
            content
        }
        .environment(store)
    }
}

// MARK: - View Extension

extension View {

    /// Wraps this view in the immersive overlay system using the **default** color palette.
    ///
    /// Place this modifier at the root of your view hierarchy (e.g. on the top-level view in your
    /// `WindowGroup`). It injects an `ImmersiveOverlayStore` into the environment so any
    /// descendant can read it with `@Environment(ImmersiveOverlayStore.self)`.
    ///
    /// ```swift
    /// ContentView()
    ///     .immersiveOverlay()
    /// ```
    public func immersiveOverlay() -> some View {
        modifier(ImmersiveOverlayModifier(colors: .default))
    }

    /// Wraps this view in the immersive overlay system using a fully custom `OverlayColors` value.
    ///
    /// ```swift
    /// ContentView()
    ///     .immersiveOverlay(
    ///         colors: OverlayColors(
    ///             primary: .pink,
    ///             secondary: .indigo,
    ///             expandingDark:  [.pink, .purple, .indigo],
    ///             expandingLight: [.pink, .purple, .indigo]
    ///         )
    ///     )
    /// ```
    public func immersiveOverlay(colors: OverlayColors) -> some View {
        modifier(ImmersiveOverlayModifier(colors: colors))
    }

    /// Wraps this view in the immersive overlay system with individually specified colors.
    ///
    /// - Parameters:
    ///   - primary: Color of the large blurred blob anchored at the top-left.
    ///   - secondary: Color of the large blurred blob anchored at the bottom-right.
    ///   - expandingColors: Color stops for the expanding circle (used for both light and dark mode).
    ///     Provide at least one color; two or more create a gradient sweep.
    ///
    /// ```swift
    /// ContentView()
    ///     .immersiveOverlay(
    ///         primary: .blue,
    ///         secondary: .purple,
    ///         expandingColors: .orange, .red, .blue
    ///     )
    /// ```
    public func immersiveOverlay(
        primary: Color,
        secondary: Color,
        expandingColors: Color...
    ) -> some View {
        let stops = expandingColors.isEmpty ? [primary] : expandingColors
        let colors = OverlayColors(
            primary: primary,
            secondary: secondary,
            expandingDark: stops,
            expandingLight: stops
        )
        return modifier(ImmersiveOverlayModifier(colors: colors))
    }
}
