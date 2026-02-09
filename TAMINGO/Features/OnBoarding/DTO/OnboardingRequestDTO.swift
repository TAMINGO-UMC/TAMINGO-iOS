//
//  OnboardingCompleteRequestDTO.swift
//  TAMINGO
//
//  Created by 권예원 on 2/1/26.
//


struct OnboardingRequestDTO: Encodable {
    let activityTime: ActivityTimeRequestDTO
    let favoritePlaces: [PlaceRequestDTO]
    let transportPreferences: [TransportPreferenceDTO]
    let notificationSetting: NotificationSettingDTO
}

extension OnboardingRequestDTO {

    init?(viewModel: SetupViewModel) {
        guard viewModel.isValid else { return nil }

        // 활동 시간
        self.activityTime = ActivityTime(
            startTime: viewModel.startTime,
            endTime: viewModel.endTime,
            activeDays: Set(Weekday.allCases)  
        ).toDTO()

        // 자주 가는 장소
        self.favoritePlaces = viewModel.places.map {
            $0.toCreateRequestDTO()
        }

        // 이동 수단 선호
        let transports = viewModel.transportRanks
            .compactMap { rank, type in
                type.toDTO(rank: rank)
            }
            .sorted { $0.rank < $1.rank }

        guard transports.count == 3 else { return nil }
        self.transportPreferences = transports

        // 알림 설정
        let notification = viewModel.makeNotification()
        self.notificationSetting = notification.toDTO()
    }
}
