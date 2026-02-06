import SwiftUI

@main
struct TamingoApp: App {
    @State private var signupProgressStore = SignupProgressStore()
    @State private var signupSessionStore  = SignupSessionStore()

    var body: some Scene {
        WindowGroup {
            LoginRootView()
                .environment(signupProgressStore)
                .environment(signupSessionStore)
        }
    }
}
