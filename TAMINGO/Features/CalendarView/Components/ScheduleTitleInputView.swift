//
//  ScheduleTitleInputView.swift
//  TAMINGO
//
//  Created by 김도연 on 2/2/26.
//

import SwiftUI

// MARK: - Title Component
struct ScheduleTitleInputView: View {
    @Binding var title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ScheduleSectionHeader(title: "제목", isRequired: true)
            
            TextField("일정 제목을 입력하세요", text: $title)
                .font(.medium12)
                .padding()
                .background(Color.gray0)
                .cornerRadius(8)
        }
    }
}

// MARK: - Date & Time Component
struct ScheduleDateTimeView: View {
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

// MARK: - Repeat Component
struct ScheduleRepeatView: View {
    let repeatType: RepeatType
    @Binding var isEndDated: Bool
    let repeatEndDate: Date
    
    let onRepeatTypeTap: () -> Void
    let onRepeatEndDateTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ScheduleSectionHeader(title: "반복 설정", isRequired: false)
            ScheduleOptionRow(
                title: repeatType.title,
                image: "chevron.right",
                action: onRepeatTypeTap
            )
            
            if repeatType != .none {
                repeatEndDateRow
            }
        }
    }
    
    private var repeatEndDateRow: some View {
        Toggle(isOn: $isEndDated) {
            Button(action: onRepeatEndDateTap) {
                HStack {
                    Text("반복 종료 날짜")
                        .font(.medium12)
                        .foregroundStyle(.black)
                    Spacer()
                    Text(isEndDated ? repeatEndDate.toString(format: "yyyy.MM.dd") : "")
                        .font(.medium12)
                        .foregroundStyle(Color.mainMint)
                }
                .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(isEndDated ? Color.gray0 : Color.gray1)
            )
            .disabled(!isEndDated)
        }
    }
}

// MARK: - Memo Component
struct ScheduleMemoView: View {
    @Binding var memo: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ScheduleSectionHeader(title: "메모", isRequired: false)
            TextField("추가 메모를 입력하세요", text: $memo, axis: .vertical)
                .font(.medium12)
                .padding(16)
                .frame(minHeight: 100, alignment: .top)
                .background(Color.gray0)
                .cornerRadius(8)
        }
    }
}
