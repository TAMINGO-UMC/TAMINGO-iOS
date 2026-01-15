import Foundation
import Observation
enum Mode {
    case mock
    case live
}
@Observable
final class EmailSignupViewModel {
    //주입
    private let repo: EmailVerificationProtocol

    init(mode: Mode, baseURL: URL? = nil) {
        switch mode {
        case .mock:
            self.repo = EmailVerificationRepositoryMock()
        case .live:
            // Live 호출 시에 BaseURL은 APITargetType에 의해 자동으로 들어감 (따로 guard let 사용할 필요 없음.)
            self.repo = EmailVerificationRepositoryLive()
        }
    }

    // MARK: - State

    var emailLocal: String = ""
    var domain: String = "naver.com"
    var customDomain: String = ""

    let domainOptions: [String] = ["naver.com", "daum.net", "gmail.com", "직접입력"]

    var isCustomDomain: Bool { domain == "직접입력" }
    var resolvedDomain: String { isCustomDomain ? customDomain.trimmingCharacters(in: .whitespacesAndNewlines) : domain }

    var email: String {
        let local = emailLocal.trimmingCharacters(in: .whitespacesAndNewlines)
        let dom = resolvedDomain
        guard !local.isEmpty, !dom.isEmpty else { return "" }
        return "\(local)@\(dom)"
    }

    var isLoading: Bool = false
    var errorMessage: String? = nil

    // 인증 섹션
    var isCodeSectionVisible: Bool = false
    var expiresInSec: Int = 0
    var secondsRemaining: Int = 0
    private var timer: Timer?

    // 입력 코드
    var inputCode: String = ""

    // 서버가 주는 인증 완료 토큰
    var verificationToken: String? = nil
    var tokenExpiresInSec: Int = 0

    var isVerified: Bool { verificationToken != nil }

 

    var canSendCode: Bool { EmailValidator.isValid(email) }
    var canConfirmCode: Bool {
        inputCode.count == 6 && secondsRemaining > 0 && !isLoading
    }

  
    @MainActor
    func primaryAction(onNext: @escaping (String, String) -> Void) {
        switch primaryState {
        case .sendCodeEnabled:
            Task { await sendCode() }

        case .nextEnabledVerified:
            if let token = verificationToken {
                onNext(email, token)
            }

        case .nextDisabled, .nextDisabledAfterSend:
            break
        }
    }

    @MainActor
    func sendCode() async {
        errorMessage = nil
        guard canSendCode else { return }

        isLoading = true
        
        defer { isLoading = false }
        do {
            let res = try await repo.sendCode(email: email)
            expiresInSec = res.expiresInSec

            // UI: 같은 화면에서 인증번호 입력 섹션 등장
            isCodeSectionVisible = true
            inputCode = ""
            verificationToken = nil

            startTimer(seconds: res.expiresInSec) //서버 응답을 기준으로
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "인증번호 발송에 실패했습니다."
        }
    }

    @MainActor
    func confirmCode() async {
        errorMessage = nil
        guard canConfirmCode else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let res = try await repo.verifyCode(code: inputCode)
            verificationToken = res.verificationToken
            tokenExpiresInSec = res.tokenExpiresInSec
            stopTimer()
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "인증에 실패했습니다."
        }
    }

    @MainActor
    func resendCode() async {
        await sendCode()
    }
    @MainActor
    func beginEditEmail() {
        // 인증 섹션/타이머/검증 상태 초기화
        isCodeSectionVisible = false
        inputCode = ""
        verificationToken = nil
        errorMessage = nil

        expiresInSec = 0
        secondsRemaining = 0
        stopTimer()
    }
    // MARK: - Timer

    private func startTimer(seconds: Int) {
        stopTimer()
        secondsRemaining = seconds

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            if self.secondsRemaining > 0 {
                self.secondsRemaining -= 1
            } else {
                self.stopTimer()
                self.errorMessage = "인증 시간이 만료되었습니다. 재전송 해주세요."
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func formattedTime() -> String {
        let m = secondsRemaining / 60
        let s = secondsRemaining % 60
        return String(format: "%d:%02d", m, s)
    }

    deinit { timer?.invalidate() }
}

extension EmailSignupViewModel {
    enum PrimaryButtonState {
        case nextDisabled            // 초기 (다음 비활성)
        case sendCodeEnabled         // 이메일 유효 (인증번호 보내기 활성)
        case nextDisabledAfterSend   // 인증번호 보낸 뒤 (다음 비활성)
        case nextEnabledVerified     // 인증 완료 (다음 활성)
    }

    var primaryState: PrimaryButtonState {
        if isVerified { return .nextEnabledVerified }
        if isCodeSectionVisible { return .nextDisabledAfterSend }
        if canSendCode { return .sendCodeEnabled }
        return .nextDisabled
    }

    var primaryTitle: String {
        switch primaryState {
        case .sendCodeEnabled: return "인증번호 보내기"
        case .nextDisabled, .nextDisabledAfterSend, .nextEnabledVerified: return "다음"
        }
    }

    var primaryEnabled: Bool {
        switch primaryState {
        case .sendCodeEnabled: return !isLoading
        case .nextEnabledVerified: return !isLoading
        case .nextDisabled, .nextDisabledAfterSend: return false
        }
    }

}
