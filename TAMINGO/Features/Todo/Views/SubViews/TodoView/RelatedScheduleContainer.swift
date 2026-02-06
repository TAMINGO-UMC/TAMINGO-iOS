//
//  RelatedScheduleContainer.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/31/26.
//

import SwiftUI

struct RelatedScheduleContainer: View {
    @Binding var relatedSchedules: [TodoRelatedScheduleItem]
    @Binding var isExpanded: Bool
    let isAIGenerated: Bool
    
    var selectedSchedule: TodoRelatedScheduleItem? {
        relatedSchedules.first(where: { $0.isSelected })
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("일정 연결")
                    .font(.medium14)
                    .foregroundColor(.black)
                
                if isAIGenerated {
                    AIBadge()
                }
                
                Spacer()
            }
            
            if !isExpanded {
                // 축소 상태: 선택된 일정 표시
                if let schedule = selectedSchedule {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(schedule.title)
                                .font(.medium14)
                                .foregroundColor(.black)
                            
                            if !schedule.location.isEmpty {
                                Text(schedule.location)
                                    .font(.regular12)
                                    .foregroundColor(.gray2)
                            }
                        }
                        
                        Spacer()
                        
                        EditButton(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                isExpanded = true
                            }
                        })
                        
                        DeleteButton(action: {
                            if let index = relatedSchedules.firstIndex(where: { $0.id == schedule.id }) {
                                relatedSchedules[index].isSelected = false
                            }
                        })
                    }
                } else {
                    // 선택된 일정 없음
                    HStack {
                        Text("일정을 선택하세요")
                            .font(.medium14)
                            .foregroundColor(.gray2)
                        
                        Spacer()
                        
                        EditButton(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                isExpanded = true
                            }
                        })
                    }
                }
            } else {
                // 확장 상태: 일정 목록
                VStack(alignment: .leading, spacing: 12) {
                    ForEach($relatedSchedules) { $schedule in
                        RelatedScheduleRow(schedule: $schedule)
                    }
                    
                    // 취소 버튼
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            isExpanded = false
                        }
                    }) {
                        Text("취소")
                            .font(.medium12)
                            .foregroundColor(.gray2)
                            .frame(maxWidth: .infinity)
                            .frame(height: 32)
                            .background(Color.gray0)
                            .cornerRadius(6)
                    }
                }
                .padding(16)
                .background(Color.gray0.opacity(0.5))
                .cornerRadius(8)
            }
        }
    }
}
