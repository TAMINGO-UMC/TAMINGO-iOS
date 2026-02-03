//
//  WheelDatePickerSheet.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/31/26.
//


import SwiftUI

struct WheelDatePickerSheet: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // 헤더
            HStack {
                Button("취소") {
                    isPresented = false
                }
                .foregroundColor(.gray2)
                .font(.medium14)
                
                Spacer()
                
                Text("날짜 선택")
                    .font(.semiBold16)
                    .foregroundColor(.black)
                
                Spacer()
                
                Button("완료") {
                    isPresented = false
                }
                .foregroundColor(.mainMint)
                .font(.medium14)
            }
            .padding()
            
            Divider()
            
            // Wheel Picker 스타일 DatePicker (스크롤 가능)
            ScrollView {
                DatePicker(
                    "",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            }
            .frame(height: 330)
        }
        .background(Color.white)
    }
}

#Preview {
    WheelDatePickerSheet(
        selectedDate: .constant(Date()),
        isPresented: .constant(true)
    )
}

