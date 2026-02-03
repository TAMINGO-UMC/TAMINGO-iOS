//
//  RoutineSelector.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/2/26.
//

import SwiftUI

struct RoutineSelector: View {
    /// RoutineType Binding 직접 사용 (String 중간 변환 제거 → 리셋 방지)
    @Binding var selectedRoutine: RoutineType
    @Binding var routineEndDate: Date
    @Binding var hasEndDate: Bool
    @State private var showingEndDatePicker = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 루틴 주기 선택 버튼들
            HStack(spacing: 8) {
                ForEach(RoutineType.allCases) { routine in
                    Button(action: {
                        selectedRoutine = routine
                    }) {
                        Text(routine.rawValue)
                            .font(.medium14)
                            .foregroundColor(selectedRoutine == routine ? .white : .gray2)
                            .frame(maxWidth: .infinity)
                            .frame(height: 36)
                            .background(selectedRoutine == routine ? Color.mainMint : Color.white)
                            .cornerRadius(4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(selectedRoutine == routine ? Color.mainMint : Color.gray1, lineWidth: 1)
                            )
                    }
                }
            }
            
            // 안내 문구 — 선택된 주기에 맞게 동적 표시
            Text(routineGuideText)
                .font(.regular12)
                .foregroundColor(.gray2)
            
            // 반복 종료 날짜
            HStack(spacing: 12) {
                Button(action: {
                    if hasEndDate {
                        showingEndDatePicker = true
                    }
                }) {
                    HStack(spacing: 8) {
                        Text("반복 종료 날짜")
                            .font(.medium14)
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        if hasEndDate {
                            Text(formattedDate(routineEndDate))
                                .font(.medium12)
                                .foregroundColor(.mainMint)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .padding(.horizontal, 12)
                    .background(Color.gray0)
                    .cornerRadius(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.gray1, lineWidth: 0.5)
                    )
                }
                .disabled(!hasEndDate)
                .sheet(isPresented: $showingEndDatePicker) {
                    EndDatePickerSheet(
                        selectedDate: $routineEndDate,
                        isPresented: $showingEndDatePicker
                    )
                    .presentationDetents([.height(450)])
                    .presentationDragIndicator(.visible)
                }
                
                // 종료 날짜 토글
                Toggle("", isOn: $hasEndDate)
                    .labelsHidden()
                    .tint(.mainMint)
            }
        }
    }
    
    // MARK: - 안내 문구
    private var routineGuideText: String {
        switch selectedRoutine {
        case .daily:   return "매일 같은 시간에 반복됩니다"
        case .weekly:  return "매주 같은 요일에 반복됩니다"
        case .monthly: return "매월 같은 날짜에 반복됩니다"
        }
    }
    
    // MARK: - 날짜 포맷
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}

// MARK: - End Date Picker Sheet
struct EndDatePickerSheet: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                DatePicker(
                    "",
                    selection: $selectedDate,
                    in: Date()...,           // 오늘 이후만 선택 가능
                    displayedComponents: .date
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding()
                
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
            }
            .navigationTitle("반복 종료 날짜")
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

#Preview {
    RoutineSelector(
        selectedRoutine: .constant(.daily),
        routineEndDate: .constant(Date()),
        hasEndDate: .constant(true)
    )
}
