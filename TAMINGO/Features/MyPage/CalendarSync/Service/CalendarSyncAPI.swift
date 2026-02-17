//
//  CalendarSyncAPI.swift
//  TAMINGO
//
//  Created by 권예원 on 2/12/26.
//

import Foundation
import Moya
import Alamofire

enum CalendarSyncAPI {
    case sync(CalendarSyncRequestDTO)
    case fetchConnectionStatus
    case updateConnectionStatus(ConnectionUpdateRequestDTO)
}

extension CalendarSyncAPI: APITargetType {
    var path: String {
        switch self {
        case .sync:
            return "/api/calendar/apple/sync"
        case .fetchConnectionStatus,
             .updateConnectionStatus:
            return "/api/calendar/apple"
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .sync:
            return .post
        case .fetchConnectionStatus:
            return .get
        case .updateConnectionStatus:
            return .patch
        }
    }
    
    
    var task: Task {
        switch self {
        case .sync(let requestDTO):
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            return .requestCustomJSONEncodable(requestDTO, encoder: encoder)

        case .fetchConnectionStatus:
            return .requestPlain

        case .updateConnectionStatus(let requestDTO):
            return .requestJSONEncodable(requestDTO)
        }
    }
    
    
}
