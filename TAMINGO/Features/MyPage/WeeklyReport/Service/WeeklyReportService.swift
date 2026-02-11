//
//  WeeklyReportService.swift
//  TAMINGO
//
//  Created by 권예원 on 2/11/26.
//

import Foundation
import Moya

protocol WeeklyReportServiceProtocol {
    func fetchWeeklyReport(weekStartDate:String) async throws -> WeeklyReportDetail
    func fetchMonthlyReport(yearMonth:String) async throws -> WeeklyReportDetail
}

final class WeeklyReportService: WeeklyReportServiceProtocol {
    
    private let provider = MoyaProvider<WeeklyReportAPI>(
        plugins: [
            NetworkLoggerPlugin(configuration: .init(
                logOptions: [.requestHeaders,
                             .requestBody,
                             .successResponseBody,
                             .errorResponseBody]
            ))
        ]
    )
    
    private let decoder = JSONDecoder()
    
    
    func fetchWeeklyReport(weekStartDate: String) async throws -> WeeklyReportDetail {
        try await fetch(.fetchWeeklyReport(weekStartDate: weekStartDate))
    }
    
    func fetchMonthlyReport(yearMonth: String) async throws -> WeeklyReportDetail {
        try await fetch(.fetchMonthlyReport(yearMonth: yearMonth))
    }
}

private extension WeeklyReportService {
    
    // 공통 fetch 로직
    func fetch(_ target: WeeklyReportAPI) async throws -> WeeklyReportDetail {
        let response = try await provider.requestAsync(target)
        
        let decoded = try decoder.decode(
            BaseResponse<WeeklyReportDetailResponseDTO>.self,
            from: response.data
        )
        
        guard decoded.isSuccess else {
            throw APIError.server(
                status: response.statusCode,
                message: decoded.message
            )
        }
        
        guard let result = decoded.result else {
            throw APIError.server(
                status: response.statusCode,
                message: "Empty response"
            )
        }
        
        return result.toDomain()
    }
    

}
