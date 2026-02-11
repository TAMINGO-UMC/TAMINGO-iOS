//
//  TransportRankSettingViewModel.swift
//  TAMINGO
//
//  Created by 권예원 on 2/7/26.
//

import Foundation
import Observation

@Observable
final class TransportRankSettingViewModel {

    var transportRanks: [Int: TransportType] = [:]

    // 모든 순위가 선택되었는지
    var isComplete: Bool {
        transportRanks.count == 3 &&
        !transportRanks.values.contains(.none)
    }

    // MARK: - 조회

    func transport(for rank: Int) -> TransportType? {
        transportRanks[rank]
    }

    func isTransportSelected(_ type: TransportType, excluding rank: Int) -> Bool {
        transportRanks
            .filter { $0.key != rank }
            .contains { $0.value == type }
    }

    // MARK: - 업데이트

    func updateTransport(_ type: TransportType, for rank: Int) {
        guard !isTransportSelected(type, excluding: rank) else { return }
        guard transportRanks[rank] != type else { return }
        transportRanks[rank] = type
    }
}
