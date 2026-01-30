import SwiftUI

struct EmailInputView: View {
    @Environment(SignupProgressStore.self) private var progressStore
    @Environment(SignupSessionStore.self) private var sessionStore
    @Environment(\.dismiss) private var dismiss
    @State var vm: EmailInputViewModel = .init(mode: .mock)

    @State private var goToIdCreate = false
    @FocusState private var isCodeFocused: Bool

    @State private var isDomainMenuOpen = false      // 리스트 열렸다고 가정하는 상태
    @State private var didPickDomain = false         // 한 번이라도  선택/입력 했는지

    var body: some View {
        VStack(spacing: 0) {

            SignupTopBar(
                progress: progressStore.progress,
                title: "이메일 인증",
                onBack: {
                    sessionStore.popToLoginFromEmail = true
                    dismiss()
                }
            )

            VStack(alignment: .leading, spacing: 10) {
                Text("이메일을 입력해주세요.")
                    .font(.semiBold16)
                    .foregroundStyle(Color("Gray2"))

                Text("이메일")
                    .font(.medium12)
                    .foregroundStyle(Color("Gray2"))
                    .padding(.top, 45)

                // 인증 완료 시 잠금
                let locked = vm.isVerified

                // 입력 전/후 활성화 상태
                let isEmailActive = !vm.emailLocal.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty

                HStack(spacing: 8) {
                    TextField("", text: $vm.emailLocal)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(.emailAddress)
                        .font(.medium16)
                        .padding(.vertical, 4)
                        .disabled(locked) // 인증 완료 시 입력 잠금

                    Text("@")
                        .font(.semiBold20)
                        .foregroundStyle(isEmailActive ? Color("Gray2") : Color("Gray1"))

                    Menu {
                        ForEach(vm.domainOptions, id: \.self) { d in
                            Button(d) {
                                vm.domain = d
                                if d != "직접입력" { vm.customDomain = "" }

                                didPickDomain = true          //선택 이후
                                isDomainMenuOpen = false
                            }
                        }
                    } label: {
                        let textColor: Color = didPickDomain ? .black : Color("Gray1")
                        let chevronColor: Color = didPickDomain ? Color("Gray2") : Color("Gray1")
                        let strokeColor: Color =
                            isDomainMenuOpen ? Color("MainMint")
                            : (didPickDomain ? Color("Gray2") : Color("Gray1"))

                        HStack(spacing: 20) {
                            Text(vm.isCustomDomain ? "직접입력" : vm.domain)
                                .font(.medium12)
                                .foregroundStyle(textColor)
                                .lineLimit(1)
                            let chevronName = didPickDomain ? "Chevron_under" : "Chevron_under2"
                            let chevronColor: Color = didPickDomain ? Color("Gray2") : Color("Gray1")

                            Image(chevronName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12, height: 12)
                                .foregroundStyle(chevronColor)
                        }
                        .frame(width: 114, height: 32)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(strokeColor, lineWidth: 1)
                        )
                    }
                    .disabled(locked) // 인증 완료 시 도메인 변경 잠금
                    .simultaneousGesture(
                        TapGesture().onEnded {
                            // 잠겨있으면 열림 상태로 바꾸지 않기
                            guard !locked else { return }
                            isDomainMenuOpen = true
                        }
                    )
                }

               
                Rectangle()
                    .fill(isEmailActive ? Color("Gray2") : Color("Gray1"))
                    .frame(height: 2)
                    .padding(.top, 2)

                if vm.isCustomDomain {
                    TextField("example.com", text: $vm.customDomain)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(.URL)
                        .font(.system(size: 14))
                        .padding(.top, 10)
                        .disabled(locked) // 인증 완료 시 직접입력도 잠금

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
        .onChange(of: vm.isVerified) { _, v in
            // 인증 완료 후에 메뉴 열림 상태 
            if v { isDomainMenuOpen = false }
        }
    }

    @ViewBuilder
    private var codeSection: some View {
        let locked = vm.isVerified
        let confirmButtonEnabled =
            vm.isCodeSectionVisible && !vm.isLoading && vm.secondsRemaining > 0

        VStack(alignment: .leading, spacing: 6) {

            Text("인증번호")
                .font(.medium12)
                .foregroundStyle(Color("Gray2"))

            VStack(spacing: 4) {

                HStack(spacing: 12) {
                    TextField("6자리 숫자", text: $vm.inputCode)
                        .keyboardType(.numberPad)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .font(.medium16)
                        .padding(.vertical, 10)
                        .disabled(locked)
                        .frame(maxWidth: .infinity)

                    Button {
                        guard vm.inputCode.count == 6 else {
                            vm.errorMessage = "인증번호를 입력해주세요."
                            return
                        }
                        Task { await vm.confirmCode() }
                    } label: {
                        Text("인증하기")
                            .font(.medium12)
                            .frame(width: 78, height: 32)
                            .foregroundStyle(
                                (!locked && confirmButtonEnabled) ? .white : Color("Gray2")
                            )
                            .background(
                                (!locked && confirmButtonEnabled) ? Color("MainMint") : Color("Gray1")
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                    .disabled(locked || !confirmButtonEnabled)
                    .opacity(locked ? 0.6 : 1.0)
                }

                Rectangle()
                    .fill(Color("Gray2"))
                    .frame(height: 2)
            }

            if vm.isVerified {
                HStack {
                    Spacer()
                    Text("인증완료")
                        .font(.semiBold12)
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
                    .disabled(locked || !vm.canSendCode)
                }
            }
        }
    }
}
