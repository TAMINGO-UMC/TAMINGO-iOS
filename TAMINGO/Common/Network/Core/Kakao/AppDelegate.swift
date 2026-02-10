//
//  AppDelegate.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/9/26.
//


import UIKit
import KakaoSDKCommon
import KakaoSDKAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        // 카카오 SDK 초기화
        KakaoAuthManager.shared.initializeSDK()
        
        return true
    }
    
    // MARK: - URL Scheme 처리 (카카오 로그인 리다이렉트)
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        return false
    }
}
