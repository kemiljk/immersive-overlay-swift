import SwiftUI

/// The home screen with three demo buttons.
struct ContentView: View {

    @Environment(ImmersiveOverlayStore.self) private var store

    var body: some View {
        ImmersiveOverlayView {
            NavigationStack {
                VStack(spacing: 20) {
                    // ── Button 1: Basic ──────────────────────────────────────────
                    Button {
                        store.immerse()
                    } label: {
                        Text("Basic")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(hex: "#5465ff"))

                    // ── Button 2: Different palette ──────────────────────────────
                    Button {
                        store.immerse(
                            colors: OverlayColors(
                                primary:       Color(hex: "#FF69B4"),
                                secondary:     Color(hex: "#1E90FF"),
                                expandingDark: [
                                    Color(hex: "#FF69B4"),
                                    Color(hex: "#DA70D6"),
                                    Color(hex: "#1E90FF"),
                                ],
                                expandingLight: [
                                    Color(hex: "#FF69B4"),
                                    Color(hex: "#DA70D6"),
                                    Color(hex: "#1E90FF"),
                                ]
                            )
                        )
                    } label: {
                        Text("w/ different palette")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(hex: "#FF69B4"))

                    // ── Button 3: Component + palette ────────────────────────────
                    Button {
                        store.immerse(
                            component: AnyView(HelloOverlayContent()),
                            colors: OverlayColors(
                                primary:       Color(hex: "#FF0000"),
                                secondary:     Color(hex: "#8B0000"),
                                expandingDark: [
                                    Color(hex: "#FF0000"),
                                    Color(hex: "#B22222"),
                                    Color(hex: "#8B0000"),
                                ],
                                expandingLight: [
                                    Color(hex: "#FF6347"),
                                    Color(hex: "#DC143C"),
                                    Color(hex: "#CD5C5C"),
                                ]
                            )
                        )
                    } label: {
                        Text("w/ component & different palette")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(hex: "#FF0000"))
                }
                .padding(.horizontal, 32)
                .navigationTitle("Immersive Overlay")
            }
        }
    }
}

// MARK: - Hello Overlay Content

/// Demo content shown inside the overlay for the third button.
struct HelloOverlayContent: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("dimelo")
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            VStack(spacing: 4) {
                ForEach(greetings, id: \.self) { greeting in
                    Text(greeting)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
        }
        .multilineTextAlignment(.center)
        .padding()
    }

    private let greetings = [
        "Hello",
        "Hola",
        "Bonjour",
        "Ciao",
        "こんにちは",
        "مرحبا",
        "Olá",
        "Hallo",
    ]
}

#Preview {
    ContentView()
        .environment(ImmersiveOverlayStore())
}
