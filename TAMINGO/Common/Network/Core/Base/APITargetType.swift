//
//  APITargetType.swift
//  TAMINGO
//
//  Created by 김도연 on 1/16/26.
//

import Foundation
import Moya

protocol APITargetType: TargetType {}

extension APITargetType {
   var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("Invalid Base URL")
        }
        return url
    }
    
    var validationType: ValidationType { .successCodes }
    
    // [수정됨] 토큰이 있을 때만 Bearer 추가, 없으면 제외
    var headers: [String: String]? {
        var header = ["Content-Type": "application/json"]
        
        // TokenManager에서 실제 토큰을 가져와서 추가
        if let token = TokenManager.shared.getAccessToken() {
            header["Authorization"] = "Bearer \(token)"
        }
        
        return header
    }
}
