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
    
}
