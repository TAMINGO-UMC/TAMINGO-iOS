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
    private let accessToken: String

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

        service.fetchScheduleDetail(
            scheduleId: scheduleId,
            accessToken: accessToken
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isLoading = false

                switch result {
                case .success(let detail):
                    self.detail = detail
                    print("✅ ScheduleDetail 로드 성공")
                    dump(detail)

                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("❌ ScheduleDetail 실패:", error)
                }
            }
        }
    }
}

extension ScheduleDetail {
    /// ScheduleCardView에서 바로 쓰기 위한 값들
    var departureTimeText: String {
        String(travel.expectedDepartureTime.prefix(5))
    }
    
    var arrivalTimeText: String {
        String(travel.expectedArrivalTime.prefix(5))
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
            requiredMinutes: detour.detourMinutes
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
