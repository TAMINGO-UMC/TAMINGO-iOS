//
//  LocationTarget.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/12/26.
//

import Foundation
import Moya
import Alamofire

enum LocationTarget {
    case silentGPS(scheduleId: Int, latitude: Double, longitude: Double)
    case realtime(scheduleId: Int, latitude: Double, longitude: Double)
    case postCheck(scheduleId: Int)
}

extension LocationTarget: APITargetType {

    var path: String {
        switch self {
        case .silentGPS:
            return "/api/location/silent-gps"
        case .realtime:
            return "/api/location/realtime"
        case .postCheck(let id):
            return "/api/location/post-check/\(id)"
        }
    }

    var method: Moya.Method {
        .post
    }

    var task: Moya.Task {
        switch self {

        case .silentGPS(let id, let lat, let lng):
            return .requestJSONEncodable(
                SilentGPSRequestDTO(scheduleId: id, latitude: lat, longitude: lng)
            )

        case .realtime(let id, let lat, let lng):
            return .requestJSONEncodable(
                RealtimeGPSRequestDTO(scheduleId: id, latitude: lat, longitude: lng)
            )

        case .postCheck:
            return .requestPlain
        }
    }
}
