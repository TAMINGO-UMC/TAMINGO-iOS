//
//  TodoInputBox.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/29/26.

import SwiftUI

struct TodoInputBox: View {
    @Binding var todoTitle: String
    @Binding var selectedDate: Date
    @Binding var showingDatePicker: Bool
    @Binding var showingCalendar: Bool
    /// AI 결과를 함께 올림 (nil 가능 — 추론 완료 전에는 추가 불가하지만 안전장치)
    let onAddTodo: (AIInferenceResult?) -> Void
    
    @StateObject private var aiViewModel = AIInferenceViewModel()
    @State private var debounceTimer: Timer?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 제목과 설명을 HStack으로
            HStack(alignment: .top, spacing: 8) {
                Text("할 일 입력")
                    .font(.medium12)
                    .foregroundColor(.black)
                
                Text("제목 입력 시 AI가 카테고리와\n장소, 예상 소요시간을 추론합니다")
                    .font(.regular10)
                    .foregroundColor(.gray2)
                    .lineLimit(2)
                
                Spacer()
            }
            
            // TextField와 추가 버튼
            HStack(spacing: 8) {
                TextField("할 일 제목을 입력하세요", text: $todoTitle)
                    .font(.medium14)
                    .foregroundColor(.black)
                    .frame(height: 36)
                    .padding(.horizontal, 12)
                    .background(Color.gray0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.gray1, lineWidth: 0.5)
                    )
                    .onChange(of: todoTitle) { newValue in
                        debounceTimer?.invalidate()
                        if newValue.isEmpty {
                            aiViewModel.reset()
                        } else {
                            debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                                aiViewModel.fetchAIInference(for: newValue)
                            }
                        }
                    }
                
                // 추가 버튼 — AI 결과를 콜백으로 올림
                Button(action: {
                    let result: AIInferenceResult? = {
                        if case .success(let r) = aiViewModel.state { return r }
                        return nil
                    }()
                    onAddTodo(result)       // ① 부모에 전달
                    aiViewModel.reset()     // ② 입력 후 AI 상태 초기화
                }) {
                    Text("추가")
                        .font(.medium14)
                        .foregroundColor(.gray2)
                        .frame(width: 55, height: 36)
                        .background(isAddButtonEnabled ? Color.mainMint : Color.gray1)
                        .cornerRadius(4)
                }
                .disabled(!isAddButtonEnabled)
            }
            
            // 날짜 선택 프레임
            HStack {
                Text(formattedDate(selectedDate))
                    .font(.medium12)
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action: {
                    showingCalendar = true
                }) {
                    Image(systemName: "calendar")
                        .resizable()
                        .frame(width: 13.89, height: 13.89)
                        .foregroundColor(.gray)
                }
            }
            .frame(height: 36)
            .padding(.horizontal, 12)
            .background(Color.gray0)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.gray1, lineWidth: 0.5)
            )
            
            // AI 추론 결과 표시 영역
            if case .loading = aiViewModel.state {
                AIInferenceLoadingView()
            } else if case .success(let result) = aiViewModel.state {
                AIInferenceResultView(result: result)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray1, lineWidth: 1)
        )
    }
    
    // 추가 버튼 활성화 조건: AI 추론 완료 && 제목이 비어있지 않음
    private var isAddButtonEnabled: Bool {
        if case .success = aiViewModel.state {
            return !todoTitle.isEmpty
        }
        return false
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}

#Preview {
    TodoInputBox(
        todoTitle: .constant(""),
        selectedDate: .constant(Date()),
        showingDatePicker: .constant(false),
        showingCalendar: .constant(false),
        onAddTodo: { _ in }
    )
}
