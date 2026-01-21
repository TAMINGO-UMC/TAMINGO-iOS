import SwiftUI
import Combine

struct LoginView: View {
    
    @ObservedObject var vm: LoginViewModel
    @State private var goSignup = false
    @Environment(SignupProgressStore.self) private var progressStore
    @Environment(SignupSessionStore.self) private var sessionStore
    
    enum Field: Hashable { case id, password }
    @FocusState private var focus: Field?
    
    init(vm: LoginViewModel) {
        self.vm = vm
    }
    var body: some View {
            content
                .navigationDestination(isPresented: $goSignup) {
                    SignupEntryView()
                }
                .onReceive(vm.actionPublisher) { action in
                    switch action {
                    case .goSignup:
                        goSignup = true
                        
                    case .loginSuccess(let id):
                        print("로그인 성공:", id)
                        // TODO: AppState setLoggedIn 등 처리
                        
                    case .kakaoLogin:
                        print("카카오 로그인 시작")
                    }
                }
        
    }
    
    private var content: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 70)
            
            VStack(spacing: 18) {
                Image("MainLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                
                Image("Title")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 46)
            }
            
            Spacer().frame(height: 46)
            
            VStack(alignment: .leading, spacing: 18) {
                
                Text("ID")
                    .font(.custom("Pretendard-Medium", size: 12))
                    .foregroundStyle(Color("Gray2"))
                
                LoginTextField(
                    placeholder: "아이디 입력",
                    text: $vm.id,
                    isSecure: false,
                    isFocused: focus == .id,
                    hasError: vm.isLoginFailed,
                    trailing: nil
                )
                .focused($focus, equals: .id)
                .submitLabel(.next)
                .onSubmit { focus = .password }
                .onChange(of: vm.id) { _, _ in vm.clearErrorIfNeeded() }
                
                Text("Password")
                    .font(.custom("Pretendard-Medium", size: 12))
                    .foregroundStyle(Color("Gray2"))
                    .padding(.top, 8)
                
                LoginTextField(
                    placeholder: "비밀번호 입력",
                    text: $vm.password,
                    isSecure: !vm.isPasswordVisible,
                    isFocused: focus == .password,
                    hasError: vm.isLoginFailed,
                    trailing: AnyView(
                        Button { vm.isPasswordVisible.toggle() } label: {
                            Image(systemName: vm.isPasswordVisible ? "eye" : "eye.slash")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color("Gray1"))
                                .frame(width: 34, height: 34)
                        }
                    )
                )
                .focused($focus, equals: .password)
                .submitLabel(.done)
                .onSubmit { focus = nil }
                .onChange(of: vm.password) { _, _ in vm.clearErrorIfNeeded() }
                
                if let msg = vm.errorMessage {
                    Text(msg)
                        .font(.custom("Pretendard-Medium", size: 12))
                        .foregroundStyle(Color("MainPink"))
                        .padding(.top, 2)
                }
            }
            .padding(.horizontal, 30)
            
            Spacer().frame(height: 22)
            
            PrimaryActionButton(
                title: "로그인",
                isEnabled: vm.canLogin
            ) {
                focus = nil
                vm.loginTapped()
                
                if vm.isLoginFailed {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        focus = .id
                    }
                }
            }
            .padding(.horizontal, 30)
            .padding(.top, 8)
            
            Spacer().frame(height: 18)
            
            HStack(spacing: 8) {
                Text("타밍고가 처음이신가요?")
                    .font(.medium12)
                    .foregroundStyle(.black)
                
                Button {
                    vm.signupTapped()
                } label: {
                    Text("회원가입하기")
                        .font(.semiBold12)
                        .foregroundStyle(Color("MainPink"))
                        .underline()
                }
            }
            .padding(.top, 6)
            
            Rectangle()
                .fill(Color("Gray1"))
                .frame(height: 1)
                .padding(.horizontal, 30)
                .padding(.top, 20)
            
            Spacer().frame(height: 20)
            
            Button {
                vm.kakaoLoginTapped()
            } label: {
                HStack(spacing: 10) {
                    Image("KakaoIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)

                    Text("카카오 로그인")
                        .font(.semiBold14)
                        .foregroundStyle(.black)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 47)
                .background(Color(red: 1.0, green: 0.93, blue: 0.33))
                .cornerRadius(5)
            }
            .padding(.horizontal, 30)
            .padding(.top, 6)
        }
    }
    
   
    private struct LoginTextField: View {
        let placeholder: String
        @Binding var text: String
        
        let isSecure: Bool
        let isFocused: Bool
        let hasError: Bool
        let trailing: AnyView?
        
        private var strokeColor: Color {
            if hasError { return Color("MainPink") }
            return isFocused ? Color("MainMint") : Color("Gray1")
        }
        
        private var strokeWidth: CGFloat {
           return 1
        }
        
        init(
            placeholder: String,
            text: Binding<String>,
            isSecure: Bool,
            isFocused: Bool,
            hasError: Bool,
            trailing: AnyView? = nil
        ) {
            self.placeholder = placeholder
            self._text = text
            self.isSecure = isSecure
            self.isFocused = isFocused
            self.hasError = hasError
            self.trailing = trailing
        }
        
        var body: some View {
            HStack(spacing: 8) {
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .font(.medium14)
                        .padding(.leading, 16)
                        .frame(height: 52)
                } else {
                    TextField(placeholder, text: $text)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .font(.medium14)
                        .padding(.leading, 16)
                        .frame(height: 52)
                }
                
                Spacer()
                
                if let trailing {
                    trailing
                        .padding(.trailing, 12)
                }
            }
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(strokeColor, lineWidth: strokeWidth)
            )
        }
    }
    
    
}
