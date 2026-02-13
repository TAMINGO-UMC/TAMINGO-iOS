//
//  CalendarSyncService.swift
//  TAMINGO
//
//  Created by 권예원 on 2/12/26.
//

import Foundation
import Moya
import Alamofire


protocol CalendarSyncServiceProtocol {
    func fetchConnectionStatus() async throws -> ConnectionStatusResponseDTO
        func updateConnectionStatus(enabled: Bool) async throws -> ConnectionStatusResponseDTO
        func sync(events: [CalendarEventDTO]) async throws -> CalendarSyncResultDTO
}


final class CalendarSyncService: CalendarSyncServiceProtocol {

    // [수정 2] Interceptor가 포함된 Session 생성
    private let session: Session = {
        let interceptor = TokenInterceptor()
        return Session(interceptor: interceptor)
    }()
    
    // [수정 3] provider 변수 선언 (init에서 초기화)
    private let provider: MoyaProvider<CalendarSyncAPI>
    
    // [수정 4] 초기화 메서드 추가 및 Session 주입
    init() {
        self.provider = MoyaProvider<CalendarSyncAPI>(
            session: session, // 핵심: 여기에 interceptor가 담긴 session을 전달해야 갱신 로직이 동작함
            plugins: [
                NetworkLoggerPlugin(configuration: .init(
                    logOptions: [.requestHeaders, .requestBody, .successResponseBody, .errorResponseBody]
                ))
            ]
        )
    }
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    func fetchConnectionStatus() async throws -> ConnectionStatusResponseDTO {
        let response = try await provider.requestAsync(.fetchConnectionStatus)
        return try decode(response, as: ConnectionStatusResponseDTO.self)
    }

    func updateConnectionStatus(enabled: Bool) async throws -> ConnectionStatusResponseDTO {
        let dto = ConnectionUpdateRequestDTO(enabled: enabled)
        let response = try await provider.requestAsync(.updateConnectionStatus(dto))
        return try decode(response, as: ConnectionStatusResponseDTO.self)
    }

    func sync(events: [CalendarEventDTO]) async throws -> CalendarSyncResultDTO {
        let requestDTO = CalendarSyncRequestDTO(events: events)
        let response = try await provider.requestAsync(.sync(requestDTO))
        return try decode(response, as: CalendarSyncResultDTO.self)
    }

}

extension CalendarSyncService {

    private func decode<T: Decodable>(
        _ response: Response,
        as type: T.Type
    ) throws -> T {
        let decoded = try decoder.decode(
            BaseResponse<T>.self,
            from: response.data
        )

        guard let result = decoded.result else {
            throw APIError.transport("응답 result가 없습니다.")
        }

        return result
    }
}
