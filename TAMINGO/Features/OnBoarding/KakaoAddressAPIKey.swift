//
//  APIKey.swift
//  TAMINGO
//
//  Created by 권예원 on 1/30/26.
//

import Foundation

enum KakaoAddressAPIKey {
    static let kakao: String = {
        guard let key = Bundle.main.infoDictionary?["KAKAO_API_KEY"] as? String else {
            fatalError("KAKAO_API_KEY not found")
        }
        return key
    }()
}
