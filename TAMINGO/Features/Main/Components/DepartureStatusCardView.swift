//
//  DepartureStatusCardView.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/23/26.
//

import SwiftUI

struct DepartureStatusCardView: View {
    let travel: TravelStatus

    // seed 주입 (lateArrivalMinutes 기반)
    let lateSeed: (minutes: Int, capturedAt: Date)?

    let detours: [RouteDetour]
    let linkedDetours: [RouteDetour]

    let scheduleId: Int
    let onRouteStart: ((Int) -> Void)?
    let onRouteAccept: ((RouteDetour) -> Void)?
    let onRouteReject: ((Int) -> Void)?

    private var status: DepartureStatus { travel.status }

    var body: some View {

        // 여기서 시간이 흐르면 뷰가 자동으로 다시 그려짐
        // - 분 단위면 by: 60
        // - “바로바로 줄어드는게”를 원하면 by: 1 (초 단위)
        TimelineView(.periodic(from: .now, by: 1)) { context in
            let now = context.date

            let remainingMinutes = Int(travel.expectedDepartureDate.timeIntervalSince(now) / 60)

            // 메인 타이머 텍스트 (항상 "0시간 n분" 형태)
            let absM = abs(remainingMinutes)
            let h = absM / 60
            let m = absM % 60
            let base = "\(h)시간 \(m)분"

            let timeText: String = {
                if status.isDelayStyle { return "-\(base)" }
                return remainingMinutes < 0 ? "-\(base)" : base
            }()

            // 지연/지각일 때는 “현재 기준”으로 출발/도착 시간 표시
            let departureTimeTextForUI = status.isDelayStyle ? now.hhmmText : travel.expectedDepartureTimeText

            let arrivalTimeTextForUI: String = {
                if status.isDelayStyle {
                    let duration = travel.expectedArrivalDate.timeIntervalSince(travel.expectedDepartureDate)
                    return now.addingTimeInterval(duration).hhmmText
                }
                return travel.expectedArrivalTimeText
            }()

            // late seed + 경과시간
            let dynamicLateMinutes: Int = {
                guard case .late = status else { return 0 }
                guard let seed = lateSeed else {
                    // seed 없으면 fallback: now - expectedArrivalDate
                    return max(0, Int(now.timeIntervalSince(travel.expectedArrivalDate) / 60))
                }
                let passed = max(0, Int(now.timeIntervalSince(seed.capturedAt) / 60))
                return seed.minutes + passed
            }()

            VStack(alignment: .leading, spacing: 16) {

                // 상단
                HStack {
                    Text(status.title)
                        .font(.medium14)

                    Spacer()

                    Text("대기중")
                        .font(.regular10)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(status.timeColor)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }

                // 시간 영역
                VStack(alignment: .leading, spacing: 4) {
                    Grid(horizontalSpacing: 6, verticalSpacing: 0) {
                        GridRow {
                            Text(timeText)
                                .font(.bold24)
                                .foregroundStyle(status.timeColor)

                            // 작은 빨간 보조 텍스트는 late에서만
                            if case .late = status {
                                Text("(\(dynamicLateMinutes)분 지각)")
                                    .font(.regular12)
                                    .foregroundStyle(status.timeColor)
                            }
                        }
                    }

                    Text("출발까지 남은 시간")
                        .font(.regular12)
                        .foregroundStyle(Color("Black00"))
                }

                // 상세 정보
                VStack(alignment: .leading, spacing: 6) {

                    Label {
                        HStack(spacing: 8) {
                            Text("출발 예상 시간: \(departureTimeTextForUI)")
                                .foregroundStyle(Color.black00)

                            Text("(교통량 기준)")
                                .foregroundStyle(Color.gray2)
                        }
                    } icon: {
                        Image(systemName: "clock")
                            .foregroundStyle(Color.black00)
                    }

                    Label {
                        HStack(spacing: 8) {
                            Text("도착 예상 시간: \(arrivalTimeTextForUI)")
                                .foregroundStyle(status.arrivalTimeColor)

                            Text("(교통량 기준)")
                                .foregroundStyle(Color.gray2)
                        }
                    } icon: {
                        Image(systemName: "clock")
                            .foregroundStyle(status.arrivalTimeColor)
                    }
                }
                .padding(.leading, 12)
                .font(.regular10)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(status.backgroundColor)
            )

            // detours
            ForEach(detours) { detour in
                RouteLinkCardView(
                    detour: detour,
                    state: detour.state,
                    onVisitTap: { onRouteAccept?(detour) },
                    onDeleteTap: { onRouteReject?(detour.suggestionId) }
                )
            }

            ForEach(linkedDetours) { detour in
                RouteLinkCardView(
                    detour: detour,
                    state: .accepted,
                    onVisitTap: {},
                    onDeleteTap: {}
                )
            }

            Button {
                onRouteStart?(scheduleId)
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "map")
                        .font(.system(size: 16, weight: .medium))
                    Text("길찾기 시작")
                        .font(.medium14)
                }
                .foregroundStyle(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 88)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.mainMint)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

// Date helper
private extension Date {
    var hhmmText: String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_KR")
        f.timeZone = TimeZone.current
        f.dateFormat = "HH:mm"
        return f.string(from: self)
    }
}
