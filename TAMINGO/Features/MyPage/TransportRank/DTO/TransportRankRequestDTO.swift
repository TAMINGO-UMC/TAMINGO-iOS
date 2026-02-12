//
//  TransportRankRequestDTO.swift
//  TAMINGO
//
//  Created by 권예원 on 2/11/26.
//

struct TransportRankRequestDTO: Encodable {

    let rank1: String
    let rank2: String
    let rank3: String

    init(ranks: TransportRanks) {
        self.rank1 = ranks.rank1.dtoValue ?? ""
        self.rank2 = ranks.rank2.dtoValue ?? ""
        self.rank3 = ranks.rank3.dtoValue ?? ""
    }
}
