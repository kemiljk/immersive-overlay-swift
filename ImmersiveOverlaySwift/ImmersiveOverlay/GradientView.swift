import SwiftUI
import UIKit

// MARK: - Animated Blur View

/// A `UIVisualEffectView` wrapper whose blur intensity can be smoothly animated
/// by adjusting `fractionComplete` on a paused `UIViewPropertyAnimator`.
struct AnimatedBlurView: UIViewRepresentable {

    /// 0.0 = no blur, 1.0 = full blur at the chosen material style.
    var intensity: Double

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView()
        context.coordinator.setup(view: view)
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        context.coordinator.setIntensity(intensity)
    }

    class Coordinator {
        private var animator: UIViewPropertyAnimator?

        func setup(view: UIVisualEffectView) {
            animator = UIViewPropertyAnimator(duration: 1, curve: .linear) {
                view.effect = UIBlurEffect(style: .systemUltraThinMaterial)
            }
            animator?.startAnimation()
            animator?.pauseAnimation()
            animator?.fractionComplete = 0
        }

        func setIntensity(_ intensity: Double) {
            animator?.fractionComplete = CGFloat(max(0, min(1, intensity)))
        }

        deinit {
            animator?.stopAnimation(true)
        }
    }
}

// MARK: - Gradient View

/// Renders the immersive overlay visual layer:
///
/// 1. **Animated blur backdrop** — `UIVisualEffectView` fades 0 → 1 on enter, 1 → 0 on exit.
/// 2. **Background circles** — Two large, blurred color blobs that breathe (scale 0.7 ↔ 1.0).
/// 3. **Expanding circle** — A circle that starts at the bottom-center and scales up to 10×,
///    interpolating through the expanding color palette.
///
/// Entering time: 750 ms.  Exiting time: 500 ms.
struct GradientView: View {

    @Environment(ImmersiveOverlayStore.self) private var store
    @Environment(\.colorScheme) private var colorScheme

    let isExiting: Bool

    // MARK: Animated state

    @State private var blurIntensity: Double = 0
    @State private var circleOpacity: Double = 0
    @State private var breathingScale: Double = 0

    @State private var expandingScale: Double = 0.001
    @State private var expandingOpacity: Double = 1.0

    // MARK: Constants

    private let enteringTime: Double = 0.75
    private let exitingTime:  Double = 0.50

    // MARK: Body

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let gen = generateColors(colors: store.colors, colorScheme: colorScheme)

            ZStack {
                // ── Blur backdrop ──────────────────────────────────────────────
                AnimatedBlurView(intensity: blurIntensity)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                // ── Background circle 1 — primary color, top-left ────────────
                Circle()
                    .fill(gen.primary.opacity(circleOpacity))
                    .frame(width: w * 2, height: w * 2)
                    .blur(radius: w * 0.75)
                    .scaleEffect(breathingScale)
                    .position(x: -w / 3, y: 0)

                // ── Background circle 2 — secondary color, bottom-right ──────
                Circle()
                    .fill(gen.secondary.opacity(circleOpacity))
                    .frame(width: w * 2, height: w * 2)
                    .blur(radius: w * 0.62)
                    .scaleEffect(breathingScale)
                    .position(x: w + w / 3, y: h)

                // ── Expanding circle — bottom-center ──────────────────────────
                let expandRadius = (w / 3)
                Circle()
                    .fill(
                        interpolatedColor(
                            colors: gen.expanding,
                            progress: expandingScale / 10.0
                        )
                    )
                    .frame(width: expandRadius * 2, height: expandRadius * 2)
                    .blur(radius: 15)
                    .scaleEffect(expandingScale)
                    .opacity(expandingOpacity)
                    .position(x: w / 2, y: h)
            }
        }
        .onAppear {
            startEnteringAnimations()
        }
        .onChange(of: isExiting) { _, exiting in
            if exiting { startExitingAnimations() }
        }
    }

    // MARK: - Animations

    private func startEnteringAnimations() {
        // Blur + circle opacity
        withAnimation(.easeInOut(duration: enteringTime)) {
            blurIntensity = 1.0
            circleOpacity = 0.8
        }

        // Expanding circle: scale up, fade to 0.5 opacity
        withAnimation(.easeOut(duration: enteringTime)) {
            expandingScale   = 10.0
            expandingOpacity = 0.5
        }

        // Background circles: initial scale 0 → 1 (1 000 ms)
        withAnimation(.easeInOut(duration: 1.0)) {
            breathingScale = 1.0
        }

        // Then start the perpetual breathing between 1.0 and 0.7 (7 500 ms per phase)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(
                .easeInOut(duration: 7.5).repeatForever(autoreverses: true)
            ) {
                breathingScale = 0.7
            }
        }
    }

    private func startExitingAnimations() {
        withAnimation(.easeInOut(duration: exitingTime)) {
            blurIntensity    = 0
            circleOpacity    = 0
            expandingScale   = 0.001
            expandingOpacity = 1.0
            breathingScale   = 0
        }
    }
}
