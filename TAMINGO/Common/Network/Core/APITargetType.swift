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
        // 1. Config.baseURL이 비어있으면 임시 주소("https://temp.com")를 사용
        let urlString = Config.baseURL.isEmpty ? "https://temp.com" : Config.baseURL
        
        // 2. URL 생성 시도
        guard let url = URL(string: urlString) else {
            // 그래도 실패하면 에러 (여기는 이제 안 걸릴 겁니다)
            fatalError("Invalid Base URL: \(urlString)")
        }
        return url
    }
    
    var validationType: ValidationType { .successCodes }
    
    //    var headers: [String: String]? {
    //           return [
    //               "Content-Type": "application/json",
    //                "Authorization": "Bearer"
    //               ]
    //
    //       }
    
}
