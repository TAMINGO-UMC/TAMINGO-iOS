import SwiftUI

@main
struct TamingoApp: App {
    @State private var signupProgressStore = SignupProgressStore()
    @State private var signupSessionStore  = SignupSessionStore()

    var body: some Scene {
        WindowGroup {
            MainTabContainerView()
                .environment(signupProgressStore)
                .environment(signupSessionStore)
        }
    }
}
