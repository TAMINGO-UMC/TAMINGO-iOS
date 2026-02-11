//
//  TokenManager.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/7/26.
//  Updated: 401 재시도 테스트용 함수 추가
//

import Foundation
import Security
import Alamofire

// 로그인 성공 알림 이름 추가
extension Notification.Name {
    static let userDidLogin = Notification.Name("userDidLogin")
}

// MARK: - Keychain Token Storage
final class TokenManager {
    static let shared = TokenManager()
    private init() {}
    
    private let accessTokenKey = "com.tamingo.accessToken"
    private let refreshTokenKey = "com.tamingo.refreshToken"
    private let userIdKey = "com.tamingo.userId"
    private let tokenExpiryKey = "com.tamingo.tokenExpiry"
    
    // MARK: - Access Token
    func saveAccessToken(_ token: String, expiresIn: TimeInterval = 3600) {
        save(token, forKey: accessTokenKey)
        
        // 만료 시간 저장 (현재 시간 + expiresIn)
        let expiryDate = Date().addingTimeInterval(expiresIn)
        saveTokenExpiry(expiryDate)
        
        print("Access Token 저장 완료")
        print(" - 만료 시간: \(formatDateTime(expiryDate))")
        print(" - 유효 시간: \(formatTimeInterval(expiresIn))")
    }
    
    func getAccessToken() -> String? {
        return get(forKey: accessTokenKey)
    }
    
    func deleteAccessToken() {
        delete(forKey: accessTokenKey)
    }
    
    // 토큰 만료까지 남은 시간 (초)
    func getTimeUntilExpiry() -> TimeInterval? {
        guard let expiry = getTokenExpiry() else {
            return nil
        }
        return expiry.timeIntervalSince(Date())
    }
    
    // 토큰 만료까지 남은 시간 (읽기 쉬운 형식)
    func getFormattedTimeUntilExpiry() -> String {
        guard let timeLeft = getTimeUntilExpiry() else {
            return "만료 시간 정보 없음"
        }
        
        if timeLeft <= 0 {
            return "이미 만료됨"
        }
        
        return formatTimeInterval(timeLeft)
    }
    
    // 토큰이 곧 만료되는지 확인 (5분 전)
    func isTokenExpiringSoon() -> Bool {
        guard let expiry = getTokenExpiry() else {
            print("⚠️ 만료 시간 정보 없음")
            return false
        }
        
        let now = Date()
        let timeUntilExpiry = expiry.timeIntervalSince(now)
        
        // 5분(300초) 이내에 만료되면 true
        let isExpiring = timeUntilExpiry < 300
        
        if isExpiring {
            print("⏰ 토큰 곧 만료 (남은 시간: \(formatTimeInterval(timeUntilExpiry)))")
        }
        
        return isExpiring
    }
    
    // 토큰 상태 출력 (디버깅용)
    func printTokenStatus() {
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("📊 토큰 상태")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        
        if let expiry = getTokenExpiry() {
            print("⏰ 만료 시간: \(formatDateTime(expiry))")
            
            if let timeLeft = getTimeUntilExpiry() {
                if timeLeft > 0 {
                    print("⏳ 남은 시간: \(formatTimeInterval(timeLeft))")
                    
                    // 시각적 게이지
                    let percentage = (timeLeft / 3600) * 100
                    let bars = Int(percentage / 10)
                    let gauge = String(repeating: "█", count: bars) + String(repeating: "░", count: 10 - bars)
                    print("📊 상태: \(gauge) \(String(format: "%.1f", percentage))%")
                    
                    if timeLeft < 300 {
                        print("⚠️  경고: 5분 이내 만료")
                    } else if timeLeft < 600 {
                        print("⚡ 주의: 10분 이내 만료")
                    } else {
                        print("✅ 정상")
                    }
                } else {
                    print("❌ 상태: 만료됨 (\(formatTimeInterval(abs(timeLeft))) 전)")
                }
            }
        } else {
            print("⚠️  만료 시간 정보 없음")
        }
        
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    }
    
    // MARK: - Refresh Token
    func saveRefreshToken(_ token: String) {
        save(token, forKey: refreshTokenKey)
        
        // 🔍 Refresh Token JWT 파싱하여 만료 시간 확인
        if let expiresIn = parseJWTExpiry(token: token) {
            let expiryDate = Date().addingTimeInterval(expiresIn)
            
            print(" Refresh Token 저장 완료")
            print(" - 만료 시간: \(formatDateTime(expiryDate))")
            print(" - 유효 시간: \(formatTimeInterval(expiresIn))")
            
    }
    
    func getRefreshToken() -> String? {
        return get(forKey: refreshTokenKey)
    }
    
    func deleteRefreshToken() {
        delete(forKey: refreshTokenKey)
    }
    
    // MARK: - Token Expiry
    private func saveTokenExpiry(_ date: Date) {
        save("\(date.timeIntervalSince1970)", forKey: tokenExpiryKey)
    }
    
    private func getTokenExpiry() -> Date? {
        guard let string = get(forKey: tokenExpiryKey),
              let timestamp = Double(string) else {
            return nil
        }
        return Date(timeIntervalSince1970: timestamp)
    }
    
    private func deleteTokenExpiry() {
        delete(forKey: tokenExpiryKey)
    }
    
    // MARK: - User ID
    func saveUserId(_ userId: Int) {
        save("\(userId)", forKey: userIdKey)
    }
    
    func getUserId() -> Int? {
        guard let string = get(forKey: userIdKey) else { return nil }
        return Int(string)
    }
    
    func deleteUserId() {
        delete(forKey: userIdKey)
    }
    
    // MARK: - Clear All
    func clearAll() {
        print("🗑️  모든 토큰 삭제")
        deleteAccessToken()
        deleteRefreshToken()
        deleteUserId()
        deleteTokenExpiry()
    }
    
    // MARK: - Helper: 시간 포맷팅
    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let absInterval = abs(interval)
        let hours = Int(absInterval) / 3600
        let minutes = (Int(absInterval) % 3600) / 60
        let seconds = Int(absInterval) % 60
        
        if hours > 0 {
            return "\(hours)시간 \(minutes)분 \(seconds)초"
        } else if minutes > 0 {
            return "\(minutes)분 \(seconds)초"
        } else {
            return "\(seconds)초"
        }
    }
    
    private func formatDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    // MARK: - Private Helpers (Keychain)
    private func save(_ value: String, forKey key: String) {
        guard let data = value.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func get(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        guard status == errSecSuccess,
              let data = dataTypeRef as? Data,
              let value = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return value
    }
    
    private func delete(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}

// MARK: - Token Auto Refresh Interceptor
class TokenInterceptor: RequestInterceptor {
    
    // MARK: - Adapt (요청 전 토큰 추가 + 만료 체크)
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        
        // Authorization 헤더에 Access Token 추가
        if let token = TokenManager.shared.getAccessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // 요청 시 토큰 상태 출력 (디버깅)
        if let timeLeft = TokenManager.shared.getTimeUntilExpiry() {
            if timeLeft > 0 {
                print("토큰 상태: \(TokenManager.shared.getFormattedTimeUntilExpiry()) 남음")
            } else {
                print("토큰 이미 만료됨")
            }
        }
        
        // 토큰이 곧 만료되면 미리 갱신 시도
        if TokenManager.shared.isTokenExpiringSoon() {
            print("미리 갱신 시도")
            Task {
                do {
                    let newAccessToken = try await refreshAccessToken()
                    await TokenManager.shared.saveAccessToken(newAccessToken)
                    print("사전 갱신 성공")
                } catch {
                    print("사전 갱신 실패 (401 시 재시도 예정): \(error)")
                }
                completion(.success(request))
            }
        } else {
            completion(.success(request))
        }
    }
    
    // MARK: - Retry (401 에러 시 자동 갱신)
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        print("401 Unauthorized 발생")
        print("- URL: \(request.request?.url?.absoluteString ?? "unknown")")
        print("- 재시도 횟수: \(request.retryCount + 1)/3")
        
        // 무한 루프 방지: 최대 재시도 횟수 제한 (3회)
        if request.retryCount >= 3 {
            print("재시도 횟수 초과 (3회)")
            print("→ Refresh Token도 만료된 것으로 판단")
            print("→ 로그아웃 처리")
            TokenManager.shared.clearAll()
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .userDidLogout, object: nil)
            }
            completion(.doNotRetryWithError(error))
            return
        }
        
        // Refresh Token으로 Access Token 갱신
        Task {
            do {
                print("토큰 갱신 시작...")
                let newAccessToken = try await refreshAccessToken()
                await TokenManager.shared.saveAccessToken(newAccessToken)
                print("토큰 갱신 성공!")
                print(" → 원래 요청 재시도")
                completion(.retry)
            } catch {
                print(" 토큰 갱신 실패: \(error)")
                print(" → Refresh Token 만료됨")
                print(" → 로그아웃 처리")
                
                await TokenManager.shared.clearAll()
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .userDidLogout, object: nil)
                }
                completion(.doNotRetryWithError(error))
            }
        }
    }
    
    // MARK: - Private: Refresh Token API 호출
    private func refreshAccessToken() async throws -> String {
        guard let refreshToken = await TokenManager.shared.getRefreshToken() else {
            throw APIError.transport("Refresh Token이 없습니다.")
        }
        
        guard let url = URL(string: "\(await Config.baseURL)/api/auth/token/refresh") else {
            throw APIError.transport("잘못된 URL입니다.")
        }
        
        print("Refresh Token API 호출")
        print("- URL: \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
       
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(refreshToken, forHTTPHeaderField: "X-Refresh-Token")
        
        // Body는 비워둠
        request.httpBody = try? JSONSerialization.data(withJSONObject: [:])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.transport("응답이 없습니다.")
        }
        
        // 상태 코드 확인
        if !(200..<300).contains(httpResponse.statusCode) {
            let errorBody = String(data: data, encoding: .utf8) ?? "알 수 없음"
            print("토큰 갱신 실패 (Status: \(httpResponse.statusCode))")
            print("- Response Body: \(errorBody)")
            throw APIError.server(status: httpResponse.statusCode, message: "토큰 갱신 실패")
        }
        
        print("서버 응답: \(httpResponse.statusCode)")
        
        let decoder = JSONDecoder()
        let baseResponse = try decoder.decode(BaseResponse<RefreshTokenResponseDTO>.self, from: data)
        
        guard let accessToken = await baseResponse.result?.accessToken else {
            throw APIError.transport("새로운 Access Token을 받지 못했습니다.")
        }
        
        print("새로운 Access Token 수신 완료")
        return accessToken
    }
}

// MARK: - Logout Notification
extension Notification.Name {
    static let userDidLogout = Notification.Name("userDidLogout")
}

// MARK: - JWT Parsing
extension TokenManager {
    /// JWT 토큰에서 만료 시간 파싱
    func parseJWTExpiry(token: String) -> TimeInterval? {
        let segments = token.components(separatedBy: ".")
        guard segments.count > 1 else {
            print("JWT 토큰 형식 오류")
            return nil
        }
        
        var base64String = segments[1]
        // Base64 패딩 추가
        let remainder = base64String.count % 4
        if remainder > 0 {
            base64String.append(String(repeating: "=", count: 4 - remainder))
        }
        
        guard let data = Data(base64Encoded: base64String),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            print("⚠️ JWT 디코딩 실패")
            return nil
        }
        
        guard let exp = json["exp"] as? TimeInterval else {
            print("⚠️ JWT에 exp 필드 없음")
            return nil
        }
        
        let now = Date().timeIntervalSince1970
        let timeUntilExpiry = exp - now
        
        print("JWT 파싱 결과:")
        print("- exp: \(exp)")
        print("- now: \(now)")
        print("- 남은 시간: \(formatTimeInterval(timeUntilExpiry))")
        
        return timeUntilExpiry
    }
    
    /// JWT 토큰 자동 파싱 저장 (편의 메서드)
    func saveAccessTokenWithJWT(_ token: String) {
        if let expiresIn = parseJWTExpiry(token: token) {
            saveAccessToken(token, expiresIn: max(expiresIn, 60)) // 최소 60초
        } else {
            print("JWT 파싱 실패, 기본값(1시간) 사용")
            saveAccessToken(token, expiresIn: 3600)
        }
    }
}
