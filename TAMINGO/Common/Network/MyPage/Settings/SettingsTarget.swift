//
//  SettingsTarget.swift
//  TAMINGO
//
//  Created by 김도연 on 2/10/26.
//

import Foundation
import Moya
import Alamofire

enum SettingsTarget {
    case logout(refreshToken: String)
    case withdraw
}

extension SettingsTarget: APITargetType {
    
    // MARK: - Path
    var path: String {
        switch self {
        case .logout:
            return "/api/auth/logout"
        case .withdraw:
            return "/api/users/me"
        }
    }
    
    // MARK: - Method
    var method: Moya.Method {
        switch self {
        case .logout:
            return .post
        case .withdraw:
            return .delete
        }
    }
    
    // MARK: - Task
    var task: Moya.Task {
        switch self {
        case .logout, .withdraw:
            return .requestPlain
        }
    }
    
    // MARK: - Headers
    // 로그아웃일 때 X-Refresh-Token을 추가
    var headers: [String : String]? {
        var header = ["Content-Type": "application/json"]
        
        if let token = TokenManager.shared.getAccessToken() {
            header["Authorization"] = "Bearer \(token)"
        }
        
        // 추가 헤더 병합 (로그아웃의 경우)
        switch self {
        case .logout(let refreshToken):
            header["X-Refresh-Token"] = refreshToken
        default:
            break
        }
        
        return header
    }
}
