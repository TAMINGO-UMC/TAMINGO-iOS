//
//  OnboardingCompleteRequestDTO.swift
//  TAMINGO
//
//  Created by 권예원 on 2/1/26.
//


struct OnboardingRequestDTO: Encodable {
    let activeTime: ActiveTimeDTO
    let favoritePlaces: [CreatePlaceRequestDTO]
    let transportPreferences: [TransportPreferenceDTO]
    let onboardingNotification: OnboardingNotificationDTO
}

extension OnboardingRequestDTO {
    init?(viewModel: SetupViewModel) {
        guard viewModel.isValid else { return nil }

        self.activeTime = ActiveTime(
            startTime: viewModel.startTime,
            endTime: viewModel.endTime
        ).toDTO()

        self.favoritePlaces = viewModel.places.map {
            $0.toCreateRequestDTO()
        }

        let transports = viewModel.transportRanks
            .compactMap { rank, type in
                TransportPreferenceDTO(rank: rank, type: type)
            }
            .sorted { $0.rank < $1.rank }

        guard transports.count == 3 else { return nil }
        self.transportPreferences = transports

        let onboardingNotification = viewModel.makeNotification()
        self.onboardingNotification = OnboardingNotificationDTO(
            setting:onboardingNotification
        )
    }
}

