//
//  TokenManager.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/7/26.
//
// 키체인 토큰 저장 및 자동 갱신

import Foundation
import Security
import Alamofire

// MARK: - Keychain Token Storage
final class TokenManager {
    static let shared = TokenManager()
    private init() {}
    
    private let accessTokenKey = "com.tamingo.accessToken"
    private let refreshTokenKey = "com.tamingo.refreshToken"
    private let userIdKey = "com.tamingo.userId"
    
    // MARK: - Access Token
    func saveAccessToken(_ token: String) {
        save(token, forKey: accessTokenKey)
    }
    
    func getAccessToken() -> String? {
        return get(forKey: accessTokenKey)
    }
    
    func deleteAccessToken() {
        delete(forKey: accessTokenKey)
    }
    
    // MARK: - Refresh Token
    func saveRefreshToken(_ token: String) {
        save(token, forKey: refreshTokenKey)
    }
    
    func getRefreshToken() -> String? {
        return get(forKey: refreshTokenKey)
    }
    
    func deleteRefreshToken() {
        delete(forKey: refreshTokenKey)
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
        deleteAccessToken()
        deleteRefreshToken()
        deleteUserId()
    }
    
    // MARK: - Private Helpers
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
    
    // MARK: - Adapt (요청 전 토큰 추가)
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        
        // Authorization 헤더에 Access Token 추가
        if let token = TokenManager.shared.getAccessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        completion(.success(request))
    }
    
    // MARK: - Retry (401 에러 시 자동 갱신)
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        // Refresh Token으로 Access Token 갱신
        Task {
            do {
                let newAccessToken = try await refreshAccessToken()
                TokenManager.shared.saveAccessToken(newAccessToken)
                completion(.retry)
            } catch {
                // Refresh Token도 만료된 경우 모든 토큰 삭제 후 로그인 화면으로
                TokenManager.shared.clearAll()
                
                // TODO: 로그인 화면으로 이동하는 Notification 발생
                NotificationCenter.default.post(name: .userDidLogout, object: nil)
                
                completion(.doNotRetryWithError(error))
            }
        }
    }
    
    // MARK: - Private: Refresh Token API 호출
    private func refreshAccessToken() async throws -> String {
        guard let refreshToken = TokenManager.shared.getRefreshToken() else {
            throw APIError.transport("Refresh Token이 없습니다.")
        }
        
        let url = URL(string: Config.baseURL + "/api/auth/refresh")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(refreshToken, forHTTPHeaderField: "X-Refresh-Token")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.server(status: (response as? HTTPURLResponse)?.statusCode ?? 500, message: "토큰 갱신 실패")
        }
        
        let decoder = JSONDecoder()
        let baseResponse = try decoder.decode(BaseResponse<RefreshTokenResponseDTO>.self, from: data)
        
        guard let accessToken = baseResponse.result?.accessToken else {
            throw APIError.transport("새로운 Access Token을 받지 못했습니다.")
        }
        
        return accessToken
    }
}


// MARK: - Logout Notification
extension Notification.Name {
    static let userDidLogout = Notification.Name("userDidLogout")
}

