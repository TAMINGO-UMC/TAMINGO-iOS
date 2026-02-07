//
//  ScheduleTarget.swift
//  TAMINGO
//
//  Created by 김도연 on 1/30/26.
//

import Foundation
import Moya
import Alamofire

enum ScheduleTarget {
    case createSchedule(body: ScheduleRequestDTO)
    case aiInference(title: String)
    case updateSchedule(id: Int, body: ScheduleEditDTO)
    case aiFavoritePlaces(body: addPlaceDTO)
    case getFavoritePlaces
    case getScheduleList(date: String)
    case getScheduleDetail(id: Int)
    case getCategories
    case getMonthly(date: String)
}

extension ScheduleTarget: APITargetType {
    // MARK: - Path
    var path: String {
        switch self {
        case .createSchedule:
            return "/api/schedules/create"
        case .aiInference:
            return "/api/schedules/ai-inference"
        case .updateSchedule(let id, _):
            return "/api/schedules/\(id)"
        case .aiFavoritePlaces:
            return "/api/favorite-places/ai"
        case .getFavoritePlaces:
            return "/api/favorite-places"
        case .getScheduleList:
            return "/api/schedules"
        case .getScheduleDetail(let id):
            return "/api/schedules/\(id)"
        case .getCategories:
            return "/api/schedule-categories"
        case .getMonthly:
            return "/api/schedules/calendar"
        }
    }
    
    // MARK: - Method
    var method: Moya.Method {
        switch self {
        case .createSchedule, .aiInference, .aiFavoritePlaces:
            return .post
        case .updateSchedule:
            return .put
        case .getFavoritePlaces, .getScheduleList, .getScheduleDetail, .getCategories, .getMonthly:
            return .get
        }
    }
    
    // MARK: - Task
    var task: Moya.Task {
        switch self {
        case .createSchedule(let body):
            return .requestJSONEncodable(body)
            
        case .aiInference(let title):
            return .requestParameters(
                parameters: ["title": title],
                encoding: JSONEncoding.default
            )
        case .aiFavoritePlaces(let body):
            return .requestJSONEncodable(body)
            
        case .updateSchedule(_, let body):
            return .requestJSONEncodable(body)
            
        case .getScheduleList(let date):
            return .requestParameters(
                parameters: ["date": date],
                encoding: URLEncoding.default
            )
        case .getMonthly(let date):
            return .requestParameters(
                parameters: ["yearMonth": date],
                encoding: URLEncoding.default
            )
            
        case .getFavoritePlaces, .getScheduleDetail, .getCategories:
            return .requestPlain
        }
    }
}
