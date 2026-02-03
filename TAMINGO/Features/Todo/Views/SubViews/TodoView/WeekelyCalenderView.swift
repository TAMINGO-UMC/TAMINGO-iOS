//
//  WeeklyCalendarView.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/2/26.
//

import SwiftUI

struct WeeklyCalendarView: View {
    @Bindable var calendarViewModel: CalendarViewModel
    @Binding var isExpanded: Bool
    var onDateSelected: ((Date) -> Void)?

    @State private var baseDate: Date = Date()
    @State private var currentWeekOffset: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // 헤더: 년월 + 주차 + Chevron
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: 4) {
                    Text(headerText)
                        .font(.medium14)
                        .foregroundColor(.black)
                    
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.system(size: 12))
                        .foregroundColor(.gray2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 44)
                .padding(.horizontal, 21)
                .background(Color.white)
            }
            
            // 주간 캘린더 (확장 시)
            if isExpanded {
                ZStack {
                    // 고정된 배경 박스
                    VStack(spacing: 0) {
                        // 요일 헤더 (고정)
                        HStack(spacing: 7) {
                            ForEach(["일", "월", "화", "수", "목", "금", "토"], id: \.self) { day in
                                Text(day)
                                    .font(.regular13)
                                    .foregroundColor(.gray2)
                                    .frame(width: 40)
                            }
                        }
                        .padding(.top, 12)
                        .padding(.bottom, 8)
                        
                        Spacer()
                            .frame(height: 48) // 날짜 공간
                    }
                    .frame(width: 333, height: 107.46)
                    .background(Color.white)
                    .cornerRadius(13)
                    .shadow(color: Color.black.opacity(0.08), radius: 4.75, x: 2, y: 3)
                    
                    // 스크롤되는 날짜 (ZStack 위에)
                    GeometryReader { geometry in
                        ScrollViewReader { proxy in
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 0) {
                                    ForEach(-52...52, id: \.self) { weekOffset in
                                        WeekDatesRow(
                                            calendarViewModel: calendarViewModel,
                                            baseDate: baseDate,
                                            weekOffset: weekOffset,
                                            onDateSelected: { date in
                                                onDateSelected?(date)
                                            }
                                        )
                                        .frame(width: 333)
                                        .id(weekOffset)
                                    }
                                }
                                .background(
                                    GeometryReader { contentGeometry in
                                        Color.clear
                                            .preference(
                                                key: ScrollOffsetPreferenceKey.self,
                                                value: contentGeometry.frame(in: .named("scroll")).origin.x
                                            )
                                    }
                                )
                            }
                            .coordinateSpace(name: "scroll")
                            .scrollTargetBehavior(.paging)
                            .padding(.top, 32)
                            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
                                // 스크롤 위치 기반으로 주차 계산
                                let pageWidth: CGFloat = 333
                                let newOffset = Int(round(-offset / pageWidth))
                                if newOffset != currentWeekOffset {
                                    currentWeekOffset = newOffset
                                }
                            }
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    proxy.scrollTo(0, anchor: .center)
                                }
                            }
                        }
                    }
                    .frame(width: 333, height: 107.46)
                }
                .padding(.top, 12)
                .padding(.bottom, 16)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .onAppear {
            // 뷰가 처음 나타날 때 기준 날짜 설정
            baseDate = calendarViewModel.selectDate
        }
    }
    
    // MARK: - 헤더 텍스트 계산 (현재 보이는 주의 년/월/주차)
    private var headerText: String {
        let calendar = Calendar.current
        
        // baseDate 기준으로 현재 스크롤된 주의 시작일 계산
        guard let targetWeekDate = calendar.date(byAdding: .weekOfYear, value: currentWeekOffset, to: baseDate),
              let startOfTargetWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: targetWeekDate)) else {
            return ""
        }
        
        // 주의 중간 날짜(수요일)를 기준으로 월/년도 결정 (더 정확한 표시를 위해)
        guard let midWeekDate = calendar.date(byAdding: .day, value: 3, to: startOfTargetWeek) else {
            return ""
        }
        
        let year = calendar.component(.year, from: midWeekDate)
        let month = calendar.component(.month, from: midWeekDate)
        let weekOfMonth = calculateWeekOfMonth(for: midWeekDate, in: calendar)
        
        return "\(year)년 \(month)월 \(weekOfMonth)째주"
    }
    
    // MARK: - 해당 월의 몇째 주인지 계산
    private func calculateWeekOfMonth(for date: Date, in calendar: Calendar) -> Int {
        // 해당 날짜가 속한 월의 1일
        let components = calendar.dateComponents([.year, .month], from: date)
        guard let firstDayOfMonth = calendar.date(from: components) else {
            return 1
        }
        
        // 1일이 속한 주의 시작일 (일요일)
        guard let firstWeekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: firstDayOfMonth)) else {
            return 1
        }
        
        // 입력된 날짜가 속한 주의 시작일 (일요일)
        guard let targetWeekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)) else {
            return 1
        }
        
        // 두 주 사이의 주 차이 계산
        let weeksDifference = calendar.dateComponents([.weekOfYear], from: firstWeekStart, to: targetWeekStart).weekOfYear ?? 0
        
        return weeksDifference + 1
    }
}

// MARK: - Scroll Offset Preference Key
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Week Dates Row (날짜만 - 스크롤됨)
struct WeekDatesRow: View {
    @Bindable var calendarViewModel: CalendarViewModel
    let baseDate: Date  // 고정된 기준 날짜
    let weekOffset: Int
    var onDateSelected: ((Date) -> Void)?
    
    private var weekDates: [DateValue] {
        let calendar = Calendar.current
        
        // baseDate 기준으로 주 계산 (selectDate가 아님!)
        guard let targetDate = calendar.date(byAdding: .weekOfYear, value: weekOffset, to: baseDate) else {
            return []
        }
        
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: targetDate)) else {
            return []
        }
        
        return (0..<7).compactMap { dayOffset in
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek) {
                let day = calendar.component(.day, from: date)
                // 현재 표시중인 주의 월과 비교
                let isCurrentMonth = calendar.isDate(date, equalTo: targetDate, toGranularity: .month)
                return DateValue(day: day, date: date, isCurrentMonth: isCurrentMonth)
            }
            return nil
        }
    }
    
    var body: some View {
        HStack(spacing: 7) {
            ForEach(weekDates) { dateValue in
                WeekDayCell(
                    dateValue: dateValue,
                    isToday: dateValue.date.isToday,
                    isSelected: dateValue.date.isSameDay(as: calendarViewModel.selectDate),
                    markers: calendarViewModel.dateMarkers[dateValue.date.startOfDay] ?? [],
                    onSelect: {
                        // 날짜만 업데이트하고 스크롤은 하지 않음
                        calendarViewModel.selectDate = dateValue.date.startOfDay
                        onDateSelected?(dateValue.date)
                    }
                )
            }
        }
    }
}

// MARK: - Week Day Cell
struct WeekDayCell: View {
    let dateValue: DateValue
    let isToday: Bool
    let isSelected: Bool
    let markers: [Marker]
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 4) {
                // 날짜
                Text("\(dateValue.day)")
                    .font(.regular13)
                    .foregroundColor(
                        isSelected ? .mainMint :
                        (dateValue.isCurrentMonth ? .black : .gray2)
                    )
                    .frame(width: 40, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isSelected ? Color.subMint : Color.clear)
                    )
                
                // 마커
                HStack(spacing: 1) {
                    if markers.isEmpty {
                        Circle()
                            .fill(.clear)
                            .frame(width: 4, height: 4)
                    } else {
                        ForEach(markers.prefix(3), id: \.self) { marker in
                            Circle()
                                .fill(marker.color)
                                .frame(width: 4, height: 4)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    WeeklyCalendarView(
        calendarViewModel: CalendarViewModel(),
        isExpanded: .constant(true)
    )
}
