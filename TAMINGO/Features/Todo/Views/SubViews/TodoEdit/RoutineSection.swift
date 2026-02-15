//
//  RoutineSection.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/31/26.
//  Updated: 반복 종료 날짜 시트 UI 통일
//

import SwiftUI

struct RoutineSection: View {
    @Binding var viewModel: TodoEditViewModel
    
    // DatePicker 시트 표시 여부
    @State private var showingDatePicker = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // MARK: - 1. 헤더 & 메인 토글
            HStack {
                Text("루틴 설정")
                    .font(.medium14)
                    .foregroundColor(.black)
                
                Spacer()
                
                Toggle("", isOn: $viewModel.isRoutineEnabled)
                    .labelsHidden()
                    .tint(.mainMint) // ✅ 토글 색상: MainMint
            }
            
            // 토글이 켜졌을 때만 하단 내용 표시
            if viewModel.isRoutineEnabled {
                VStack(alignment: .leading, spacing: 12) {
                    
                    // MARK: - 2. 반복 주기 버튼
                    Text("반복 주기를 선택하세요")
                        .font(.regular12)
                        .foregroundColor(.gray2)
                    
                    HStack(spacing: 8) {
                        RoutineTypeButton(type: .daily, selectedType: $viewModel.selectedRoutine)
                        RoutineTypeButton(type: .weekly, selectedType: $viewModel.selectedRoutine)
                        RoutineTypeButton(type: .monthly, selectedType: $viewModel.selectedRoutine)
                    }
                    
                    // 선택된 주기에 따른 설명 텍스트
                    Text(descriptionText)
                        .font(.regular12)
                        .foregroundColor(.gray2)
                    
                    // MARK: - 3. 반복 종료 날짜 설정 (회색 박스)
                    HStack {
                        Text("반복 종료 날짜")
                            .font(.medium14)
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        // 날짜 표시 (클릭 시 WheelDatePickerSheet 오픈)
                        if viewModel.hasEndDate {
                            Button(action: {
                                showingDatePicker = true
                            }) {
                                Text(formattedDate(viewModel.routineEndDate))
                                    .font(.medium14)
                                    .foregroundColor(.mainMint)
                            }
                        }
                        
                        // 종료일 사용 여부 토글
                        Toggle("", isOn: $viewModel.hasEndDate)
                            .labelsHidden()
                            .tint(.mainMint) // ✅ 토글 색상: MainMint
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 52)
                    .background(Color.gray0) // 회색 배경
                    .cornerRadius(8)
                }
            }
        }
        .padding(.vertical, 8)
        // MARK: - 4. 반복 종료 날짜 시트
        .sheet(isPresented: $showingDatePicker) {
            TodoRoutineEndDateSheet(
                selectedDate: $viewModel.routineEndDate
            )
            .presentationDetents([.height(260)])
            .presentationDragIndicator(.visible)
        }
    }
    
    // 반복 주기 설명 텍스트
    private var descriptionText: String {
        switch viewModel.selectedRoutine {
        case .daily: return "매일 같은 시간에 반복됩니다"
        case .weekly: return "매주 같은 요일에 반복됩니다"
        case .monthly: return "매달 같은 날짜에 반복됩니다"
        }
    }
    
    // 날짜 포맷 (yyyy.MM.dd)
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}

private struct TodoRoutineEndDateSheet: View {
    @Binding var selectedDate: Date

    var body: some View {
        DatePicker(
            "",
            selection: $selectedDate,
            displayedComponents: .date
        )
        .datePickerStyle(.wheel)
        .labelsHidden()
        .padding(.top, 6)
    }
}

// MARK: - 반복 주기 선택 버튼 컴포넌트
struct RoutineTypeButton: View {
    let type: TodoRoutineType
    @Binding var selectedType: TodoRoutineType
    
    var isSelected: Bool { type == selectedType }
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedType = type
            }
        }) {
            Text(type.rawValue)
                .font(.medium14)
                // 선택됨: 흰색 글자 / 미선택: 민트색 글자
                .foregroundColor(isSelected ? .white : .mainMint)
                .frame(maxWidth: .infinity)
                .frame(height: 42)
                // 선택됨: 민트 배경 / 미선택: 흰색 배경 + 민트 테두리
                .background(isSelected ? Color.mainMint : Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.mainMint, lineWidth: 1)
                )
        }
    }
}
