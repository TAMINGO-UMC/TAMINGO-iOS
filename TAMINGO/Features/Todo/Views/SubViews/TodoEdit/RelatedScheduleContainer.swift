//
//  RelatedScheduleContainer.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/31/26.
//  Updated: Button Styling (Floating style with padding & shadow)
//

import SwiftUI

struct RelatedScheduleContainer: View {
    @Binding var relatedSchedules: [TodoRelatedScheduleItem]
    @Binding var isExpanded: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            
            if !isExpanded {
                VStack(spacing: 0) {
                   
                    VStack(spacing: 0) {
                        ForEach($relatedSchedules.prefix(2)) { $schedule in
                            RelatedScheduleRow(schedule: $schedule)
                                .frame(height: 40)
                        }
                    }
                    .padding(.top, 12)
                    .padding(.horizontal, 16)
                    
                    Spacer()
                    
                    // 하단 "일정 전체보기" 버튼
                    commonButton(title: "일정 전체보기", icon: "chevron.down") {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            isExpanded = true
                        }
                    }
                }
                .frame(height: 162)
                
            } else {
                // MARK: - 확장 상태 (스크롤 가능)
                VStack(spacing: 0) {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            ForEach($relatedSchedules) { $schedule in
                                RelatedScheduleRow(schedule: $schedule)
                                    .frame(height: 40)
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                    }
                    // 높이 제한 없이 내용만큼 늘어남
                    
                    // "접기" 버튼 (디자인 통일)
                    commonButton(title: "접기", icon: "chevron.up") {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            isExpanded = false
                        }
                    }
                    .padding(.top, 8) // 리스트와 버튼 사이 간격
                }
            }
        }
        // MARK: - Container Style
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray1, lineWidth: 1)
        )
    }
    
    // MARK: - 공통 버튼 디자인
    private func commonButton(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(title)
                    .font(.regular12)
                    .foregroundColor(.gray2)
                
                Image(systemName: icon)
                    .font(.system(size: 10))
                    .foregroundColor(.gray2)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 41.79)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.06), radius: 6.89, x: 0, y: 2.3)
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 12)
    }
}
