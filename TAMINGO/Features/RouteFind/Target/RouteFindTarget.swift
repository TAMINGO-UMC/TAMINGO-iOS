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
    case startRouteFind(
        scheduleId: Int,
        latitude: Double,
        longitude: Double
    )
}

extension RouteFindTarget: APITargetType {

    var path: String {
        switch self {
        case .startRouteFind:
            return "/api/home/route-find/start"
        }
    }

    var method: Moya.Method {
        .post
    }

    var task: Moya.Task {
        switch self {
        case let .startRouteFind(scheduleId, latitude, longitude):
            return .requestJSONEncodable(
                RouteFindStartRequestDTO(
                    scheduleId: scheduleId,
                    latitude: latitude,
                    longitude: longitude
                )
            )
        }
    }
}
