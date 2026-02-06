//
//  TransportPreferenceDTO.swift
//  TAMINGO
//
//  Created by 권예원 on 2/1/26.
//

import Foundation

struct TransportPreferenceDTO: Encodable {
    let transport: String
    let rank: Int
}

extension TransportPreferenceDTO {
    init?(rank: Int, type: TransportType) {
        guard let transport = type.dtoValue else { return nil }
        self.transport = transport
        self.rank = rank
    }
}
