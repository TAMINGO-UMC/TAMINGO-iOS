//
//  ScheduleRepeatView.swift
//  TAMINGO
//
//  Created by 김도연 on 2/8/26.
//

import SwiftUI

// MARK: - Repeat Component
struct ScheduleRepeatView: View {
    let repeatType: RepeatType
    @Binding var isEndDated: Bool
    let repeatEndDate: Date?
    
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
                    
                    if isEndDated {
                        Text(repeatEndDate?.toString(format: "yyyy.MM.dd") ?? "")
                            .font(.medium12)
                            .foregroundStyle(Color.mainMint)
                    }
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
