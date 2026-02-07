//
//  ScheduleCardView.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/18/26.
//

import SwiftUI

struct ScheduleCardView: View {

    let schedule: ScheduleSummary
    let state: ScheduleCardState
    let isExpanded: Bool
    let detailVM: ScheduleDetailViewModel?
    let onChevronTap: (() -> Void)?

    var body: some View {
        HStack(alignment: .top, spacing: 17) {

            // 시간
            Text("\(schedule.startTimeText)")
                .font(.medium14)
                .foregroundStyle(timeColor)
                .frame(alignment: .leading)

            // 카드
            VStack(alignment: .leading, spacing: 16) {
                
                // 일정 텍스트
                VStack(alignment: .leading, spacing: 6) {
                    // 상단 라인
                    HStack(alignment: .center) {
                        
                        // 제목 + 다음 일정 배지
                        HStack(spacing: 8) {
                            Text(schedule.title)
                                .font(.medium14)
                                .foregroundStyle(titleColor)
                                .lineLimit(1)
                            
                            if state == .next {
                                Text("이번 일정")
                                    .font(.regular12)
                                    .foregroundStyle(Color.mainMint)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background{
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color("SubMint"))
                                    }
                            }
                        }
                        
                        
                        Spacer()
                        
                        
                        rightArea
                    }
                    
                    HStack(spacing:2) {
                        Text(schedule.placeName)
                            .font(.regular12)
                            .foregroundStyle(Color("Gray2"))
                            .lineLimit(1)
                        
//                        Text("·")
//                            .font(.regular12)
//                            .foregroundStyle(Color("Gray2"))
                        
//                        Text("\(schedule.duration)분")
//                            .font(.regular12)
//                            .foregroundStyle(Color("Gray2"))
//                            .lineLimit(1)
                    }
                }
                
                if let detailVM, let detail = detailVM.detail, isExpanded {
                    DepartureStatusCardView(
                        status: detail.travel.status,
                        departureTime: detail.travel.departureTimeText,
                        arrivalTime: detail.travel.arrivalTimeText,
                        routeLink: detail.detourRecommendations.first,
                        onRouteAccept: { detour in
                            detailVM.acceptRoute(
                                baseScheduleId: schedule.id,
                                detour: detour
                            )
                        },
                        onRouteReject: { _ in
                            detailVM.rejectRoute(scheduleId: schedule.id)
                        }
                    )
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(cardBackgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .shadow(
                color: Color.black.opacity(0.06),
                radius: 6.89,
                x: 0,
                y: 2.297
            )
        }
    }
}

private extension ScheduleCardView {
    @ViewBuilder
    var rightArea: some View {
        switch state {
            
        case .next:
            Group {
                if let onChevronTap {
                    Button {
                        onChevronTap()
                    } label: {
                        Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(Color("MainMint"))
                    }
                } else {
                    EmptyView()
                }
            }
            
        case .upcoming:
            Text(schedule.leftMinuteText)
                .font(.regular12)
                .foregroundStyle(Color("Gray2"))
            
        case .past:
            EmptyView()
        }
    }
}


private extension ScheduleCardView {

    var cardBackgroundColor: Color {
        state == .past ? Color("SubMint") : Color.white
    }

    var borderColor: Color {
        switch state {
        case .next:
            return Color("MainMint")
        case .upcoming, .past:
            return Color.clear
        }
    }

    var borderWidth: CGFloat {
        state == .past ? 0 : 1.5
    }

    var titleColor: Color {
        state == .past ? Color("Gray2") : Color("Black00")
    }

    var timeColor: Color {
        state == .past ? Color("Gray2") : Color("Black00")
    }
}


#Preview {
    VStack(spacing: 16) {
        ScheduleCardView(
            schedule: ScheduleSummary(
                id: 1,
                title: "팀플 미팅",
                startTime: "09:40",
                placeName: "S관 301",
                leftMinute: 23,
                duration: 32,
                isNextSchedule: true
            ),
            state: .next,
            isExpanded: true,
            detailVM: nil,
            onChevronTap: {}
        )

        ScheduleCardView(
            schedule: ScheduleSummary(
                id: 2,
                title: "강의",
                startTime: "14:00",
                placeName: "공학관",
                leftMinute: 55,
                duration: 12,
                isNextSchedule: false
            ),
            state: .past,
            isExpanded: false,
            detailVM: nil,
            onChevronTap: nil
        )
    }
    .padding()
}
