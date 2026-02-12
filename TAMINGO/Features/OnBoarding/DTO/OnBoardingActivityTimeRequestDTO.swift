//
//  ActivityTimeDTO.swift
//  TAMINGO
//
//  Created by 권예원 on 1/31/26.
//

// 온보딩에서도 사용
struct OnBoardingActivityTimeRequestDTO: Encodable {
    let startTime: String
    let endTime: String
    let monEnabled: Bool
    let tueEnabled: Bool
    let wedEnabled: Bool
    let thuEnabled: Bool
    let friEnabled: Bool
    let weekendEnabled: Bool
}



extension ActivityTime {
    func toDTO() -> OnBoardingActivityTimeRequestDTO {
        OnBoardingActivityTimeRequestDTO(
            startTime: startTime.toString(format: "HH:mm"),
            endTime: endTime.toString(format: "HH:mm"),
            monEnabled: activeDays.contains(.mon),
            tueEnabled: activeDays.contains(.tue),
            wedEnabled: activeDays.contains(.wed),
            thuEnabled: activeDays.contains(.thu),
            friEnabled: activeDays.contains(.fri),
            weekendEnabled: activeDays.contains(.sat) && activeDays.contains(.sun)
        )
    }
}

