import SwiftUI

/// Full-screen overlay container.
///
/// - Shown while `store.displayImmersiveOverlay == true` (with a brief exit-animation delay).
/// - Tapping anywhere on the overlay dismisses it.
/// - Contains `GradientView` (visual effects) and `OverlayContentView` (custom content).
struct OverlayView: View {

    @Environment(ImmersiveOverlayStore.self) private var store

    @State private var isVisible: Bool = false
    @State private var isExiting: Bool = false

    var body: some View {
        ZStack {
            if isVisible {
                ZStack {
                    GradientView(isExiting: isExiting)
                    OverlayContentView(isExiting: isExiting)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    store.dismiss()
                }
                .transition(.opacity)
                .zIndex(1000)
            }
        }
        .onChange(of: store.displayImmersiveOverlay) { _, isDisplaying in
            if isDisplaying {
                isExiting = false
                withAnimation(.easeIn(duration: 0.15)) {
                    isVisible = true
                }
            } else {
                isExiting = true
                // Allow exit animations to play before removing the view
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                    withAnimation(.easeOut(duration: 0.15)) {
                        isVisible = false
                    }
                    isExiting = false
                }
            }
        }
    }
}
