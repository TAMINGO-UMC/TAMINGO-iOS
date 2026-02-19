//
//  DepartureStatusCardView.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/23/26.
//

import SwiftUI

struct DepartureStatusCardView: View {
    let departureTime: String
    let arrivalTime: String

    let detours: [RouteDetour]
    let linkedDetours: [RouteDetour]
    
    let scheduleId: Int
    let onRouteStart: ((Int) -> Void)?
    let onRouteAccept: ((RouteDetour) -> Void)?
    let onRouteReject: ((Int) -> Void)?

    private var status: DepartureStatus {
        countdownVM.derivedStatus
    }

    @State private var countdownVM: DepartureCountdownViewModel
    
    init(
        departureDate: Date,
        departureTime: String,
        arrivalTime: String,
        detours: [RouteDetour],
        linkedDetours: [RouteDetour],
        scheduleId: Int,
        onRouteStart: ((Int) -> Void)?,
        onRouteAccept: ((RouteDetour) -> Void)?,
        onRouteReject: ((Int) -> Void)?
    ) {
        self.departureTime = departureTime
        self.arrivalTime = arrivalTime
        self.detours = detours
        self.linkedDetours = linkedDetours
        self.scheduleId = scheduleId
        self.onRouteStart = onRouteStart
        self.onRouteAccept = onRouteAccept
        self.onRouteReject = onRouteReject

        _countdownVM = State(
            initialValue: DepartureCountdownViewModel(
                departureDate: departureDate
            )
        )
    }


    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // MARK: - 상단
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
            
            // MARK: - 시간 영역
            VStack(alignment: .leading, spacing: 4) {

                Grid(horizontalSpacing: 6, verticalSpacing: 0) {
                    GridRow {
                        Text(countdownVM.timeText)
                            .font(.bold24)
                            .foregroundStyle(status.timeColor)

                        if let sub = status.subTimeText {
                            Text(sub)
                                .font(.regular12)
                                .foregroundStyle(status.timeColor)
                        }
                    }
                }

                Text("출발까지 남은 시간")
                    .font(.regular12)
                    .foregroundStyle(Color("Black00"))
            }

            // MARK: - 상세 정보
            VStack(alignment: .leading, spacing: 6) {

                Label {
                    HStack(spacing: 8) {
                        Text("출발 예상 시간: \(departureTime)")
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
                        Text("도착 예상 시간: \(arrivalTime)")
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
        
        ForEach(detours) { detour in
            RouteLinkCardView(
                detour: detour,
                state: detour.state,
                onVisitTap: {
                    onRouteAccept?(detour)
                },
                onDeleteTap: {
                    onRouteReject?(detour.suggestionId)
                }
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
        
        // MARK: - 길 찾기 버튼
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
            .background{
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.mainMint)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    MainScheduleView()
}
