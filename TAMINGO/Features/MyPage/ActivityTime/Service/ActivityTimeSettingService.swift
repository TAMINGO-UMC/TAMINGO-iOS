//
//  ActivityTimeSettingService.swift
//  TAMINGO
//
//  Created by 권예원 on 2/9/26.
//

import Alamofire
import Foundation
import Moya

protocol ActivityTimeServiceProtocol {
    func fetchActivityTime() async throws -> ActivityTime
    func saveActivityTime(_ dto: ActivityTimeRequestDTO) async throws -> ActivityTime
}

final class ActivityTimeSettingService: ActivityTimeServiceProtocol {

    // 2. Interceptor가 포함된 Session 생성
    private let session: Session = {
        let interceptor = TokenInterceptor()
        return Session(interceptor: interceptor)
    }()
    
    // 3. provider 변수 선언 방식 변경 (init에서 초기화)
    private let provider: MoyaProvider<ActivityTimeSettingAPI>
    
    // 4. 초기화 메서드에서 session 주입
    init() {
        self.provider = MoyaProvider<ActivityTimeSettingAPI>(
            session: session, // 핵심: 여기에 interceptor가 담긴 session을 전달
            plugins: [
                NetworkLoggerPlugin(configuration: .init(
                    logOptions: [.requestHeaders, .requestBody, .successResponseBody, .errorResponseBody]
                ))
            ]
        )
    }

    // MARK: - 조회
    func fetchActivityTime() async throws -> ActivityTime {
        let response = try await provider.requestAsync(.fetchActivityTime)

        let decoded = try JSONDecoder().decode(
            BaseResponse<ActivityTimeResponseDTO>.self,
            from: response.data
        )

        guard let result = decoded.result else {
            throw APIError.server(
                status: 500,
                message: "조회 결과가 없습니다."
            )
        }

        return result.toDomain()
    }




    // MARK: - 저장
    func saveActivityTime(_ dto: ActivityTimeRequestDTO) async throws -> ActivityTime {
        let response = try await provider.requestAsync(.saveActivityTime(dto))

        let decoded = try JSONDecoder().decode(
            BaseResponse<ActivityTimeResponseDTO>.self,
            from: response.data
        )

        guard let result = decoded.result else {
            throw APIError.server(
                status: 500,
                message: "저장 결과가 없습니다."
            )
        }

        return result.toDomain()
    }

}

