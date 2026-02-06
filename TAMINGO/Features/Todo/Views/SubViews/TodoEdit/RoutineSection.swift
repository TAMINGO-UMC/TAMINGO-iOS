//
//  RoutineSection.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/31/26.
//

import SwiftUI

struct RoutineSection: View {
    @Binding var isRoutineEnabled: Bool
    @Binding var selectedRoutine: TodoRoutineType
    @Binding var routineEndDate: Date
    @Binding var hasEndDate: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 루틴 토글
            HStack {
                Text("루틴")
                    .font(.medium14)
                    .foregroundColor(.black)
                
                Spacer()
                
                Toggle("", isOn: $isRoutineEnabled)
                    .labelsHidden()
            }
            
            if isRoutineEnabled {
                // 루틴 타입 선택
                RoutineSelector(selectedRoutine: $selectedRoutine)
                
                // 종료일 설정
                HStack {
                    Text("종료일")
                        .font(.medium14)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Toggle("", isOn: $hasEndDate)
                        .labelsHidden()
                }
                
                if hasEndDate {
                    DatePicker(
                        "",
                        selection: $routineEndDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.compact)
                    .labelsHidden()
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    RoutineSection(
        isRoutineEnabled: .constant(true),
        selectedRoutine: .constant(.daily),
        routineEndDate: .constant(Date()),
        hasEndDate: .constant(true)
    )
    .padding()
}
