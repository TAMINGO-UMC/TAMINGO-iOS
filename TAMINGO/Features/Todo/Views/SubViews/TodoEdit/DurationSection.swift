//
//  DurationSection.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/29/26.
//  Updated: 2/15/26 - 바텀 시트 방식으로 전환
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
                
                AIBadge()
                
                Spacer()
            }
            
            // ✅ [수정] AI 추론 중일 때 로딩 UI 표시
            if viewModel.isInferringCategory {
                AILoadingRow(text: "소요시간 추론중 ...")
            } else {
                durationRow
            }
        }
        .sheet(isPresented: $viewModel.showingDurationPicker) {
            TodoEditDurationPickerSheet(
                selectedHour: $viewModel.selectedHour,
                selectedMinute: $viewModel.selectedMinute,
                onValueChanged: {
                    updateDuration()
                }
            )
            .presentationDetents([.height(260)])
            .presentationDragIndicator(.visible)
        }
    }

    // MARK: - Duration Row
    private var durationRow: some View {
        HStack(spacing: 8) {
            Text(viewModel.duration.isEmpty ? "시간을 설정하세요" : viewModel.duration)
                .font(.medium14)
                .foregroundColor(viewModel.duration.isEmpty ? .gray2 : .black)
            
            Spacer()
            
            EditButton(action: {
                viewModel.showingDatePicker = false
                viewModel.parseDuration()
                viewModel.showingDurationPicker = true
            })
            
            if !viewModel.duration.isEmpty {
                DeleteButton(action: {
                    viewModel.duration = ""
                    viewModel.isDurationAIGenerated = false
                })
            }
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

private struct TodoEditDurationPickerSheet: View {
    @Binding var selectedHour: Int
    @Binding var selectedMinute: Int
    let onValueChanged: () -> Void

    var body: some View {
        HStack(spacing: 2) {
            Picker("시간", selection: $selectedHour) {
                ForEach(0...23, id: \.self) { hour in
                    Text("\(hour)").tag(hour)
                }
            }
            .pickerStyle(.wheel)
            .frame(maxWidth: .infinity)

            Text(":")
                .font(.system(size: 12))
                .foregroundColor(.black)
                .padding(.horizontal, 2)

            Picker("분", selection: $selectedMinute) {
                ForEach([0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55], id: \.self) { minute in
                    Text(String(format: "%02d", minute)).tag(minute)
                }
            }
            .pickerStyle(.wheel)
            .frame(maxWidth: .infinity)
        }
        .padding(.top, 6)
        .onChange(of: selectedHour) { _, _ in onValueChanged() }
        .onChange(of: selectedMinute) { _, _ in onValueChanged() }
    }
}
