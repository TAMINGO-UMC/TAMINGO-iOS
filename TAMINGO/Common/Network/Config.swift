//
//  Config.swift
//  TAMINGO
//
//  Created by 김도연 on 1/16/26.
//

import Foundation

enum Config {
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist cannot be found")
        }
        return dict
    }()
    
    static let baseURL: String = {
        guard let baseURL = Config.infoDictionary["BASE_URL"] as? String else {
            fatalError("BaseURL not found")
        }
        return baseURL
    }()
    
    static let kakaoLoginKey: String = {
       guard let key = Config.infoDictionary["KAKAO_LOGIN_KEY"] as? String else {
           fatalError("KAKAO_LOGIN_KEY not found in Info.plist")
       }
       return key
   }()
    
    static let KakaoAddressAPIKey: String = {
        guard let key = Config.infoDictionary["KAKAO_API_KEY"] as? String else {
            fatalError("KAKAO_API_KEY not found in Info.plist")
        }
        return key
    }()
}


