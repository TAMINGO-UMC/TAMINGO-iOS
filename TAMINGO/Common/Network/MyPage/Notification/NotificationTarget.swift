//
//  NotificationTarget.swift
//  TAMINGO
//
//  Created by 김도연 on 2/10/26.
//

import Foundation
import Alamofire
import Moya

enum NotificationTarget {
    case getNotificationSettings
    case updateNotificationSettings(request: NotificationSettingResult)
}

extension NotificationTarget: APITargetType {
    
    var path: String {
        return "/api/notification-settings"
    }
    
    var method: Moya.Method {
        switch self {
        case .getNotificationSettings:
            return .get
        case .updateNotificationSettings:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .getNotificationSettings:
            return .requestPlain
        case .updateNotificationSettings(let request):
            return .requestJSONEncodable(request)
        }
    }
}
