//
//  ActivityTimeSettingAPI.swift
//  TAMINGO
//
//  Created by 권예원 on 2/9/26.
//

import Foundation
import Moya
import Alamofire

enum ActivityTimeSettingAPI {
    case fetchActivityTime
    case saveActivityTime(ActivityTimeRequestDTO)
}


extension ActivityTimeSettingAPI: APITargetType {

    var path: String {
        switch self {
        case .fetchActivityTime,
             .saveActivityTime:
            return "/api/active-time"
        }
    }

    var method: Moya.Method {
        switch self {
        case .fetchActivityTime:
            return .get
        case .saveActivityTime:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .fetchActivityTime:
            return .requestPlain

        case .saveActivityTime(let dto):
            return .requestJSONEncodable(dto)
        }
    }
    
    var headers: [String : String]? {
        [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(AuthConstants.accessToken)",
        ]
    }
}
