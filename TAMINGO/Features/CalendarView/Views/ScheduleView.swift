//
//  ScheduleView.swift
//  TAMINGO
//
//  Created by 김도연 on 1/22/26.
//

import SwiftUI

struct ScheduleView: View {
    @State private var calendarVM = CalendarViewModel()
    
    @State private var showAddSheet = false
    @State private var showEditSheet: Bool = false
    @State private var selectedSchedule: ScheduleListDTO? = nil
    
    var body: some View {
        VStack {
            CalendarView(
                calendarViewModel: calendarVM,
                onDateSelected: { date in
                    print("선택된 날짜: \(date.toString(format: "yyyy-MM-dd"))")
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
                Text("\(calendarVM.selectedDateSchedules.count)개")
                    .foregroundStyle(.mainMint)
            }
            .padding(.horizontal)
            .font(.regular10)
            
            ScrollView {
                // 필터링된 일정만 표시
                if calendarVM.selectedDateSchedules.isEmpty {
                    Text("일정이 없습니다.")
                        .font(.regular13)
                        .foregroundStyle(.gray2)
                        .padding(.top, 20)
                } else {
                    ForEach(calendarVM.selectedDateSchedules, id: \.scheduleId) { schedule in
                        let color = calendarVM.categoryMap[schedule.category] ?? .gray
                        
                        Button {
                            self.selectedSchedule = schedule
                        } label: {
                            ScheduleCard(schedule: schedule, color: color)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            Spacer()
        }
        .task(id: calendarVM.displayedMonthDate) {
            await calendarVM.fetchData()
        }
        .sheet(isPresented: $showAddSheet) {
            AddScheduleView() {
                Task {
                    await calendarVM.fetchData()
                }
            }
        }
        .sheet(item: $selectedSchedule) { schedule in
            EditScheduleView(scheduleId: schedule.scheduleId) {
                Task {
                    await calendarVM.fetchData()
                }
            }
        }
    }
}

#Preview {
    ScheduleView()
}
