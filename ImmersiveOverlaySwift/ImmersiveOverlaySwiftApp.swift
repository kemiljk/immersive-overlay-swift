import SwiftUI

@main
struct ImmersiveOverlaySwiftApp: App {

    @State private var store = ImmersiveOverlayStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
        }
    }
}
