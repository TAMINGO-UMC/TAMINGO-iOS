//
//  EmailInputViewModel.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/7/26.
//

import Foundation
import Observation

@Observable
final class EmailInputViewModel {
    // Repository 주입
    private let repo: AuthRepositoryProtocol
    
    init(repo: AuthRepositoryProtocol = AuthRepository()) {
        self.repo = repo
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
    
    // 인증 완료 여부
    var isVerified: Bool = false
    
    var canSendCode: Bool { EmailValidator.isValid(email) }
    var canConfirmCode: Bool {
        inputCode.count == 6 && secondsRemaining > 0 && !isLoading
    }
    
    // MARK: - Primary Action
    @MainActor
    func primaryAction(sessionId: String, onNext: @escaping (String) -> Void) {
        switch primaryState {
        case .sendCodeEnabled:
            Task { await sendCode(sessionId: sessionId) }
            
        case .nextEnabledVerified:
            onNext(email)
            
        case .nextDisabled, .nextDisabledAfterSend:
            break
        }
    }
    
    // MARK: - API: 이메일 인증번호 발송
    @MainActor
    func sendCode(sessionId: String) async {
        errorMessage = nil
        guard canSendCode else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let res = try await repo.sendCode(sessionId: sessionId, email: email)
            expiresInSec = res.expiresInSec
            
            isCodeSectionVisible = true
            inputCode = ""
            isVerified = false
            
            startTimer(seconds: res.expiresInSec)
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "인증번호 발송에 실패했습니다."
        }
    }
    
    // MARK: - API: 이메일 인증번호 확인
    @MainActor
    func confirmCode(sessionId: String) async {
        errorMessage = nil
        guard canConfirmCode else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let res = try await repo.verifyCode(sessionId: sessionId, email: email, code: inputCode)
            if res.verified {
                isVerified = true
                stopTimer()
            } else {
                errorMessage = "인증에 실패했습니다."
            }
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "인증에 실패했습니다."
        }
    }
    
    // MARK: - Resend
    @MainActor
    func resendCode(sessionId: String) async {
        await sendCode(sessionId: sessionId)
    }
    
    // MARK: - Edit Email
    @MainActor
    func beginEditEmail() {
        isCodeSectionVisible = false
        inputCode = ""
        isVerified = false
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

// MARK: - Primary Button State
extension EmailInputViewModel {
    enum PrimaryButtonState {
        case nextDisabled
        case sendCodeEnabled
        case nextDisabledAfterSend
        case nextEnabledVerified
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
