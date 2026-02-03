//
//  RelateSchedule.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/29/26.
//

import SwiftUI

struct RelateSchedule: View {
    @Binding var viewModel: TodoEditViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("일정 연결")
                    .font(.medium14)
                    .foregroundColor(.black)
                
                if viewModel.isScheduleAIGenerated {
                    AIBadge()
                }
                
                Spacer()
            }
            
            Text("이 할 일과 관련된 일정을 선택하세요")
                .font(.regular12)
                .foregroundColor(.gray2)
            
            RelatedScheduleContainer(
                schedules: $viewModel.relatedSchedules,
                isExpanded: $viewModel.isScheduleExpanded
            )
        }
    }
}
