import SwiftUI
import Combine

private enum Asset {
    static let check = "Check"
    static let error = "Error"
}

struct IdCreateView: View {
    @Environment(SignupProgressStore.self) private var progressStore
    @Environment(SignupSessionStore.self) private var sessionStore
    @Environment(\.dismiss) private var dismiss
    @State var vm: IdCreateViewModel = .init(email: "")
    @State private var goToComplete = false

    private enum Field: Hashable { case nickname, password, confirm }
    @FocusState private var focus: Field?
  
    
    var body: some View {
        VStack(spacing: 0) {

            SignupTopBar(
                progress: progressStore.progress,
                title: "아이디 생성",
                onBack: {
                    Task { @MainActor in
                        progressStore.set(2.0/3.0, animated: true)
                    }
                    dismiss()
                }
            )

            VStack(alignment: .leading, spacing: 30) {

                FieldRow(
                    title: "이메일",
                    valueText: vm.email,
                    rightIcon: .check,
                    isFocused: false,
                    isEditable: false,
                    isSecure: false
                )

                FieldRow(
                    title: "닉네임",
                    binding: $vm.nickname,
                    rightIcon: vm.nicknameDone ? .check : .none,
                    isFocused: focus == .nickname,
                    isEditable: true,
                    isSecure: false
                )
                .focused($focus, equals: .nickname)
                .submitLabel(.next)

                FieldRow(
                    title: "비밀번호",
                    binding: $vm.password,
                    rightIcon: .none,
                    isFocused: focus == .password,
                    isEditable: vm.canEditPassword,
                    isSecure: true
                )
                .focused($focus, equals: .password)
                .submitLabel(.next)

                VStack(alignment: .leading, spacing: 8) {
                    FieldRow(
                        title: "비밀번호 재입력",
                        binding: $vm.confirmPassword,
                        rightIcon: vm.confirmDone ? (vm.isMatch ? .check : .error) : .none,
                        isFocused: focus == .confirm,
                        isEditable: vm.canEditConfirm,
                        isSecure: true
                    )
                    .focused($focus, equals: .confirm)
                    .submitLabel(.done)
                    .onSubmit { focus = nil }

                    if vm.confirmDone {
                        Text(vm.isMatch ? "비밀번호가 일치합니다." : "비밀번호가 일치하지 않습니다.")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(vm.isMatch ? Color("MainMint") : .red)
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 28)
            .padding(.top, 36)
            
            Spacer()
            
            PrimaryActionButton(title: "다음", isEnabled: vm.canNext) {
                // 세션 저장
                sessionStore.nickname = vm.nickname
                sessionStore.password = vm.password
                
                Task { @MainActor in
                    progressStore.set(1.0, animated: true)
                }
                goToComplete = true
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(Color.white)
        .navigationDestination(isPresented: $goToComplete) {
            SignupCompleteView()
                .navigationBarBackButtonHidden(true)
        }
        .onAppear {
            if vm.email.isEmpty {
                vm = IdCreateViewModel(email: sessionStore.email)
            }
        }
        .navigationBarBackButtonHidden(true) 
    }
}

    private enum RightIconType { case none, check, error }

    private struct FieldRow: View {
        let title: String
        var valueText: String? = nil
        var binding: Binding<String>? = nil

        let rightIcon: RightIconType
        let isFocused: Bool
        let isEditable: Bool
        let isSecure: Bool

        init(title: String, valueText: String, rightIcon: RightIconType, isFocused: Bool, isEditable: Bool, isSecure: Bool) {
            self.title = title
            self.valueText = valueText
            self.rightIcon = rightIcon
            self.isFocused = isFocused
            self.isEditable = isEditable
            self.isSecure = isSecure
        }

        init(title: String, binding: Binding<String>, rightIcon: RightIconType, isFocused: Bool, isEditable: Bool, isSecure: Bool) {
            self.title = title
            self.binding = binding
            self.rightIcon = rightIcon
            self.isFocused = isFocused
            self.isEditable = isEditable
            self.isSecure = isSecure
        }

        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color("Gray2"))

                HStack(spacing: 8) {
                    if let valueText {
                        Text(valueText)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color("Gray2"))
                    } else if let binding {
                        if isSecure {
                            SecureField("", text: binding)
                                .font(.system(size: 16, weight: .medium))
                                .disabled(!isEditable)
                                .opacity(isEditable ? 1.0 : 0.45)
                                .textContentType(.oneTimeCode)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                        } else {
                            TextField("", text: binding)
                                .font(.system(size: 16, weight: .medium))
                                .disabled(!isEditable)
                                .opacity(isEditable ? 1.0 : 0.45)
                        }
                    }

                    Spacer()

                    switch rightIcon {
                    case .none: EmptyView()
                    case .check: Image(Asset.check).resizable().frame(width: 18, height: 18)
                    case .error: Image(Asset.error).resizable().frame(width: 18, height: 18)
                    }
                }

                Rectangle()
                    .fill(Color("MainMint").opacity(isFocused ? 1.0 : 0.25))
                    .frame(height: isFocused ? 2 : 1)
            }
        }
    }

