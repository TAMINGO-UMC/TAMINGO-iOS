//
//  DepartureStatusCardView.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/23/26.
//

import SwiftUI

struct DepartureStatusCardView: View {

    let status: DepartureStatus

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
                    .background(Color.black)
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
                        Text("출발 예상 시간: 오전 08:40 ")
                            .foregroundStyle(Color.black00)
                        Text("(교통량 기준)")
                            .foregroundStyle(Color.gray2)
                    }
                } icon: {
                    Image(systemName: "clock")
                        .foregroundStyle(Color("Black00"))
                }

                Label {
                    HStack(spacing: 8) {
                        Text("도착 예상 시간: 오전 09:10 ")
                            .foregroundStyle(status.arrivalTimeColor)

                        Text("(교통량 기준)")
                            .foregroundStyle(Color("Gray2"))
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
        
        RouteLinkCardView(
            routeLink: RouteLink(
                time: "12:30",
                title: "약 수령",
                location: "명동역 약국",
                detourText: "+2분 우회",
                suggestionText: "팀플 미팅 가는 길에 들를 수 있어요"
            ),
            onVisitTap: {},
            onDeleteTap: {}
        )
        
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
            .padding(.horizontal, 84)
            .background{
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    VStack(spacing: 5) {
        DepartureStatusCardView(status: .preparing(remainingMinutes: 5))
        DepartureStatusCardView(status: .now(remainingMinutes: 5))
        DepartureStatusCardView(status: .delayed(delayMinutes: 5))
        DepartureStatusCardView(status: .late(delayMinutes: 35))
    }
    .padding()
}

#Preview {
    MainScheduleView()
}
