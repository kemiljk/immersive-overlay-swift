import SwiftUI

/// Wraps app content and applies a "warp" effect to it whenever the overlay becomes visible.
///
/// Animation sequence:
/// 1. Progress 0 → 1  in 300 ms with cubic-bezier(0.65, 0, 0.35, 1)
/// 2. Progress 1 → 0  in 1500 ms with cubic-bezier(0.22, 1, 0.36, 1)
///
/// Transform (transform-origin: top):
/// - rotateX  = −5° × progress
/// - skewY    = −1.5° × progress
/// - scaleY   = 1 + 0.1 × progress
/// - scaleX   = 1 − 0.06 × progress
public struct ImmersiveOverlayView<Content: View>: View {

    @Environment(ImmersiveOverlayStore.self) private var store

    private let content: Content

    @State private var warpProgress: Double = 0

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        content
            // Scale (applied first so the scale anchor is "top")
            .scaleEffect(
                x: 1 - warpProgress * 0.06,
                y: 1 + warpProgress * 0.1,
                anchor: .top
            )
            // rotateX around the top edge
            .rotation3DEffect(
                .degrees(-5 * warpProgress),
                axis: (x: 1, y: 0, z: 0),
                anchor: .top,
                perspective: 1 / 1000
            )
            // skewY using a 2-D affine transform
            .transformEffect(skewY(degrees: -1.5 * warpProgress))
            // Full-screen overlay sits on top
            .overlay {
                OverlayView()
                    .ignoresSafeArea()
            }
            .onChange(of: store.displayImmersiveOverlay) { _, isDisplaying in
                if isDisplaying {
                    // Phase 1 – warp in
                    withAnimation(.timingCurve(0.65, 0, 0.35, 1, duration: 0.3)) {
                        warpProgress = 1
                    }
                    // Phase 2 – spring back
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.timingCurve(0.22, 1, 0.36, 1, duration: 1.5)) {
                            warpProgress = 0
                        }
                    }
                } else {
                    withAnimation(.timingCurve(0.65, 0, 0.35, 1, duration: 0.3)) {
                        warpProgress = 0
                    }
                }
            }
    }

    // MARK: - Helpers

    /// Returns a skewY affine transform: x′ = x, y′ = tan(θ)·x + y
    private func skewY(degrees: Double) -> CGAffineTransform {
        let radians = degrees * .pi / 180
        return CGAffineTransform(a: 1, b: CGFloat(tan(radians)), c: 0, d: 1, tx: 0, ty: 0)
    }
}
