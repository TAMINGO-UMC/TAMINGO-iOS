//
//  WeeklyReportService.swift
//  TAMINGO
//
//  Created by 권예원 on 2/11/26.
//

import Alamofire
import Foundation
import Moya

protocol WeeklyReportServiceProtocol {
    func fetchWeeklyReport(weekStartDate:String) async throws -> WeeklyReportDetail
    func fetchMonthlyReport(yearMonth:String) async throws -> WeeklyReportDetail
}

final class WeeklyReportService: WeeklyReportServiceProtocol {
    
    // [수정] Interceptor Session 생성
    private let session: Session = {
        let interceptor = TokenInterceptor()
        return Session(interceptor: interceptor)
    }()
    
    // [수정] Provider 선언
    private let provider: MoyaProvider<WeeklyReportAPI>
    
    private let decoder = JSONDecoder()
    
    // [수정] init 추가 및 Session 주입
    init() {
        self.provider = MoyaProvider<WeeklyReportAPI>(
            session: session, // 핵심: Interceptor 연결
            plugins: [
                NetworkLoggerPlugin(configuration: .init(
                    logOptions: [.requestHeaders, .requestBody, .successResponseBody, .errorResponseBody]
                ))
            ]
        )
    }
    
    
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
