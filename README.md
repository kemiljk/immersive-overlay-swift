# ImmersiveOverlay — Swift Package

A SwiftUI package that recreates the immersive overlay animation inspired by Apple Intelligence.  
Original concept by [@eds2002](https://github.com/eds2002) — [immersive-overlay-example](https://github.com/eds2002/immersive-overlay-example).  
Swift/SwiftUI port by [@kemiljk](https://github.com/kemiljk).

## Requirements

- **Xcode 15+**
- **iOS 17+**

## Installation

### Swift Package Manager

In Xcode: **File → Add Package Dependencies…**, paste the repository URL, and add the `ImmersiveOverlay` library to your target.

Or add it directly to `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/kemiljk/immersive-overlay-swift", from: "1.0.0"),
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "ImmersiveOverlay", package: "immersive-overlay-swift"),
        ]
    ),
]
```

## Usage

### 1 — Add the modifier at the root of your hierarchy

Apply `.immersiveOverlay()` once, near the top of your view tree (e.g. inside `WindowGroup`).  
This creates and injects an `ImmersiveOverlayStore` into the SwiftUI environment.

```swift
import SwiftUI
import ImmersiveOverlay

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .immersiveOverlay()          // default blue/orange palette
        }
    }
}
```

### 2 — Trigger the overlay from any descendant view

```swift
import SwiftUI
import ImmersiveOverlay

struct ContentView: View {
    @Environment(ImmersiveOverlayStore.self) private var store

    var body: some View {
        Button("Immerse") {
            store.immerse()
        }
    }
}
```

Tapping anywhere on the overlay dismisses it, or call `store.dismiss()` programmatically.

---

## Customising the Colours

### Variadic convenience overload

Pass primary, secondary, and one or more expanding-circle colours directly:

```swift
ContentView()
    .immersiveOverlay(
        primary: .pink,
        secondary: .indigo,
        expandingColors: .orange, .red, .pink
    )
```

### `OverlayColors` struct

For full control — including separate dark / light palettes — use `OverlayColors`:

```swift
ContentView()
    .immersiveOverlay(
        colors: OverlayColors(
            primary: Color(hex: "#FF69B4"),
            secondary: Color(hex: "#1E90FF"),
            expandingDark:  [Color(hex: "#FF69B4"), Color(hex: "#DA70D6"), Color(hex: "#1E90FF")],
            expandingLight: [Color(hex: "#FF69B4"), Color(hex: "#DA70D6"), Color(hex: "#1E90FF")]
        )
    )
```

### Per-trigger override

You can also override colours (and inject content) at call-site:

```swift
store.immerse(
    component: AnyView(MyCustomView()),
    colors: OverlayColors(
        primary: .red, secondary: .orange,
        expandingDark:  [.red, .orange],
        expandingLight: [.red, .orange]
    )
)
```

---

## How the Overlay Works

1. **Warp effect** — The background content warps with a rotateX/skewY/scale animation before springing back (physics-based "push" feel).
2. **Expanding circle** — A blurred circle grows from the bottom-centre, sweeping through the expanding colour palette.
3. **Background blobs** — Two large blurred colour circles (primary top-left, secondary bottom-right) breathe in and out continuously.
4. **Blur backdrop** — A `UIVisualEffectView` blur fades in behind the content.
5. **Overlay content** — Custom content enters with a 3D perspective animation and exits with a collapse + fade.

---

## Package Structure

```
Sources/ImmersiveOverlay/
├── OverlayColors.swift              # Public OverlayColors struct
├── ImmersiveOverlayStore.swift      # Public @Observable state container
├── ColorUtils.swift                 # Color(hex:) extension + color helpers
├── ImmersiveOverlayView.swift       # Public warp-effect wrapper view
├── View+ImmersiveOverlay.swift      # Public .immersiveOverlay() modifier
├── OverlayView.swift                # Full-screen overlay container
├── GradientView.swift               # Circles, blur & breathing animations
└── OverlayContentView.swift         # Animated overlay content
```

The `ImmersiveOverlaySwift/` folder contains the original demo app (Xcode project).

---

## Original vs. This Package

| Original (Expo/React Native) | This package (Swift/SwiftUI) |
|---|---|
| `react-native-reanimated` | SwiftUI `.animation()` / `withAnimation` |
| `@shopify/react-native-skia` | SwiftUI `Circle()` + `.blur()` |
| `expo-blur` `BlurView` | `UIVisualEffectView` via `UIViewRepresentable` |
| `zustand` store | `@Observable` class (iOS 17+) |
| Animated transforms | `.rotation3DEffect()`, `.scaleEffect()`, `CGAffineTransform` skew |
| `tinycolor2` | Native `UIColor` / `Color` alpha manipulation |
| `Easing.bezier` | `Animation.timingCurve()` |

## Attribution

Original concept and implementation by [@eds2002](https://github.com/eds2002).  
Swift/SwiftUI port by [@kemiljk](https://github.com/kemiljk).
