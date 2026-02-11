//
//  WeeklyReportAPI.swift
//  TAMINGO
//
//  Created by 권예원 on 2/11/26.
//

import Foundation
import Moya
import Alamofire

enum WeeklyReportAPI {
    case fetchWeeklyReport(weekStartDate: String)
    case fetchMonthlyReport(yearMonth: String)
}

extension WeeklyReportAPI: APITargetType {
    var path: String {
        switch self {
        case .fetchWeeklyReport:
            return "/api/reports/weekly"
        case .fetchMonthlyReport:
            return "/api/reports/monthly"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchWeeklyReport, .fetchMonthlyReport:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .fetchWeeklyReport(let weekStartDate):
            return .requestParameters(
                parameters: ["weekStartDate": weekStartDate],
                encoding: URLEncoding.queryString
            )

        case .fetchMonthlyReport(let yearMonth):
            return .requestParameters(
                parameters: ["month": yearMonth],
                encoding: URLEncoding.queryString
            )
        }
    }

}
