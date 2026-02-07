//
//  SignupSessionStore.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/7/26.
//

import Foundation
import Observation

@Observable
final class SignupSessionStore {
    // 회원가입 세션 ID (서버에서 발급)
    var signupSessionId: String = ""
    
    // 이메일 인증
    var email: String = ""
    var isEmailVerified: Bool = false
    
    // 아이디 생성
    var nickname: String = ""
    var password: String = ""
    
    // 네비게이션 플래그
    var didFinishSignup: Bool = false
    var popToLoginFromEmail: Bool = false
    
    func reset() {
        signupSessionId = ""
        email = ""
        isEmailVerified = false
        nickname = ""
        password = ""
    }
}
