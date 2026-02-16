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

    private let service: TransportRankServiceProtocol

    init(service: TransportRankServiceProtocol = TransportRankService()) {
        self.service = service
    }
    
    var transportRanks: [Int: TransportType] = [:]
    var isLoading: Bool = false
    var errorMessage: String?

    // 모든 순위가 선택되었는지
    var isComplete: Bool {
        transportRanks.count == 3 &&
        !transportRanks.values.contains(.none)
    }


    // MARK: - UI
    func transport(for rank: Int) -> TransportType? {
        transportRanks[rank]
    }

    func isTransportSelected(_ type: TransportType, excluding rank: Int) -> Bool {

        guard type != .none else { return false }

        return transportRanks
            .filter { $0.key != rank }
            .contains { $0.value == type }
    }

    func updateTransport(_ type: TransportType, for rank: Int) {
        guard !isTransportSelected(type, excluding: rank) else { return }
        guard transportRanks[rank] != type else { return }
        transportRanks[rank] = type
    }
}


@MainActor
extension TransportRankSettingViewModel{
    // MARK: - 조회

    func fetch() async {

        isLoading = true
        defer { isLoading = false }

        do {
            let ranks = try await service.fetchTransportRank()

            transportRanks = [
                1: ranks[safe: 0],
                2: ranks[safe: 1],
                3: ranks[safe: 2]
            ].compactMapValues { $0 }


        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - 저장

    func save() async {

        guard isComplete else { return }

        isLoading = true
        defer { isLoading = false }

        do {

            guard
                let r1 = transportRanks[1],
                let r2 = transportRanks[2],
                let r3 = transportRanks[3]
            else { return }

            let updated = try await service.updateTransportRank(
                ranks: TransportRanks(rank1: r1, rank2: r2, rank3: r3)
            )

            transportRanks = [
                1: updated.rank1,
                2: updated.rank2,
                3: updated.rank3
            ]

        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - 자동 업데이트
    func updateTransportAndSave(_ type: TransportType, for rank: Int) async {

        updateTransport(type, for: rank)

        guard isComplete else { return }

        do {
            guard
                let r1 = transportRanks[1],
                let r2 = transportRanks[2],
                let r3 = transportRanks[3]
            else { return }

            let updated = try await service.updateTransportRank(
                ranks: TransportRanks(rank1: r1, rank2: r2, rank3: r3)
            )

            transportRanks = [
                1: updated.rank1,
                2: updated.rank2,
                3: updated.rank3
            ]

        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
