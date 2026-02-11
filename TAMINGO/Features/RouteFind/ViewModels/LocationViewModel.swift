//
//  LocationViewModel.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/12/26.
//

import Foundation
import Observation

@Observable
final class LocationViewModel {

    private let service = LocationService()

    var silentResult: SilentGPSResponseDTO?
    var errorMessage: String?

    // 알림 1시간 전
    func checkSilentGPS(
        scheduleId: Int,
        latitude: Double,
        longitude: Double
    ) {
        Task {
            do {
                let result = try await service.silentGPS(
                    scheduleId: scheduleId,
                    latitude: latitude,
                    longitude: longitude
                )

                await MainActor.run {
                    self.silentResult = result
                }

            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    // 실시간 위치 전송
    func sendRealtimeGPS(
        scheduleId: Int,
        latitude: Double,
        longitude: Double
    ) {
        Task {
            do {
                try await service.sendRealtime(
                    scheduleId: scheduleId,
                    latitude: latitude,
                    longitude: longitude
                )
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    // 사후 확인
    func postCheck(scheduleId: Int) {
        Task {
            do {
                try await service.postCheck(scheduleId: scheduleId)
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
