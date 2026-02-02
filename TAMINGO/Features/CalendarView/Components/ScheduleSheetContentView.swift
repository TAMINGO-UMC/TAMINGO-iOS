//
//  ScheduleSheetContentView.swift
//  TAMINGO
//
//  Created by 김도연 on 2/2/26.
//

import SwiftUI

// MARK: - Sheet Content View
struct ScheduleSheetContentView: View {
    let type: SheetType
    
    // Bindings required for different sheets
    @Binding var startTime: Date
    @Binding var endTime: Date
    @Binding var repeatType: RepeatType
    @Binding var repeatEndDate: Date
    
    var body: some View {
        Group {
            switch type {
            case .date:
                DatePicker("", selection: $startTime, displayedComponents: .date)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                
            case .startTime:
                DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .padding()
                
            case .endTime:
                DatePicker("", selection: $endTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .padding()
                
            case .repeatType:
                Picker("", selection: $repeatType) {
                    ForEach(RepeatType.allCases, id: \.self) { type in
                        Text(type.title).tag(type)
                    }
                }
                .pickerStyle(.wheel)
                .labelsHidden()
                .padding()
                
            case .repeatEndDate:
                DatePicker("", selection: $repeatEndDate, displayedComponents: .date)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
            }
        }
    }
}
