//
//  HomeDetailTarget.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/12/26.
//

import Foundation
import Moya
import Alamofire

enum HomeDetailTarget {
    case detail(scheduleId: Int)
    case acceptRoute(suggestionId: Int, request: RouteAcceptRequestDTO)
    case rejectRoute(suggestionId: Int)
}

extension HomeDetailTarget: APITargetType {

    var path: String {
        switch self {
        case .detail(let id):
            return "/api/home/schedules/\(id)"
        case .acceptRoute(let suggestionId, _):
            return "/api/home/suggestions/route/\(suggestionId)/accept"
        case .rejectRoute(let suggestionId):
            return "/api/home/suggestions/route/\(suggestionId)/reject"
        }
    }

    var method: Moya.Method {
        switch self {
        case .detail: return .get
        case .acceptRoute: return .post
        case .rejectRoute: return .delete
        }
    }

    var task: Task {
        switch self {
        case .acceptRoute(_, let request):
            return .requestJSONEncodable(request)
        default:
            return .requestPlain
        }
    }
}
