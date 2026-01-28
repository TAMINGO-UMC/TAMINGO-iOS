//
//  ScheduleCardView.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/18/26.
//

import SwiftUI

struct ScheduleCardView: View {

    let schedule: Schedule
    let state: ScheduleCardState
    let isExpanded: Bool
    let onChevronTap: (() -> Void)?

    var body: some View {
        HStack(alignment: .top, spacing: 17) {

            // 시간
            Text(schedule.time)
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
                                Text("다음 일정")
                                    .font(.regular12)
                                    .foregroundStyle(Color("Gray2"))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background{
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color("Gray0"))
                                    }
                            }
                        }
                        
                        Spacer()
                        
                        rightArea
                    }
                    
                    // 위치
                    Text(schedule.location)
                        .font(.regular12)
                        .foregroundStyle(Color("Gray2"))
                        .lineLimit(1)
                }
                
                // 출발 카드
                if isExpanded {
                    DepartureStatusCardView(
                        status: .preparing(remainingMinutes: 5)
                    )
                    .transition(.opacity.combined(with: .move(edge: .top)))
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
            Button {
                onChevronTap?()
            } label: {
                Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color("Gray2"))
            }

        case .upcoming:
            Text(schedule.remainingText)
                .font(.regular12)
                .foregroundStyle(Color("Gray2"))

        case .past:
            Image(systemName: "checkmark.square")
                .font(.system(size: 18))
                .foregroundStyle(Color("Gray2"))
        }
    }
}

private extension ScheduleCardView {

    var cardBackgroundColor: Color {
        state == .past ? Color("Gray1") : Color.white
    }

    var borderColor: Color {
        switch state {
        case .next:
            return Color("Black00")
        case .upcoming:
            return Color("Gray2")
        case .past:
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
    VStack(spacing: 20) {

        ScheduleCardView(
            schedule: Schedule(
                title: "팀플 미팅",
                time: "09:40",
                location: "S관 301 · 23분",
                remainingMinutes: 0,
                isHighlighted: true
            ),
            state: .next,
            isExpanded: true,
            onChevronTap: {}
        )

        ScheduleCardView(
            schedule: Schedule(
                title: "강의",
                time: "14:00",
                location: "공학관",
                remainingMinutes: 55,
                isHighlighted: false
            ),
            state: .upcoming,
            isExpanded: false,
            onChevronTap: nil
        )

        ScheduleCardView(
            schedule: Schedule(
                title: "팀플 미팅",
                time: "09:40",
                location: "S관 301 · 23분",
                remainingMinutes: 0,
                isHighlighted: false
            ),
            state: .past,
            isExpanded: false,
            onChevronTap: nil
        )
    }
    .padding()
}
