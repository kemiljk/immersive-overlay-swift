# Immersive Overlay — Pure Swift/SwiftUI

Pure Swift/SwiftUI port of the immersive overlay animation inspired by Apple Intelligence, originally created by [@eds2002](https://github.com/eds2002).

Original project: [eds2002/immersive-overlay-example](https://github.com/eds2002/immersive-overlay-example)

## Overview

This project replicates the immersive overlay component from an Expo/React Native TypeScript app into a fully native iOS app using SwiftUI and Core Animation — **zero third-party dependencies**.

| Original (Expo/React Native) | This project (Swift/SwiftUI) |
|---|---|
| `react-native-reanimated` | SwiftUI `.animation()` / `withAnimation` |
| `@shopify/react-native-skia` | SwiftUI `Circle()` + `.blur()` modifier |
| `expo-blur` `BlurView` | `UIVisualEffectView` via `UIViewRepresentable` |
| `zustand` store | `@Observable` class (iOS 17+) |
| Animated transforms | `.rotation3DEffect()`, `.scaleEffect()`, `CGAffineTransform` skew |
| `tinycolor2` | Native `UIColor` / `Color` alpha manipulation |
| `Easing.bezier` | `Animation.timingCurve()` |

## Requirements

- **Xcode 15+**
- **iOS 17+**

## How to Run

1. Open `ImmersiveOverlaySwift.xcodeproj` in Xcode
2. Select an iPhone simulator or device (iOS 17+)
3. Press **⌘R** to build and run

## Demo Buttons

The home screen contains three demo buttons, each triggering the overlay with different visual palettes:

| Button | Description |
|--------|-------------|
| **Basic** | Default palette — primary `#5465ff`, expanding from orange → red → blue |
| **w/ different palette** | Hot pink + dodger blue palette |
| **w/ component & different palette** | Red palette + overlay content showing "dimelo" title with multilingual hello text |

## How the Overlay Works

1. **Warp effect** — When the overlay opens, the background content warps with a rotateX/skewY/scale sequence animation before springing back, simulating a physics-based "push" feel.
2. **Expanding circle** — A blurred circle expands from the bottom-center of the screen, interpolating through the palette colors.
3. **Background blobs** — Two large blurred color circles (primary top-left, secondary bottom-right) breathe in and out continuously.
4. **Blur backdrop** — A `UIVisualEffectView` blur fades in behind the content.
5. **Overlay content** — Custom content enters with a 3D perspective animation and exits with a collapse + fade.

## Project Structure

```
ImmersiveOverlaySwift/
├── ImmersiveOverlaySwiftApp.swift      # App entry point
├── ContentView.swift                    # Home screen (3 demo buttons)
├── Assets.xcassets/                     # App icon + accent color
├── Preview Content/
│   └── Preview Assets.xcassets/
└── ImmersiveOverlay/
    ├── ImmersiveOverlayStore.swift      # @Observable state management
    ├── ColorUtils.swift                 # Hex color init + generateColors()
    ├── ImmersiveOverlayView.swift       # Warp-effect wrapper view
    ├── OverlayView.swift                # Full-screen overlay container
    ├── GradientView.swift               # Circles, blur, breathing animations
    └── OverlayContentView.swift         # Animated overlay content
```

## Attribution

Original concept and implementation by [@eds2002](https://github.com/eds2002).  
Swift/SwiftUI port by [@kemiljk](https://github.com/kemiljk).
