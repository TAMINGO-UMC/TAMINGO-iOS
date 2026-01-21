import SwiftUI

struct TermsAgreementView: View {
    @Environment(\.dismiss) private var dismiss

  
    @State private var agreeService = false
    @State private var agreePrivacy = false
    @State private var agreeAI = false
    @State private var agreeLocation = false

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

                // 로고, 문구
                VStack(spacing: 45.53) {
                    Image("Title")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 29.55)

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
        attr.font = .bold22
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

    var body: some View {
        VStack(spacing: rowSpacing) {


            AllAgreementRow(
                title: allTitle,
                subtitle: allSubtitle,
                isOn: allIsOn,
                rowHPadding: rowHPadding
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

    var body: some View {
        HStack(spacing: 10) {
            HStack(spacing: 5) {
                Text(title)
                    .font(.semiBold14)
                    .foregroundStyle(.black)

                Text(subtitle)
                    .font(.medium12)
                    .foregroundStyle(Color("Gray2"))
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
                    .foregroundStyle(Color.black.opacity(0.35))
                    .underline(true, color: Color("Gray1"))

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

    private let size: CGFloat = 28
    private let radius: CGFloat = 6

    var body: some View {
        RoundedRectangle(cornerRadius: radius)
            .stroke(isOn ? activeColor : Color("Gray1"), lineWidth: 1.5)
            .frame(width: size, height: size)
            .overlay {
                Image(systemName: "checkmark")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(isOn ? activeColor : Color("Gray1"))
            }
            .contentShape(Rectangle())
    }
}
