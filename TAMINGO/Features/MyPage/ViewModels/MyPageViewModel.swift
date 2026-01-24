//
//  myPageViewModel.swift
//  TAMINGO
//
//  Created by 권예원 on 1/24/26.
//

import Foundation
import Observation

@Observable
final class MyPageViewModel {

    // MARK: - Stored Domain Models (조회 대상)
    var activityTime: ActivityTime
//    var transportPreference: TransportPreference
//    var favoritePlaces: [FavoritePlace]
//    var notificationSetting: NotificationSetting

    // MARK: - Init (Mock 기준)
    init(
        activityTime: ActivityTime = ActivityTimeMock.weekdayDefault,
//        transportPreference: TransportPreference = TransportPreferenceMock.default,
//        favoritePlaces: [FavoritePlace] = FavoritePlaceMock.list,
//        notificationSetting: NotificationSetting = NotificationSettingMock.default
    ) {
        self.activityTime = activityTime
//        self.transportPreference = transportPreference
//        self.favoritePlaces = favoritePlaces
//        self.notificationSetting = notificationSetting
    }

    // MARK: - 조회용 Computed Properties

    // 활동 시간 반환
    var activityTimeText: String {
        "\(activityTime.startTime.formattedTime) - \(activityTime.endTime.formattedTime)"
    }

//    /// 이동수단 요약 "버스 > 지하철 > 도보"
//    var transportPreferenceText: String {
//        transportPreference.orderedTypes
//            .map { $0.displayName }
//            .joined(separator: " > ")
//    }
//
//    /// 자주 가는 장소 개수
//    var favoritePlaceCount: Int {
//        favoritePlaces.count
//    }
//
//    /// 알림 상태 텍스트
//    var notificationStatusText: String {
//        notificationSetting.isDepartureAlertEnabled ? "출발 알림 켜짐" : "출발 알림 꺼짐"
//    }
}
