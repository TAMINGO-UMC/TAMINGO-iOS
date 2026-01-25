import SwiftUI
struct SignupEntryView: View {
    @Environment(SignupProgressStore.self) private var progressStore

    var body: some View {
        TermsAgreementView()
            .onAppear {
                Task { @MainActor in
                    progressStore.set(1.0/3.0, animated: false)
                }
            }
    }
}
