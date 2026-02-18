//
//  TransportRankResponseDTO.swift
//  TAMINGO
//
//  Created by 권예원 on 2/11/26.
//

struct TransportRankResultDTO: Decodable {
    let rank1: String
    let rank2: String
    let rank3: String
}

extension TransportRankResultDTO {
    func toDomain() -> [TransportType] {
        [
            TransportType(serverValue: rank1),
            TransportType(serverValue: rank2),
            TransportType(serverValue: rank3)
        ].compactMap { $0 }
    }
}

