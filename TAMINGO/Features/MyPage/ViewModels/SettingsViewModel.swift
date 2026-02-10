//
//  SettingsViewModel.swift
//  TAMINGO
//
//  Created by 김도연 on 2/10/26.
//

import Foundation
import Moya
import Observation
import SwiftUI

@Observable
class SettingsViewModel {
    // MARK: - Properties
    private let provider = MoyaProvider<SettingsTarget>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .successResponseBody))])
    
    var appVersion: String = "v1.0.0"
    var isLoading: Bool = false
    
    // 로그아웃/탈퇴 성공 감지
    var isLoggedOut: Bool = false
    
    // 알림창 제어용
    var showErrorAlert: Bool = false
    var errorMessage: String = ""
    
    // MARK: - Methods
    
    func loadAppVersion() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.appVersion = "v\(version)"
        }
    }
    
    /// 로그아웃 요청
    func logout() {
        // Refresh Token 가져오기
        guard let refreshToken = TokenManager.shared.getRefreshToken() else {
            print("리프레시 토큰 없음: 로컬 로그아웃 진행")
            performLocalLogout()
            return
        }
          
        isLoading = true
          
        _Concurrency.Task {
            do {
                let _ : BaseResponse<String> = try await provider.request(.logout(refreshToken: refreshToken))
               
                // 성공 시 로컬 데이터 정리 및 화면 전환
                await MainActor.run {
                    performLocalLogout()
                    isLoading = false
                }
            } catch {
                // 실패해도 앱 내에서는 로그아웃 처리하는 것이 일반적
                print("로그아웃 서버 요청 실패: \(error)")
                await MainActor.run {
                    performLocalLogout()
                    isLoading = false
                }
            }
        }
    }
    
    /// 회원 탈퇴 요청
    func withdraw() {
        isLoading = true
          
        _Concurrency.Task {
            do {
                let _ : BaseResponse<String>  = try await provider.request(.withdraw)
               
                // 성공 시 로컬 데이터 정리 및 화면 전환
                await MainActor.run {
                    print("회원 탈퇴 성공")
                    performLocalLogout()
                    isLoading = false
                }
            } catch {
                print("회원 탈퇴 실패: \(error)")
                await MainActor.run {
                    self.errorMessage = "회원 탈퇴 중 오류가 발생했습니다."
                    self.showErrorAlert = true
                    self.isLoading = false
                }
            }
        }
    }
    
    /// 로컬에 저장된 토큰 삭제 및 상태 변경 (공통 로직)
    private func performLocalLogout() {
        // TokenManager에 토큰 삭제 기능이 있다고 가정
        TokenManager.shared.clearAll()
        
        // View에 신호를 보냄
        self.isLoggedOut = true
    }
}
