//
//  BasicInputSection.swift
//  TAMINGO
//
//  Created by 김도연 on 1/31/26.
//

import SwiftUI

extension AddScheduleView {
    // MARK: - Title Section
    var titleSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader(title: "제목", isRequired: true)
            
            TextField("일정 제목을 입력하세요", text: $viewModel.title)
                .font(.medium12)
                .padding()
                .background(Color.gray0)
                .cornerRadius(8)
        }
    }
    
    // MARK: - Date & Time Section
    var dateTimeSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 날짜
            VStack(alignment: .leading, spacing: 10) {
                sectionHeader(title: "날짜", isRequired: true)
                ScheduleOptionRow(
                    title: viewModel.startTime.toString(format: "yyyy.MM.dd"),
                    image: "calendar"
                ) {
                    activeSheet = .date
                }
            }
            
            // 시간 (시작/종료)
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 10) {
                    sectionHeader(title: "시작 시간", isRequired: true)
                    ScheduleOptionRow(
                        title: viewModel.startTime.toString(format: "a h:mm"),
                        image: "stopwatch"
                    ) {
                        activeSheet = .startTime
                    }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    sectionHeader(title: "종료 시간", isRequired: true)
                    ScheduleOptionRow(
                        title: viewModel.endTime.toString(format: "a h:mm"),
                        image: "stopwatch"
                    ) {
                        activeSheet = .endTime
                    }
                }
            }
            
            if !viewModel.isTimeValid {
                Text("종료 시간은 시작 시간보다 이후여야 합니다.")
                    .font(.medium12)
                    .foregroundStyle(.red)
            }
        }
    }
    
    // MARK: - Repeat Section
    var repeatSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader(title: "반복 설정", isRequired: false)
            ScheduleOptionRow(
                title: viewModel.repeatType.title,
                image: "chevron.right"
            ) {
                activeSheet = .repeatType
            }
            
            if viewModel.repeatType != .none {
                repeatEndDateRow
            }
        }
    }
    
    // 반복 종료 날짜 로직 분리
    private var repeatEndDateRow: some View {
        Toggle(isOn: $isEndDated) {
            Button {
                activeSheet = .repeatEndDate
            } label: {
                HStack {
                    Text("반복 종료 날짜")
                        .font(.medium12)
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
                    Text(isEndDated ? viewModel.repeatEndDate.toString(format: "yyyy.MM.dd") : "")
                        .font(.medium12)
                        .foregroundStyle(Color.mainMint)
                }
                .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(isEndDated ? Color.gray0 : Color.gray1)
            )
            .disabled(!isEndDated)
        }
        .onChange(of: isEndDated) { _, newValue in
            if newValue {
                viewModel.repeatEndDate = Date()
            } else {
                // 2999년 12월 31일 등 먼 미래로 설정
                let components = DateComponents(year: 2999, month: 12, day: 31)
                if let farFuture = Calendar.current.date(from: components) {
                    viewModel.repeatEndDate = farFuture
                }
            }
        }
    }
    
    // MARK: - Memo Section
    var memoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader(title: "메모", isRequired: false)
            TextField("추가 메모를 입력하세요", text: $viewModel.memo, axis: .vertical)
                .font(.medium12)
                .padding(16)
                .frame(minHeight: 100, alignment: .top)
                .background(Color.gray0)
                .cornerRadius(8)
        }
    }
}
