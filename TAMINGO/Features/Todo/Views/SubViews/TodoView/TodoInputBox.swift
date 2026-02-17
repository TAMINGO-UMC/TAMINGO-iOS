//
//  TodoInputBox.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/29/26.
//

import SwiftUI

struct TodoInputBox: View {
    @Binding var todoTitle: String
    @Binding var selectedDate: Date? // Optional로 변경
    @Binding var showingDatePicker: Bool
    @Binding var showingCalendar: Bool
    
    let onAddTodo: (AIInferenceResult?) -> Void
    
    @StateObject private var aiViewModel = AIInferenceViewModel()
    @State private var debounceTimer: Timer?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
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
                    .onChange(of: todoTitle) { oldValue, newValue in 
                        debounceTimer?.invalidate()
                        if newValue.isEmpty {
                            aiViewModel.reset()
                        } else {
                            debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                                aiViewModel.fetchAIInference(for: newValue)
                            }
                        }
                    }
                
                Button(action: {
                    let result: AIInferenceResult? = {
                        if case .success(let r) = aiViewModel.state { return r }
                        return nil
                    }()
                    onAddTodo(result)
                    aiViewModel.reset()
                }) {
                    Text("추가")
                        .font(.medium14)
                        .foregroundColor(isAddButtonEnabled ? Color.white : Color.gray2 )
                        .frame(width: 55, height: 36)
                        .background(isAddButtonEnabled ? Color.mainMint : Color.gray1)
                        .cornerRadius(4)
                }
                .disabled(!isAddButtonEnabled)
            }
            
            // 날짜 표시
            HStack {
                Text(formattedDate(selectedDate))
                    .font(.medium12)
                    .foregroundColor(selectedDate == nil ? .gray2 : .black)
                
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
            
            if case .loading = aiViewModel.state {
                AIInferenceLoadingView()
            } else if case .success(let result) = aiViewModel.state {
                AIInferenceResultView(result: result)
            }
        }
        .padding(16)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray1, lineWidth: 1)
        )
    }
    
    private var isAddButtonEnabled: Bool {
        if case .success = aiViewModel.state {
            return !todoTitle.isEmpty
        }
        return false // 제목만 있어도 추가 가능하게 하려면 !todoTitle.isEmpty 로 변경
    }
    
    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "- - - -, - -, - -" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}
