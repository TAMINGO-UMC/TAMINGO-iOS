//
//  ScheduleDateTime.swift
//  TAMINGO
//
//  Created by 김도연 on 2/8/26.
//

import SwiftUI

// MARK: - Date & Time Component
struct ScheduleDateTime: View {
    let startTime: Date
    let endTime: Date
    let isTimeValid: Bool
    
    // Actions to trigger sheets
    let onDateTap: () -> Void
    let onStartTimeTap: () -> Void
    let onEndTimeTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 날짜
            VStack(alignment: .leading, spacing: 10) {
                ScheduleSectionHeader(title: "날짜", isRequired: true)
                ScheduleOptionRow(
                    title: startTime.toString(format: "yyyy.MM.dd"),
                    image: "calendar",
                    action: onDateTap
                )
            }
            
            // 시간
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 10) {
                    ScheduleSectionHeader(title: "시작 시간", isRequired: true)
                    ScheduleOptionRow(
                        title: startTime.toString(format: "a h:mm"),
                        image: "stopwatch",
                        action: onStartTimeTap
                    )
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    ScheduleSectionHeader(title: "종료 시간", isRequired: true)
                    ScheduleOptionRow(
                        title: endTime.toString(format: "a h:mm"),
                        image: "stopwatch",
                        action: onEndTimeTap
                    )
                }
            }
            
            if !isTimeValid {
                Text("종료 시간은 시작 시간보다 이후여야 합니다.")
                    .font(.medium12)
                    .foregroundStyle(.red)
            }
        }
    }
}
