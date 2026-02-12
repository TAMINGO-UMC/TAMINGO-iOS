//
//  TransportRankAPI.swift
//  TAMINGO
//
//  Created by 권예원 on 2/11/26.
//

import Foundation
import Moya
import Alamofire

enum TransportRankAPI {
    case fetchRank
    case updateRank(request: TransportRankRequestDTO);
}

extension TransportRankAPI: APITargetType {

    var path: String {
        switch self {
        case .fetchRank:
            return "/api/transport-preferences"
        case .updateRank:
            return "/api/transport-preferences"
        }
    }

    var method: Moya.Method {
        switch self {
        case .fetchRank:
            return .get
        case .updateRank:
            return .put
        }
    }

    var task: Task {
        switch self {
        case .fetchRank:
            return .requestPlain
        case .updateRank(let request):
            return .requestJSONEncodable(request)
        }
    }
    
}
