//
//  WheelDatePickerSheet.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/31/26.
//  Updated: 2/9/26 - 취소/완료 기능 분리, 임시 날짜 상태 관리
//

import SwiftUI

struct WheelDatePickerSheet: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    
    // ✅ 임시 날짜 (휠로 선택 중인 날짜)
    @State private var tempDate: Date
    
    // ✅ 초기화 시 현재 selectedDate를 임시 날짜로 저장
    init(selectedDate: Binding<Date>, isPresented: Binding<Bool>) {
        self._selectedDate = selectedDate
        self._isPresented = isPresented
        self._tempDate = State(initialValue: selectedDate.wrappedValue)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 헤더
            HStack {
                // ✅ 취소: 변경 사항 버리고 닫기
                Button("취소") {
                    isPresented = false
                    // tempDate는 버려지고 selectedDate는 변경되지 않음
                }
                .foregroundColor(.gray2)
                .font(.medium14)
                
                Spacer()
                
                Text("날짜 선택")
                    .font(.semiBold16)
                    .foregroundColor(.black)
                
                Spacer()
                
                // ✅ 완료: tempDate를 selectedDate에 적용하고 닫기
                Button("완료") {
                    selectedDate = tempDate
                    print("📅 날짜 확정 (Wheel): \(tempDate.toAPIDateString())")
                    isPresented = false
                }
                .foregroundColor(.mainMint)
                .font(.medium14)
            }
            .padding()
            
            Divider()
            
            // ✅ tempDate 바인딩 (완료 전까지는 임시 상태)
            ScrollView {
                DatePicker(
                    "",
                    selection: $tempDate,
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
