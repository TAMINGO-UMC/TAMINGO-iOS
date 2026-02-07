//
//  DepartureStatusCardView.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/23/26.
//

import SwiftUI

struct DepartureStatusCardView: View {

    let status: DepartureStatus
    let departureTime: String
    let arrivalTime: String
    let routeLink: RouteDetour?
    
    let onRouteAccept: ((RouteDetour) -> Void)?
    let onRouteReject: ((Int) -> Void)?
    
    @State private var showRouteLink: Bool = true   // 삭제용

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
                        Text(status.timeText)
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
        
        if let routeLink, showRouteLink {
            RouteLinkCardView(
                detour: routeLink,
                state: .normal,
                onVisitTap: {
                    onRouteAccept?(routeLink)
                },
                onDeleteTap: {
                    showRouteLink = false
                    onRouteReject?(routeLink.id)
                }
            )
        }
        
        // MARK: - 길 찾기 버튼
        Button {
            print("길찾기 시작")
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
    VStack(spacing: 5) {
//        DepartureStatusCardView(
//            status: .preparing(remainingMinutes: 5),
//            departureTime: "오전 08:40",
//            arrivalTime: "오전 09:10",
//            routeLink: nil
//        )
//        DepartureStatusCardView(status: .now(remainingMinutes: 5))
//        DepartureStatusCardView(status: .delayed(remainingMinutes: 5))
//        DepartureStatusCardView(status: .late(remainingMinutes: 6, delayMinutes: 35))
    }
    .padding()
}

#Preview {
    MainScheduleView()
}
