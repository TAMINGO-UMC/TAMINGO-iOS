//
//  TermsAgreementView.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/7/26.
//

import SwiftUI

struct TermsAgreementView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(SignupSessionStore.self) private var sessionStore
    
    @State private var repo: AuthRepositoryProtocol = AuthRepository()
    @State private var terms: [TermDTO] = []
    @State private var isLoading = false
    
    // 약관 동의 상태
    @State private var agreements: [String: Bool] = [:]
    @State private var goToEmail = false
    
    private var requiredTermCodes: [String] {
        terms.filter { $0.isRequired }.map { $0.code }
    }
    
    private var isRequiredAllChecked: Bool {
        requiredTermCodes.allSatisfy { agreements[$0] == true }
    }
    
    private var isAllChecked: Bool {
        terms.allSatisfy { agreements[$0.code] == true }
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                
                Spacer().frame(height: geo.safeAreaInsets.top)
                
                VStack(spacing: 45.53) {
                    
                    Image("Tamingo_logo_text")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 29.55)
                        .overlay(alignment: .leading) {
                            Button {
                                sessionStore.popToLoginFromEmail = true
                                dismiss()
                            } label: {
                                Image("Previous_Chevron")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 9.05, height: 15.35)
                                    .contentShape(Rectangle())
                                    .padding(12)
                            }
                            .buttonStyle(.plain)
                            .offset(x: -90, y: -40)
                        }
                    
                    agreementTitle
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 26)
                
                if isLoading {
                    ProgressView()
                        .padding()
                } else {
                    AgreementBox(
                        allTitle: "전체 동의",
                        allSubtitle: "(선택항목 포함)",
                        allIsOn: Binding(
                            get: { isAllChecked },
                            set: { setAll($0) }
                        ),
                        items: terms.map { term in
                            AgreementBox.Item(
                                title: term.title,
                                subtitle: term.isRequired ? "(필수)" : "(선택)",
                                required: term.isRequired,
                                isOn: Binding(
                                    get: { agreements[term.code] ?? false },
                                    set: { agreements[term.code] = $0 }
                                )
                            )
                        }
                    )
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                PrimaryActionButton(
                    title: "다음",
                    isEnabled: isRequiredAllChecked
                ) {
                    Task {
                        await createSession()
                    }
                }
                .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.white)
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $goToEmail) {
            EmailInputView()
                .navigationBarBackButtonHidden(true)
        }
        .task {
            await loadTerms()
        }
    }
    
    private var agreementTitle: some View {
        let full = "시작을 위해서는,\n약관 동의가 필요해요."
        var attr = AttributedString(full)
        attr.font = .pretendard(.semibold, size: 22)
        attr.foregroundColor = Color("Gray2")
        
        if let range = attr.range(of: "약관 동의") {
            attr[range].foregroundColor = Color("MainMint")
        }
        return Text(attr)
    }
    
    private func setAll(_ on: Bool) {
        for term in terms {
            agreements[term.code] = on
        }
    }
    
    // MARK: - API: 약관 목록 조회
    @MainActor
    private func loadTerms() async {
        isLoading = true
        defer { isLoading = false }
        
        // 1. 서버 API 호출 시도
        do {
            terms = try await repo.getTerms()
            print("약관 조회 성공: \(terms.count)개")
        } catch {
            print("약관 조회 실패, 하드코딩 데이터 사용")
            
            terms = [
                TermDTO(code: "SERVICE", title: "이용약관 동의", isRequired: true),
                TermDTO(code: "PRIVACY", title: "개인정보 수집 및 이용 동의", isRequired: true),
                TermDTO(code: "AI_SERVICE", title: "AI 기반 서비스 이용약관 동의", isRequired: true),
                TermDTO(code: "LOCATION", title: "위치기반 서비스 이용약관 동의", isRequired: true),
                TermDTO(code: "MARKETING", title: "마케팅 알림 수신 동의", isRequired: false)
            ]
        }
        
        // 초기값 설정
        for term in terms {
            agreements[term.code] = false
        }
    }
    
    // MARK: - API: 회원가입 세션 생성
    @MainActor
    private func createSession() async {
        
        var termsMap: [String: Bool] = [:]
        
        // 현재 화면에 있는 설정값 매핑
        for term in terms {
            termsMap[term.code] = agreements[term.code] ?? false
        }
        let requestDTO = CreateSessionRequestDTO(terms: termsMap)
        
        // 디버깅 로그
        print("[서버로 전송하는 Body - Map 형태]")
        if let jsonData = try? JSONEncoder().encode(requestDTO),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
        }
        
        do {
            let response = try await repo.createSession(terms: requestDTO)
            print("세션 생성 성공! ID: \(response.signupSessionId)")
            sessionStore.signupSessionId = response.signupSessionId
            goToEmail = true
        } catch {
            print("세션 생성 실패: \(error.localizedDescription)")
           
            
        }
    }
    
    // MARK: - 하위 뷰 (AgreementBox 등) - 기존과 동일
    private struct AgreementBox: View {
        
        struct Item {
            let title: String
            let subtitle: String
            let required: Bool
            var isOn: Binding<Bool>
        }
        
        let allTitle: String
        let allSubtitle: String
        var allIsOn: Binding<Bool>
        let items: [Item]
        
        private let rowHPadding: CGFloat = 14
        private let rowSpacing: CGFloat = 18
        
        private let titleFont: Font = .semiBold14
        private let subtitleFont: Font = .medium12
        private let titleColor: Color = Color(.black)
        private let subtitleColor: Color = Color("Gray2")
        
        var body: some View {
            VStack(spacing: rowSpacing) {
                
                AllAgreementRow(
                    title: allTitle,
                    subtitle: allSubtitle,
                    isOn: allIsOn,
                    rowHPadding: rowHPadding,
                    titleFont: titleFont,
                    subtitleFont: subtitleFont,
                    titleColor: titleColor,
                    subtitleColor: subtitleColor
                )
                
                VStack(spacing: rowSpacing) {
                    ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                        AgreementItemRow(
                            title: item.title,
                            subtitle: item.subtitle,
                            required: item.required,
                            isOn: item.isOn,
                            rowHPadding: rowHPadding
                        )
                    }
                }
                .padding(.top, 2)
            }
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private struct AllAgreementRow: View {
        let title: String
        let subtitle: String
        @Binding var isOn: Bool
        
        let rowHPadding: CGFloat
        
        var titleFont: Font? = nil
        var subtitleFont: Font? = nil
        var titleColor: Color? = nil
        var subtitleColor: Color? = nil
        
        var body: some View {
            HStack(spacing: 10) {
                HStack(spacing: 5) {
                    Text(title)
                        .font(titleFont ?? .semiBold14)
                        .foregroundStyle(titleColor ?? .black)
                    
                    Text(subtitle)
                        .font(subtitleFont ?? .medium12)
                        .foregroundStyle(subtitleColor ?? Color("Gray2"))
                }
                
                Spacer(minLength: 0)
                
                Button {
                    isOn.toggle()
                } label: {
                    GhostCheckBox(isOn: isOn, activeColor: Color("MainMint"))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, rowHPadding)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color("Gray1"), lineWidth: 1)
            )
            .frame(maxWidth: .infinity)
        }
    }
    
    private struct AgreementItemRow: View {
        let title: String
        let subtitle: String
        let required: Bool
        var isOn: Binding<Bool>
        
        let rowHPadding: CGFloat
        
        var body: some View {
            HStack(spacing: 10) {
                
                HStack(spacing: 2) {
                    Text(title)
                        .font(.medium12)
                        .foregroundStyle(Color("Gray2"))
                        .underline(true, color: Color("Gray2"))
                    
                    Text(subtitle)
                        .font(.medium12)
                        .foregroundStyle(required ? Color("MainPink") : Color("Gray1"))
                }
                
                Spacer(minLength: 0)
                
                Button {
                    isOn.wrappedValue.toggle()
                } label: {
                    GhostCheckBox(isOn: isOn.wrappedValue, activeColor: Color("MainMint"))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, rowHPadding)
            .padding(.vertical, 2)
            .frame(maxWidth: .infinity)
        }
    }
    
    private struct GhostCheckBox: View {
        let isOn: Bool
        let activeColor: Color
        
        private let size: CGFloat = 23
        private let radius: CGFloat = 6
        
        var body: some View {
            RoundedRectangle(cornerRadius: radius)
                .stroke(isOn ? activeColor : Color("Gray1"), lineWidth: 1.5)
                .frame(width: size, height: size)
                .overlay {
                    Image(isOn ? "MintVector": "Vector")
                        .resizable()
                        .frame(width:12.76, height:9.26)
                        .foregroundStyle(isOn ? activeColor : Color("Gray1"))
                }
                .contentShape(Rectangle())
        }
    }
}
