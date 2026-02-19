//
//  ScheduleStatusDTO.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/7/26.
//

import Foundation

struct ScheduleStatusDTO: Decodable {
    let currentStatus: CurrentStatusDTO
    let isStarted: Bool
    let leftOrDelayMinutes: Int
    let expectedDepartureTime: String
    let expectedArrivalTime: String
    let lateArrivalMinutes: Int?
}

enum CurrentStatusDTO: String, Decodable {
    case ready = "READY"
    case departed = "DEPARTED"
    case departureDelayed = "DEPARTURE_DELAYED"
    case departureExtremeDelayed = "DEPARTURE_EXTREME_DELAYED"
}

extension ScheduleStatusDTO {

    func toTravelStatus() -> TravelStatus {

        let depDate =
            expectedDepartureTime.toTodayDate()
            ?? Date().addingTimeInterval(TimeInterval(max(0, leftOrDelayMinutes) * 60))

        let arrDate =
            expectedArrivalTime.toTodayDate()
            ?? depDate.addingTimeInterval(60 * 30)

        return TravelStatus(
            status: .preparing(remainingMinutes: leftOrDelayMinutes), // ✅ 임시값
            expectedDepartureTimeText: expectedDepartureTime.hhmm,
            expectedArrivalTimeText: expectedArrivalTime.hhmm,
            expectedDepartureDate: depDate,
            expectedArrivalDate: arrDate,
            lateArrivalMinutes: max(0, lateArrivalMinutes ?? 0),
            leftOrDelayMinutes: leftOrDelayMinutes,
            isStarted: isStarted
        )
    }
}



// MARK: - String helpers (기존 유지 + 안전 보강)
extension String {
    var hhmm: String {
        let tSplit = self.split(separator: "T", maxSplits: 1, omittingEmptySubsequences: true)
        let timePart = (tSplit.count == 2) ? String(tSplit[1]) : self

        let comps = timePart.split(separator: ":")
        guard comps.count >= 2 else { return self }
        return "\(comps[0]):\(comps[1])"
    }

    func toTodayDate() -> Date? {
        // ISO면 "T" 뒤 시간만 분리
        let tSplit = self.split(separator: "T", maxSplits: 1, omittingEmptySubsequences: true)
        let timePart = (tSplit.count == 2) ? String(tSplit[1]) : self

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone.current

        guard let time = formatter.date(from: timePart) else { return nil }

        let cal = Calendar.current
        let now = Date()

        return cal.date(
            bySettingHour: cal.component(.hour, from: time),
            minute: cal.component(.minute, from: time),
            second: cal.component(.second, from: time),
            of: now
        )
    }
}
