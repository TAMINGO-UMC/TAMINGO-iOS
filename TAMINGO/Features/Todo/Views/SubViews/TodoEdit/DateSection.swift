//
//  DateSection.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/29/26.
//  Updated: 2/9/26 - Popover 스타일 날짜 선택기
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
            
            ZStack(alignment: .topTrailing) {
                dateRow
                
                if viewModel.showingDatePicker {
                    datePickerPopover
                }
            }
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
                withAnimation(.smooth(duration: 0.4)) {
                    viewModel.showingDatePicker.toggle()
                }
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
    
    // MARK: - Date Picker Popover (Liquid Glass)
    private var datePickerPopover: some View {
        VStack(spacing: 0) {
            // 헤더
            HStack {
                Button("취소") {
                    withAnimation(.smooth(duration: 0.4)) {
                        viewModel.showingDatePicker = false
                    }
                }
                .foregroundColor(.gray2)
                .font(.medium12)
                
                Spacer()
                
                Text("날짜 선택")
                    .font(.semiBold14)
                    .foregroundColor(.black)
                
                Spacer()
                
                Button("완료") {
                    withAnimation(.smooth(duration: 0.4)) {
                        viewModel.showingDatePicker = false
                    }
                }
                .foregroundColor(.mainMint)
                .font(.medium12)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            Divider()
            
            // Date Picker - ✅ 임시 날짜 상태 관리
            if let currentDate = viewModel.selectedDate {
                DatePicker(
                    "",
                    selection: Binding(
                        get: { currentDate },
                        set: { viewModel.selectedDate = $0 }
                    ),
                    displayedComponents: .date
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .frame(height: 200)
                .padding(.horizontal, 8)
            } else {
                // ✅ 미지정 상태일 때는 오늘 날짜를 보여주되, 선택하지 않으면 nil 유지
                DatePicker(
                    "",
                    selection: Binding(
                        get: { Date() },
                        set: { viewModel.selectedDate = $0 }
                    ),
                    displayedComponents: .date
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .frame(height: 200)
                .padding(.horizontal, 8)
            }
            
            // 미지정 버튼
            Button(action: {
                viewModel.selectedDate = nil
                withAnimation(.smooth(duration: 0.4)) {
                    viewModel.showingDatePicker = false
                }
            }) {
                Text("날짜 미지정")
                    .font(.medium12)
                    .foregroundColor(.gray2)
                    .frame(maxWidth: .infinity)
                    .frame(height: 36)
                    .background(Color.gray0)
                    .cornerRadius(6)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
        .frame(width: 320)
        .background(liquidGlassBackground)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        .shadow(color: Color.black.opacity(0.12), radius: 24, x: 0, y: 12)
        .offset(x: 0, y: 50)
        .transition(
            .asymmetric(
                insertion: .scale(scale: 0.8, anchor: .topTrailing)
                    .combined(with: .opacity)
                    .combined(with: .move(edge: .top)),
                removal: .scale(scale: 0.8, anchor: .topTrailing)
                    .combined(with: .opacity)
            )
        )
        .zIndex(100)
    }
    
    // MARK: - LiquidGlass Background
    private var liquidGlassBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .environment(\.colorScheme, .light)
            
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.3),
                            Color.white.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.6),
                            Color.white.opacity(0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        }
    }
}
