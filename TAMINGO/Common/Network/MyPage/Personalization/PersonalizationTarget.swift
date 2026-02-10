//
//  PersonalizationTarget.swift
//  TAMINGO
//
//  Created by 김도연 on 2/10/26.
//

import Foundation
import Moya
import Alamofire

enum PersonalizationTarget {
    case getSettings
    case getSummary
    case putSettings(body: PersonalizationSettings)
    case resetSummary
    case getRecent
}

extension PersonalizationTarget: APITargetType {
    // MARK: - Path
    var path: String {
        switch self {
        case .getSettings, .putSettings:
            return "/api/personalization/settings"
        case .getSummary:
            return "/api/personalization/summary"
        case .resetSummary:
            return "/api/personalization/summary/reset"
        case .getRecent:
            return "/api/personalization/recent"
        }
    }
    
    // MARK: - Method
    var method: Moya.Method {
        switch self {
        case .getSettings, .getSummary, .getRecent:
            return .get
        case .putSettings:
            return .put
        case .resetSummary:
            return .delete
        }
    }
    
    // MARK: - Task
    var task: Moya.Task {
        switch self {
        case .getSettings, .getSummary, .getRecent, .resetSummary:
            return .requestPlain
        case .putSettings(let body):
            return .requestJSONEncodable(body)
        }
    }
}
