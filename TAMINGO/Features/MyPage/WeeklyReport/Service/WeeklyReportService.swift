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
        let response = try await request(target)
        
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
    
    
    func request(_ target: WeeklyReportAPI) async throws -> Response {
        try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                    
                case .success(let response):
                    continuation.resume(returning: response)
                    
                case .failure(let error):
                    
                    // 서버에서 내려준 에러 메시지 처리
                    if let response = error.response,
                       let apiErrorDTO = try? JSONDecoder().decode(
                            APIErrorResponseDTO.self,
                            from: response.data
                       ) {
                        continuation.resume(
                            throwing: APIError.server(
                                status: apiErrorDTO.status,
                                message: apiErrorDTO.message
                            )
                        )
                    } else {
                        continuation.resume(
                            throwing: APIError.transport(
                                error.localizedDescription
                            )
                        )
                    }
                }
            }
        }
    }
}
