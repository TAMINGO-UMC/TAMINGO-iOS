
//
//  CalendarSheetView.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/31/26.
//

import SwiftUI

struct CalendarSheetView: View {
    @State var calendarViewModel: CalendarViewModel
    @Binding var isPresented: Bool
    @Binding var selectedDate: Date
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                CalendarView(
                    calendarViewModel: calendarViewModel,
                    enableSwipe: true,
                    contentPadding: 20,
                    onDateSelected: { date in
                        selectedDate = date
                    },
                    onAddPress: nil
                )
                
                // 확인 버튼
                Button(action: {
                    isPresented = false
                }) {
                    Text("확인")
                        .font(.medium14)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.mainMint)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                Spacer()
            }
            .navigationTitle("날짜 선택")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("닫기") {
                        isPresented = false
                    }
                    .foregroundColor(.gray2)
                }
            }
        }
    }
}
