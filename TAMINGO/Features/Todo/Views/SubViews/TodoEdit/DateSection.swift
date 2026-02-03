//
//  DateSection.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/29/26.
//

import SwiftUI

struct DateSection: View {
    let formattedDate: String
    /// true이면 날짜가 미지정 상태 (텍스트 색상 등 변경)
    let isUndated: Bool
    @Binding var showingCalendar: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("날짜")
                    .font(.medium14)
                    .foregroundColor(.black)
                
                // 날짜가 지정된 경우에만 필수 표시(*)
                if !isUndated {
                    Text("*")
                        .foregroundColor(.mainMint)
                }
            }
            
            HStack {
                Text(formattedDate)
                    .font(.medium12)
                    .foregroundColor(isUndated ? .gray2 : .black)   // 미지정 → 회색
                
                Spacer()
                
                Button(action: {
                    showingCalendar = true
                }) {
                    Image(systemName: "calendar")
                        .foregroundColor(.black)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 36)
            .padding(.horizontal, 12)
            .background(Color.gray0)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color(red: 254/255, green: 254/255, blue: 254/255, opacity: 0.1), lineWidth: 1)
            )
        }
    }
}
