import SwiftUI
import UIKit

// MARK: - Hex Color Initializer

extension Color {
    /// Initializes a `Color` from a CSS-style hex string, e.g. `"#5465ff"`, `"#RGB"`, or `"#AARRGGBB"`.
    public init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:  // #RGB
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:  // #RRGGBB
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:  // #AARRGGBB
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Generated Colors

struct GeneratedColors {
    let primary: Color
    let secondary: Color
    /// Processed expanding color stops (includes 0.95-alpha and 0.2-alpha variants of the last color).
    let expanding: [Color]
}

/// Converts an `OverlayColors` config into final `GeneratedColors`.
///
/// Rules (mirrors `utils.ts`):
/// - All but the last expanding color → 0.95 alpha
/// - Last expanding color → 0.95 alpha version appended, then 0.2 alpha version appended
func generateColors(colors: OverlayColors, colorScheme: ColorScheme) -> GeneratedColors {
    let source = colorScheme == .dark ? colors.expandingDark : colors.expandingLight
    var expanding: [Color] = []

    for (index, color) in source.enumerated() {
        if index < source.count - 1 {
            expanding.append(color.opacity(0.95))
        } else {
            expanding.append(color.opacity(0.95))
            expanding.append(color.opacity(0.2))
        }
    }

    return GeneratedColors(
        primary: colors.primary,
        secondary: colors.secondary,
        expanding: expanding
    )
}

// MARK: - Color Interpolation

/// Linearly interpolates through an array of colors given a normalized progress (0…1).
func interpolatedColor(colors: [Color], progress: Double) -> Color {
    guard !colors.isEmpty else { return .clear }
    guard colors.count > 1 else { return colors[0] }

    let clamped = max(0, min(1, progress))
    let scaledIndex = clamped * Double(colors.count - 1)
    let lower = Int(scaledIndex)
    let upper = min(lower + 1, colors.count - 1)
    let t = scaledIndex - Double(lower)

    let lowerUI = UIColor(colors[lower])
    let upperUI = UIColor(colors[upper])

    var lr: CGFloat = 0, lg: CGFloat = 0, lb: CGFloat = 0, la: CGFloat = 0
    var ur: CGFloat = 0, ug: CGFloat = 0, ub: CGFloat = 0, ua: CGFloat = 0
    lowerUI.getRed(&lr, green: &lg, blue: &lb, alpha: &la)
    upperUI.getRed(&ur, green: &ug, blue: &ub, alpha: &ua)

    return Color(
        red:     Double(lr + CGFloat(t) * (ur - lr)),
        green:   Double(lg + CGFloat(t) * (ug - lg)),
        blue:    Double(lb + CGFloat(t) * (ub - lb)),
        opacity: Double(la + CGFloat(t) * (ua - la))
    )
}
