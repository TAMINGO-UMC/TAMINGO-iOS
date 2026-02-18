//
//  DateSection.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/29/26.
//  Updated: 2/15/26 - 바텀 시트 방식으로 전환
//

import SwiftUI

struct DateSection: View {
    @Binding var viewModel: TodoEditViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("날짜")
                    .font(.medium14)
                    .foregroundColor(.black)
                
                // 날짜가 지정된 경우에만 필수 표시(*)
                if viewModel.selectedDate != nil {
                    Text("*")
                        .foregroundColor(.mainMint)
                }
            }
            
            dateRow
        }
        .sheet(isPresented: $viewModel.showingDatePicker) {
            TodoEditDatePickerSheet(
                selectedDate: $viewModel.selectedDate,
                isPresented: $viewModel.showingDatePicker
            )
            .presentationDetents([.height(260)])
            .presentationDragIndicator(.visible)
        }
    }
    
    // MARK: - Date Row
    private var dateRow: some View {
        HStack {
            Text(viewModel.formattedDate)
                .font(.medium12)
                .foregroundColor(viewModel.selectedDate == nil ? .gray2 : .black)
            
            Spacer()
            
            Button(action: {
                viewModel.showingDurationPicker = false
                viewModel.showingDatePicker = true
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

private struct TodoEditDatePickerSheet: View {
    @Binding var selectedDate: Date?
    @Binding var isPresented: Bool

    var body: some View {
        VStack(spacing: 0) {
            DatePicker(
                "",
                selection: Binding(
                    get: { selectedDate ?? Date() },
                    set: { selectedDate = $0 }
                ),
                displayedComponents: .date
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .padding(.top, 6)

            Button("날짜 미지정") {
                selectedDate = nil
                isPresented = false
            }
            .font(.medium12)
            .foregroundColor(.gray2)
            .padding(.bottom, 8)
        }
    }
}
