//
//  TransportRankRequestDTO.swift
//  TAMINGO
//
//  Created by 권예원 on 2/11/26.
//

import Foundation

struct TransportRankRequestDTO: Encodable {

    let rank1: String
    let rank2: String
    let rank3: String

    init(ranks: [TransportType]) {

        self.rank1 = ranks[0].dtoValue ?? ""
        self.rank2 = ranks[1].dtoValue ?? ""
        self.rank3 = ranks[2].dtoValue ?? ""
    }
}
