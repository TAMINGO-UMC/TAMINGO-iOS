//
//  ScheduleDetailViewModel.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/7/26.
//

import Foundation
import Observation

@Observable
final class ScheduleDetailViewModel {

    private let service = HomeDetailService()
    let accessToken: String
    let scheduleId: Int

    var detail: ScheduleDetail?
    var isLoading: Bool = false
    var errorMessage: String?
    

    init(scheduleId: Int, accessToken: String) {
        self.scheduleId = scheduleId
        self.accessToken = accessToken
    }

    func load() {
        isLoading = true
        errorMessage = nil
        print("🚀 Detail load start:", scheduleId)

        service.fetchScheduleDetail(scheduleId: scheduleId, accessToken: accessToken) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                print("✅ Detail completion arrived:", self.scheduleId)

                self.isLoading = false

                switch result {
                case .success(let detail):
                    self.detail = detail
                    print("✅ Detail success:", self.scheduleId)

                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("❌ Detail fail:", self.scheduleId, error.localizedDescription)
                }
            }
        }
    }


}

extension ScheduleDetailViewModel {

    // 들르기
    func acceptRoute(
        baseScheduleId: Int,
        detour: RouteDetour
    ) {
        let request = RouteAcceptRequestDTO(
            baseScheduleId: baseScheduleId,
            title: detour.title,
            location: .init(
                name: detour.location,
                lat: detour.lat,
                lng: detour.lng
            ),
            requiredMinutes: Int(detour.detourMinutes) ?? 0
        )

        service.acceptRoute(
            scheduleId: baseScheduleId,
            request: request,
            accessToken: accessToken
        ) { result in
            DispatchQueue.main.async {
                if case .success = result {
                    print("✅ 동선 연계 적용 완료")
                }
            }
        }
    }

    // 삭제
    func rejectRoute(scheduleId: Int) {
        service.rejectRoute(
            scheduleId: scheduleId,
            accessToken: accessToken
        ) { result in
            DispatchQueue.main.async {
                if case .success = result {
                    print("🗑 동선 연계 삭제 완료")
                }
            }
        }
    }
}

