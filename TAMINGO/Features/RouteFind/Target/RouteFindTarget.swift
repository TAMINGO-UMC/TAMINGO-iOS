//
//  RouteFindTarget.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/12/26.
//

import Foundation
import Moya
import Alamofire

enum RouteFindTarget {
    case start(RouteFindStartRequestDTO)
    case end(RouteFindEndRequestDTO)
}

extension RouteFindTarget: APITargetType {

    var path: String {
        switch self {
        case .start:
            return "/api/home/route-find/start"
        case .end:
            return "/api/home/route-find/end"
        }
    }

    var method: Moya.Method {
        return .post
    }

    var task: Task {
        switch self {
        case .start(let request):
            return .requestJSONEncodable(request)
        case .end(let request):
            return .requestJSONEncodable(request)
        }
    }
}
