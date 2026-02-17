//
//  TodoWeeklyCalendarView.swift
//  TAMINGO
//
//  Created by Claude on 2/9/26.
//  Todo 전용 주간 캘린더 (마커 표시 지원)
//

import SwiftUI

// MARK: - ScrollOffsetPreferenceKey
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - TodoWeeklyCalendarView
struct TodoWeeklyCalendarView: View {
    @Bindable var viewModel: TodoWeeklyCalendarViewModel
    @Binding var isExpanded: Bool
    var onDateSelected: ((Date) -> Void)?
    
    @State private var baseDate: Date = Date()
    @State private var currentWeekOffset: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // 헤더 부분
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
                GeometryReader { outerGeometry in
                    let totalWidth = outerGeometry.size.width
                    let calendarContentWidth = totalWidth - 42
                    
                    VStack(spacing: 12) {
                        ZStack {
                            // 고정된 배경 박스
                            VStack(spacing: 0) {
                                HStack(spacing: 0) { // 요일 간격 0으로 설정 후 내부에서 등분
                                    ForEach(["일", "월", "화", "수", "목", "금", "토"], id: \.self) { day in
                                        Text(day)
                                            .font(.regular13)
                                            .foregroundColor(.gray2)
                                            .frame(width: calendarContentWidth / 7) // 수정됨: 7등분
                                    }
                                }
                                .padding(.top, 12)
                                .padding(.bottom, 8)
                                
                                Spacer().frame(height: 48)
                            }
                            // 정너비 333 제거하고 계산된 너비 적용
                            .frame(width: calendarContentWidth, height: 107.46)
                            .background(Color.white)
                            .cornerRadius(13)
                            .shadow(color: Color.black.opacity(0.08), radius: 4.75, x: 2, y: 3)
                            
                            // 스크롤되는 날짜
                            ScrollViewReader { proxy in
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack(spacing: 0) {
                                        ForEach(-52...52, id: \.self) { weekOffset in
                                            TodoWeekDatesRow(
                                                viewModel: viewModel,
                                                baseDate: baseDate,
                                                weekOffset: weekOffset,
                                                // 각 행에 계산된 너비 전달
                                                rowWidth: calendarContentWidth,
                                                onDateSelected: { date in
                                                    onDateSelected?(date)
                                                }
                                            )
                                            .frame(width: calendarContentWidth) // frame 설정
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
                                    // pageWidth를 유동적인 calendarContentWidth로 변경
                                    let newOffset = Int(round(-offset / calendarContentWidth))
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
                        .frame(width: calendarContentWidth, height: 107.46)
                        // ZStack을 화면 가로 중앙에 배치
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        // ✅ 카테고리 범례
                        if !viewModel.legendCategories.isEmpty {
                            CategoryLegend(categories: viewModel.legendCategories)
                                .padding(.horizontal, 21)
                        }
                    }
                }
                .frame(height: viewModel.legendCategories.isEmpty ? 120 : 150)
                .padding(.bottom, 16)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .onAppear {
            baseDate = viewModel.selectDate
        }
    }
    
    // 스크롤된 위치 기준 헤더 텍스트
    private var headerText: String {
        let calendar = Calendar.current
        guard let targetWeekDate = calendar.date(byAdding: .weekOfYear, value: currentWeekOffset, to: baseDate),
              let startOfTargetWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: targetWeekDate)),
              let midWeekDate = calendar.date(byAdding: .day, value: 3, to: startOfTargetWeek) else {
            return ""
        }
        
        let year = calendar.component(.year, from: midWeekDate)
        let month = calendar.component(.month, from: midWeekDate)
        let weekOfMonth = calculateWeekOfMonth(for: midWeekDate, in: calendar)
        
        return "\(year)년 \(month)월 \(weekOfMonth)째주"
    }
    
    private func calculateWeekOfMonth(for date: Date, in calendar: Calendar) -> Int {
        let components = calendar.dateComponents([.year, .month], from: date)
        guard let firstDayOfMonth = calendar.date(from: components),
              let firstWeekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: firstDayOfMonth)),
              let targetWeekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)) else {
            return 1
        }
        let weeksDifference = calendar.dateComponents([.weekOfYear], from: firstWeekStart, to: targetWeekStart).weekOfYear ?? 0
        return weeksDifference + 1
    }
}

// MARK: - 주간 날짜 행
struct TodoWeekDatesRow: View {
    @Bindable var viewModel: TodoWeeklyCalendarViewModel
    let baseDate: Date
    let weekOffset: Int
    let rowWidth: CGFloat // 너비 파라미터 추가
    var onDateSelected: ((Date) -> Void)?
    
    private var weekDates: [DateValue] {
        let calendar = Calendar.current
        guard let targetDate = calendar.date(byAdding: .weekOfYear, value: weekOffset, to: baseDate),
              let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: targetDate)) else {
            return []
        }
        return (0..<7).compactMap { dayOffset in
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek) {
                let day = calendar.component(.day, from: date)
                let isCurrentMonth = calendar.isDate(date, equalTo: targetDate, toGranularity: .month)
                return DateValue(day: day, date: date, isCurrentMonth: isCurrentMonth)
            }
            return nil
        }
    }
    
    var body: some View {
        HStack(spacing: 0) { // 간격 0으로 수정
            ForEach(weekDates) { dateValue in
                TodoWeekDayCell(
                    dateValue: dateValue,
                    isToday: dateValue.date.isToday,
                    isSelected: dateValue.date.isSameDay(as: viewModel.selectDate),
                    cellWidth: rowWidth / 7, // 셀 너비 7등분
                    markers: viewModel.dateMarkers[dateValue.date.startOfDay] ?? [],
                    onSelect: {
                        viewModel.selectDate = dateValue.date.startOfDay
                        onDateSelected?(dateValue.date)
                    }
                )
            }
        }
        .frame(width: rowWidth)
    }
}

// MARK: - 주간 날짜 셀 (마커 표시)
struct TodoWeekDayCell: View {
    let dateValue: DateValue
    let isToday: Bool
    let isSelected: Bool
    let cellWidth: CGFloat // 너비 파라미터 추가
    let markers: [TodoMarker]
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 4) {
                Text("\(dateValue.day)")
                    .font(.regular13)
                    .foregroundColor(isSelected ? .mainMint : (dateValue.isCurrentMonth ? .black : .gray2))
                    .frame(width: 40, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isSelected ? Color.subMint : Color.clear)
                    )
                
                // ✅ 마커 표시 (최대 3개)
                HStack(spacing: 1) {
                    ForEach(markers.prefix(3), id: \.self) { marker in
                        Circle()
                            .fill(marker.color)
                            .frame(width: 4, height: 4)
                    }
                }
                .frame(height: 4)
            }
            .frame(width: cellWidth) // 7등분된 너비 적용하여 균등 배분
        }
    }
}

// MARK: - 카테고리 범례
struct CategoryLegend: View {
    let categories: [(category: String, color: Color)]
    
    var body: some View {
        HStack(spacing: 12) {
            Text("카테고리")
                .font(.regular12)
                .foregroundColor(.gray2)
            
            ForEach(categories, id: \.category) { item in
                HStack(spacing: 4) {
                    Circle()
                        .fill(item.color)
                        .frame(width: 8, height: 8)
                    
                    Text(item.category)
                        .font(.regular12)
                        .foregroundColor(.black)
                }
            }
            
            Spacer()
        }
    }
}
