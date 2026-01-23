import SwiftUI

struct EmailInputView: View {
    @Environment(SignupProgressStore.self) private var progressStore
    @Environment(SignupSessionStore.self) private var sessionStore
    @Environment(\.dismiss) private var dismiss
    @State var vm: EmailInputViewModel = .init(mode: .mock)

    @State private var goToIdCreate = false
    @FocusState private var isCodeFocused: Bool

    var body: some View {
        VStack(spacing: 0) {

            SignupTopBar(
                progress: progressStore.progress,
                title: "이메일 인증",
                onBack: {dismiss()}  // 첫 화면이면 nil 처리 (또는 dismiss 처리)
            )

            VStack(alignment: .leading, spacing: 10) {
                Text("이메일을 입력해주세요.")
                    .font(.semiBold16)
                    .foregroundStyle(Color("Gray2"))

                Text("이메일")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color("Gray2"))
                    .padding(.top, 45)

                HStack(spacing: 8) {
                    TextField("", text: $vm.emailLocal)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(.emailAddress)
                        .font(.system(size: 16))
                        .padding(.vertical, 8)

                    Text("@")
                        .font(.system(size: 16))
                        .foregroundStyle(Color("Gray1"))

                    Menu {
                        ForEach(vm.domainOptions, id: \.self) { d in
                            Button(d) {
                                vm.domain = d
                                if d != "직접입력" { vm.customDomain = "" }
                            }
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Text(vm.isCustomDomain ? "직접입력" : vm.domain)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(Color("Gray1"))

                            Image(systemName: "chevron.down")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(Color("Gray1").opacity(0.8))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("Gray1").opacity(0.25), lineWidth: 1)
                        )
                    }
                }

                Rectangle()
                    .fill(Color("MainMint").opacity(vm.emailLocal.isEmpty ? 0.35 : 1.0))
                    .frame(height: 2)
                    .padding(.top, 2)

                if vm.isCustomDomain {
                    TextField("example.com", text: $vm.customDomain)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(.URL)
                        .font(.system(size: 14))
                        .padding(.top, 10)

                    Rectangle()
                        .fill(Color("Gray1").opacity(0.25))
                        .frame(height: 1)
                }

                if let msg = vm.errorMessage {
                    Text(msg)
                        .font(.system(size: 12))
                        .foregroundStyle(.red)
                        .padding(.top, 6)
                }

                if vm.isCodeSectionVisible {
                    codeSection
                        .transition(.opacity.combined(with: .move(edge: .top)))
                        .padding(.top, 16)
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)

            PrimaryActionButton(
                title: vm.primaryTitle,
                isEnabled: vm.primaryEnabled
            ) {
                vm.primaryAction { email, token in
                    Task { @MainActor in
                        sessionStore.email = email
                        sessionStore.verificationToken = token
                        progressStore.set(2.0/3.0, animated: true)
                        goToIdCreate = true
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(Color.white)
        .navigationDestination(isPresented: $goToIdCreate) {
            IdCreateView()
                .navigationBarBackButtonHidden(true)  
        }
        .onAppear {
            Task { @MainActor in
                progressStore.set(1.0/3.0, animated: false)
            }
        }
    }

    @ViewBuilder
    private var codeSection: some View {
        VStack(alignment: .leading, spacing: 10) {

            HStack(alignment: .center) {
                Text("인증번호")
                    .font(.medium12)
                    .foregroundStyle(Color("Gray1"))

                Spacer()

                // "인증번호 보내기" 눌러서 codeSection 뜨면 바로 활성화
                let confirmButtonEnabled = vm.isCodeSectionVisible && !vm.isLoading && vm.secondsRemaining > 0

                Button {
                    guard vm.inputCode.count == 6 else {
                        vm.errorMessage = "인증번호를 입력해주세요."
                        return
                    }
                    Task { await vm.confirmCode() }
                } label: {
                    Text("인증하기")
                        .font(.medium12)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .foregroundStyle(confirmButtonEnabled ? .white : Color("Gray1"))
                        .background(confirmButtonEnabled ? Color("MainMint") : Color("Gray1"))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .disabled(!confirmButtonEnabled)
            }

            TextField("6자리 숫자", text: $vm.inputCode)
                .keyboardType(.numberPad)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .font(.system(size: 16))
                .padding(.vertical, 10)
                .focused($isCodeFocused)
                .underline(isFocused: isCodeFocused)

            if vm.isVerified {
                HStack {
                    Spacer()
                    Text("인증완료")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color("MainMint"))
                }
            } else {
                HStack(spacing: 10) {
                    Spacer()

                    if vm.secondsRemaining > 0 {
                        Text(vm.formattedTime())
                            .font(.medium12)
                            .foregroundStyle(Color("MainPink"))
                    }

                    Button {
                        Task { await vm.resendCode() }
                    } label: {
                        Text("인증번호 재전송")
                            .font(.medium12)
                            .foregroundStyle(.black)
                            .underline()
                    }
                    .disabled(!vm.canSendCode)
                }
            }
        }
    }
}

