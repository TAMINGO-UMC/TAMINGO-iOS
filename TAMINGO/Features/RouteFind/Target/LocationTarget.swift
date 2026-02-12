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
    
    /// 알림 1시간 전 GPS 1회 체크
    case silentGPS(SilentGPSRequestDTO)
    
    /// 실시간 위치 전송
    case realtime(RealtimeGPSRequestDTO)
    
    /// 사후 확인 처리
    case postCheck(scheduleId: Int)
}

extension LocationTarget: APITargetType {
    
    // MARK: - Path
    
    var path: String {
        switch self {
            
        case .silentGPS:
            return "/api/location/silent-gps"
            
        case .realtime:
            return "/api/location/realtime"
            
        case .postCheck(let scheduleId):
            return "/api/location/post-check/\(scheduleId)"
        }
    }
    
    // MARK: - Method
    
    var method: Moya.Method {
        return .post
    }
    
    // MARK: - Task
    
    var task: Task {
        switch self {
            
        case .silentGPS(let request):
            return .requestJSONEncodable(request)
            
        case .realtime(let request):
            return .requestJSONEncodable(request)
            
        case .postCheck:
            // path parameter만 있고 body 없음
            return .requestPlain
        }
    }
}
