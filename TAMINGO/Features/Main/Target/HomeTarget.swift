//
//  HomeTarget.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/12/26.
//

import Foundation
import Moya
import Alamofire

enum HomeTarget {
    case today
    case acceptSuggestion(id: Int)
    case rejectSuggestion(id: Int)
}

extension HomeTarget: APITargetType {

    var path: String {
        switch self {
        case .today:
            return "/api/home/today"
        case .acceptSuggestion(let id):
            return "/api/home/suggestions/\(id)/accept"
        case .rejectSuggestion(let id):
            return "/api/home/suggestions/\(id)/reject"
        }
    }

    var method: Moya.Method {
        switch self {
        case .today:
            return .get
        case .acceptSuggestion:
            return .post
        case .rejectSuggestion:
            return .delete
        }
    }

    var task: Task {
        .requestPlain
    }
}
