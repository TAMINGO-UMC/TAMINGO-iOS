//
//  MyPageAPI.swift
//  TAMINGO
//
//  Created by 권예원 on 2/10/26.
//

import Foundation
import Moya
import Alamofire

enum MyPageAPI {
    case fetchSummary
}

extension MyPageAPI: APITargetType {
    
    var path: String {
        switch self {
        case .fetchSummary:
            return "/api/mypage"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchSummary:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetchSummary:
            return .requestPlain
        }
    }
}

