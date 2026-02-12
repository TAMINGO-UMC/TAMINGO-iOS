//
//  TransportRankService.swift
//  TAMINGO
//
//  Created by 권예원 on 2/11/26.
//

import Alamofire
import Foundation
import Moya

protocol TransportRankServiceProtocol {
    func fetchTransportRank() async throws -> [TransportType]
    func updateTransportRank(ranks: [TransportType]) async throws -> [TransportType]
}

final class TransportRankService: TransportRankServiceProtocol {

    // [수정] Interceptor Session 생성
    private let session: Session = {
        let interceptor = TokenInterceptor()
        return Session(interceptor: interceptor)
    }()
    
    // [수정] Provider 선언
    private let provider: MoyaProvider<TransportRankAPI>
    
    // [수정] init 추가 및 Session 주입
    init() {
        self.provider = MoyaProvider<TransportRankAPI>(
            session: session, // 핵심: Interceptor 연결
            plugins: [
                NetworkLoggerPlugin(configuration: .init(
                    logOptions: [.requestHeaders, .requestBody, .successResponseBody, .errorResponseBody]
                ))
            ]
        )
    }

    func fetchTransportRank() async throws -> [TransportType] {

        let response = try await provider.requestAsync(.fetchRank)
            .filterSuccessfulStatusCodes()

        let decoded = try JSONDecoder()
            .decode(TransportRankResponseDTO.self, from: response.data)

        guard let result = decoded.result else {
            throw APIError.transport("데이터가 없습니다.")
        }

        return result.toDomain()
    }

    func updateTransportRank(ranks: [TransportType]) async throws -> [TransportType] {

        let requestDTO = TransportRankRequestDTO(ranks: ranks)

        let response = try await provider.requestAsync(.updateRank(request: requestDTO))
            .filterSuccessfulStatusCodes()

        let decoded = try JSONDecoder()
            .decode(TransportRankResponseDTO.self, from: response.data)

        guard let result = decoded.result else {
            throw APIError.transport("수정 결과가 없습니다.")
        }

        return result.toDomain()
    }
}
