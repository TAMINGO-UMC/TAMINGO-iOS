//
//  ScheduleView.swift
//  TAMINGO
//
//  Created by 김도연 on 1/22/26.
//

import SwiftUI

struct ScheduleView: View {
    @State private var calendarVM = CalendarViewModel()
    @State private var scheduleVM = ScheduleViewModel()
    @State private var showAddSheet = false
    
    var body: some View {
        VStack {
            CalendarView(
                calendarViewModel: calendarVM,
                onDateSelected: { date in
                    print("선택된 날짜: \(date)")
                },
                onAddPress: {
                    showAddSheet.toggle()
                }
            )
            
            VStack {
                HStack(spacing: 12) {
                    Text("카테고리")
                        .font(.regular10)
                        .foregroundStyle(.gray2)
                    
                    // Enum을 순회하며 자동으로 뷰 생성
                    ForEach(ScheduleCategory.allCases, id: \.self) { category in
                        HStack(spacing: 4) {
                            Circle()
                                .fill(category.color)
                                .frame(width: 8, height: 8)
                            
                            Text(category.title)
                                .font(.regular12)
                                .foregroundStyle(.black00)
                        }
                    }
                    
                    Spacer()
                }
                .padding([.horizontal, .bottom])
                // 선택된 날짜에 맞는 일정 가져오기
                let todaySchedules = scheduleVM.getSchedules(for: calendarVM.selectDate)
                
                HStack {
                    if calendarVM.selectDate.isToday {
                        Text("오늘 일정   ·")
                            .foregroundStyle(.gray2)
                    }
                    Text("\(calendarVM.selectedMonth)/\(calendarVM.selectedDay) (\(calendarVM.selectedWeekday))")
                        .foregroundStyle(.gray2)
                    Spacer()
                    Text("\(todaySchedules.count)개") // 필터링된 개수 표시
                        .foregroundStyle(.mainMint)
                }
                .padding(.horizontal)
                .font(.regular10)
                
                ScrollView {
                    // 필터링된 일정만 표시
                    if todaySchedules.isEmpty {
                        Text("일정이 없습니다.")
                            .font(.regular13)
                            .foregroundStyle(.gray2)
                            .padding(.top, 20)
                    } else {
                        ForEach(todaySchedules) { schedule in
                            ScheduleCard(schedule: schedule)
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
            .task(id: scheduleVM.allSchedules.count) {
                calendarVM.setMarkers(from: scheduleVM.allSchedules)
            }
            .sheet(isPresented: $showAddSheet) {
                AddScheduleView {
                    // TODO: 저장이 완료되면 실행되는 클로저 추가
                    // 여기서 리스트 새로고침(fetch)을 수행
                }
            }
        }
    }
}

#Preview {
    ScheduleView()
}
