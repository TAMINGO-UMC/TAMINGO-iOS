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
                    print("선택된 날짜: \(date.toString(format: "yyyy-MM-dd HH:mm:ss"))")
                },
                onAddPress: {
                    showAddSheet.toggle()
                }
            )
            
            HStack {
                if calendarVM.selectDate.isToday {
                    Text("오늘 일정   ·")
                        .foregroundStyle(.gray2)
                }
                Text("\(calendarVM.selectedMonth)/\(calendarVM.selectedDay) (\(calendarVM.selectedWeekday))")
                    .foregroundStyle(.gray2)
                Spacer()
                Text("\(scheduleVM.todaySchedules.count)개")
                    .foregroundStyle(.mainMint)
            }
            .padding(.horizontal)
            .font(.regular10)
            
            ScrollView {
                // 필터링된 일정만 표시
                if scheduleVM.todaySchedules.isEmpty {
                    Text("일정이 없습니다.")
                        .font(.regular13)
                        .foregroundStyle(.gray2)
                        .padding(.top, 20)
                } else {
                    ForEach(scheduleVM.todaySchedules, id: \.scheduleId) { schedule in
                        let color = scheduleVM.categoryMap[schedule.category] ?? .gray
                        
                        ScheduleCard(schedule: schedule, color: color)
                    }
                    .padding(.horizontal)
                }
            }
            
            Spacer()
        }
        .task(id: scheduleVM.todaySchedules.count) {
            calendarVM.setMarkers(from: scheduleVM.todaySchedules)
        }
        .task(id: calendarVM.selectDate) {
            await scheduleVM.getSchedules(date: calendarVM.selectDate.toString(format: "yyyy-MM-dd"))

        }
        .sheet(isPresented: $showAddSheet) {
            AddScheduleView() {
                Task {
                    await scheduleVM.getSchedules(date: calendarVM.selectDate.toString(format: "yyyy-MM-dd"))
                }
            }
        }
    }
}

#Preview {
    ScheduleView()
}
