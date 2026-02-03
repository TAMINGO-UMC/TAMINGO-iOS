//
//  RoutineSection.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/29/26.
//

import SwiftUI

struct RoutineSection: View {
    @Binding var viewModel: TodoEditViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("루틴 설정")
                    .font(.medium14)
                    .foregroundColor(.black)
                
                Spacer()
                
                Toggle("", isOn: Binding(
                    get: { viewModel.isRoutineEnabled },
                    set: { newValue in
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            viewModel.isRoutineEnabled = newValue
                        }
                    }
                ))
                    .labelsHidden()
                    .tint(.mainMint)
            }
            
            Text("반복 주기를 선택해주세요")
                .font(.regular10)
                .foregroundColor(.gray2)
            
            // if/else 제거 → opacity + offset로 숨김
            // 뷰 그래프에서 제거되지 않으면 Binding 체인이 안정적임
            RoutineSelector(
                selectedRoutine: $viewModel.selectedRoutine,
                routineEndDate: $viewModel.routineEndDate,
                hasEndDate: $viewModel.hasEndDate
            )
            .opacity(viewModel.isRoutineEnabled ? 1.0 : 0.0)
            .frame(height: viewModel.isRoutineEnabled ? nil : 0)
            .clipped()
            .offset(y: viewModel.isRoutineEnabled ? 0 : -8)
            .allowsHitTesting(viewModel.isRoutineEnabled)
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: viewModel.isRoutineEnabled)
        }
    }
}
