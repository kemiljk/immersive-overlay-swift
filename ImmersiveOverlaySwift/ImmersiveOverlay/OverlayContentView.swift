import SwiftUI

/// Displays and animates the optional custom content inside the overlay.
///
/// Entering (500 ms, cubic-bezier(0.59, 0, 0.35, 1)):
///   opacity 1, rotateX 0°, skewY 0°, scaleY 1, scaleX 1, translateY 0
///
/// Exiting (500 ms same easing, opacity 300 ms):
///   opacity 0, rotateX −5°, skewY −1.5°, scaleY 2, scaleX 0.4, translateY 100
struct OverlayContentView: View {

    @Environment(ImmersiveOverlayStore.self) private var store

    let isExiting: Bool

    // MARK: - Animated state (initial values = exiting/hidden state)

    @State private var opacity:     Double = 0
    @State private var rotateX:     Double = -5
    @State private var skewYDeg:    Double = -1.5
    @State private var scaleY:      Double = 2
    @State private var scaleX:      Double = 0.4
    @State private var translateY:  Double = 100

    // MARK: - Constants

    private let easing = Animation.timingCurve(0.59, 0, 0.35, 1, duration: 0.5)

    // MARK: - Body

    var body: some View {
        Group {
            if let component = store.contentComponent {
                component
                    .opacity(opacity)
                    .scaleEffect(x: scaleX, y: scaleY)
                    .rotation3DEffect(
                        .degrees(rotateX),
                        axis: (x: 1, y: 0, z: 0),
                        perspective: 1 / 1000
                    )
                    .transformEffect(skewY(degrees: skewYDeg))
                    .offset(y: translateY)
            }
        }
        .onAppear {
            enter()
        }
        .onChange(of: isExiting) { _, exiting in
            if exiting { exit() }
        }
    }

    // MARK: - Animations

    private func enter() {
        withAnimation(.easeInOut(duration: 0.3)) {
            opacity = 1
        }
        withAnimation(easing) {
            rotateX    = 0
            skewYDeg   = 0
            scaleY     = 1
            scaleX     = 1
            translateY = 0
        }
    }

    private func exit() {
        withAnimation(.easeInOut(duration: 0.3)) {
            opacity = 0
        }
        withAnimation(easing) {
            rotateX    = -5
            skewYDeg   = -1.5
            scaleY     = 2
            scaleX     = 0.4
            translateY = 100
        }
    }

    // MARK: - Helpers

    private func skewY(degrees: Double) -> CGAffineTransform {
        let radians = degrees * .pi / 180
        return CGAffineTransform(a: 1, b: CGFloat(tan(radians)), c: 0, d: 1, tx: 0, ty: 0)
    }
}
