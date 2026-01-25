import SwiftUI

struct TermsAgreementView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(SignupSessionStore.self) private var sessionStore

    // 필수
    @State private var agreeService = false
    @State private var agreePrivacy = false
    @State private var agreeAI = false
    @State private var agreeLocation = false

    // 선택
    @State private var agreeMarketing = false

    @State private var goToEmail = false

    private var isRequiredAllChecked: Bool {
        agreeService && agreePrivacy && agreeAI && agreeLocation
    }

    private var isAllChecked: Bool {
        isRequiredAllChecked && agreeMarketing
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
                        //뒤로가기 버튼 추가
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
                                    .padding(12) // 터치영역 확보
                            }
                            .buttonStyle(.plain)
                            .offset(x: -90, y: -40)
                        }

                    agreementTitle
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 26)

                AgreementBox(
                    allTitle: "전체 동의",
                    allSubtitle: "(선택항목 포함)",
                    allIsOn: Binding(
                        get: { isAllChecked },
                        set: { setAll($0) }
                    ),
                    items: [
                        .init(title: "이용약관 동의", subtitle: "(필수)", required: true, isOn: $agreeService),
                        .init(title: "개인정보 수집 및 이용 동의", subtitle: "(필수)", required: true, isOn: $agreePrivacy),
                        .init(title: "AI기반 서비스 이용약관 동의", subtitle: "(필수)", required: true, isOn: $agreeAI),
                        .init(title: "위치기반 서비스 이용약관 동의", subtitle: "(필수)", required: true, isOn: $agreeLocation),
                        .init(title: "마케팅 알림 수신 동의", subtitle: "(선택)", required: false, isOn: $agreeMarketing),
                    ]
                )
                .padding(.horizontal, 20)

                Spacer()

                PrimaryActionButton(
                    title: "다음",
                    isEnabled: isRequiredAllChecked
                ) {
                    goToEmail = true
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
        agreeService = on
        agreePrivacy = on
        agreeAI = on
        agreeLocation = on
        agreeMarketing = on
    }
}

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

    // Row 공통 패딩/간격 (전체동의/항목 동일)
    private let rowHPadding: CGFloat = 14
    private let rowSpacing: CGFloat = 18
    
    private let titleFont: Font = .semiBold14
    private let subtitleFont: Font = .medium12
    private let titleColor: Color = Color(.black)     // 또는 .black
    private let subtitleColor: Color = Color("Gray2")  // 또는 .gray
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
