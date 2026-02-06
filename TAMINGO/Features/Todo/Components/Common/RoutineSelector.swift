//
//  RoutineSelector.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/31/26.
//

import SwiftUI

struct RoutineSelector: View {
    @Binding var selectedRoutine: TodoRoutineType
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(TodoRoutineType.allCases) { routine in
                Button(action: {
                    selectedRoutine = routine
                }) {
                    Text(routine.rawValue)
                        .font(.medium14)
                        .foregroundColor(selectedRoutine == routine ? .white : .gray2)
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                        .background(selectedRoutine == routine ? Color.mainMint : Color.gray0)
                        .cornerRadius(4)
                }
            }
        }
    }
}

#Preview {
    RoutineSelector(selectedRoutine: .constant(.daily))
        .padding()
}
