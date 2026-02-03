//
//  DurationSection.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/29/26.
//

import SwiftUI

struct DurationSection: View {
    @Binding var viewModel: TodoEditViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("소요시간")
                    .font(.medium14)
                    .foregroundColor(.black)
                
                if viewModel.isDurationAIGenerated {
                    AIBadge()
                }
                
                Spacer()
            }
            
            ZStack(alignment: .topTrailing) {
                durationRow
                
                if viewModel.showingDurationPicker {
                    durationPicker
                }
            }
        }
    }
    
    // MARK: - Duration Row (표시 + 수정/삭제 버튼)
    private var durationRow: some View {
        HStack(spacing: 8) {
            Text(viewModel.duration.isEmpty ? "시간을 설정하세요" : viewModel.duration)
                .font(.medium14)
                .foregroundColor(viewModel.duration.isEmpty ? .gray2 : .black)
            
            Spacer()
            
            EditButton(action: {
                withAnimation(.smooth(duration: 0.4)) {
                    if viewModel.showingDurationPicker {
                        updateDuration()
                        viewModel.showingDurationPicker = false
                    } else {
                        viewModel.showingDurationPicker = true
                    }
                }
            })
            
            if !viewModel.duration.isEmpty {
                DeleteButton(action: {
                    viewModel.duration = ""
                    viewModel.isDurationAIGenerated = false
                })
            }
        }
    }
    
    // MARK: - Wheel Picker (LiquidGlass)
    private var durationPicker: some View {
        VStack(spacing: 0) {
            HStack(spacing: 2) {
                // 시간 Picker
                Picker("시간", selection: $viewModel.selectedHour) {
                    ForEach(0...23, id: \.self) { hour in
                        Text("\(hour)")
                            .font(.system(size: 16))
                            .tag(hour)
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: .infinity)
                
                Text(":")
                    .font(.system(size: 12))
                    .foregroundColor(.black)
                    .padding(.horizontal, 2)
                
                // 분 Picker
                Picker("분", selection: $viewModel.selectedMinute) {
                    ForEach([0, 10, 20, 30, 40, 50], id: \.self) { minute in
                        Text(String(format: "%02d", minute))
                            .font(.system(size: 16))
                            .tag(minute)
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: .infinity)
            }
            .frame(height: 95)
            .padding(.horizontal, 4)
            .padding(.vertical, 4)
        }
        .frame(width: 138, height: 95)
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
    
    // MARK: - Helper
    private func updateDuration() {
        if viewModel.selectedHour == 0 && viewModel.selectedMinute == 0 {
            viewModel.duration = ""
        } else if viewModel.selectedHour == 0 {
            viewModel.duration = "\(viewModel.selectedMinute)분"
        } else if viewModel.selectedMinute == 0 {
            viewModel.duration = "\(viewModel.selectedHour)시간"
        } else {
            viewModel.duration = "\(viewModel.selectedHour)시간 \(viewModel.selectedMinute)분"
        }
        viewModel.isDurationAIGenerated = false
    }
}
