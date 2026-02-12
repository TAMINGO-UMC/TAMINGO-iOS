//
//  TransportRankService.swift
//  TAMINGO
//
//  Created by 권예원 on 2/11/26.
//

import Foundation
import Moya

protocol TransportRankServiceProtocol {
    func fetchTransportRank() async throws -> [TransportType]
    func updateTransportRank(ranks: TransportRanks) async throws -> TransportRanks
}

final class TransportRankService: TransportRankServiceProtocol {

    private let provider = MoyaProvider<TransportRankAPI>(
        plugins: [
            NetworkLoggerPlugin(configuration: .init(
                logOptions: [.requestHeaders, .requestBody, .successResponseBody, .errorResponseBody]
            ))
        ]
    )

    func fetchTransportRank() async throws -> [TransportType] {

        let response = try await provider.requestAsync(.fetchRank)
            .filterSuccessfulStatusCodes()

        let decoded = try JSONDecoder().decode(
            BaseResponse<TransportRankResultDTO>.self,
            from: response.data
        )

        guard decoded.isSuccess else {
            throw APIError.server(
                status: response.statusCode,
                message: decoded.message
            )
        }

        guard let result = decoded.result else {
            throw APIError.transport("데이터가 없습니다.")
        }

        return result.toDomain()
    }
    
    func updateTransportRank(ranks: TransportRanks) async throws -> TransportRanks {

        let requestDTO = TransportRankRequestDTO(ranks: ranks)

        let response = try await provider.requestAsync(.updateRank(request: requestDTO))
            .filterSuccessfulStatusCodes()

        let decoded = try JSONDecoder().decode(
            BaseResponse<TransportRankResultDTO>.self,
            from: response.data
        )

        guard decoded.isSuccess else {
            throw APIError.server(
                status: response.statusCode,
                message: decoded.message
            )
        }

        guard let result = decoded.result else {
            throw APIError.transport("수정 결과가 없습니다.")
        }

        guard
            let r1 = TransportType(serverValue: result.rank1),
            let r2 = TransportType(serverValue: result.rank2),
            let r3 = TransportType(serverValue: result.rank3)
        else {
            throw APIError.transport("서버 응답 값이 올바르지 않습니다.")
        }

        return TransportRanks(
            rank1: r1,
            rank2: r2,
            rank3: r3
        )
    }
}
