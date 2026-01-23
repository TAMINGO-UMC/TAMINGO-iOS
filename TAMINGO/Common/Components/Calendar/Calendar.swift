//
//  Calendar.swift
//  TAMINGO
//
//  Created by 김도연 on 1/17/26.
//


import SwiftUI

struct CalendarView: View {
    @State var calendarViewModel: CalendarViewModel
    var onDateSelected: ((Date) -> Void)?
    var enableSwipe: Bool = true            // 좌우 스와이프 기능 여부
    var contentPadding: CGFloat
    init(
        calendarViewModel: CalendarViewModel,
        enableSwipe: Bool = true,
        contentPadding: CGFloat = 20,
        onDateSelected: ((Date) -> Void)? = nil,
    ) {
        self.calendarViewModel = calendarViewModel
        self.enableSwipe = enableSwipe
        self.contentPadding = contentPadding
        self.onDateSelected = onDateSelected
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                CalendarHeaderView(
                    calendarViewModel: calendarViewModel,
                    onDateSelected: onDateSelected
                )
                VStack(spacing: 0) {
                    WeekdayHeaderView()
                    MonthlyCalendarView(
                        calendarViewModel: calendarViewModel,
                        onDateSelected: onDateSelected
                    )
                }
                .padding(4)
                .background(.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.08), radius: 4.75, x: 2, y: 3)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .inset(by: 0.04)
                        .stroke(Color(red: 0.95, green: 0.96, blue: 0.96), lineWidth: 0.07781)
                    
                )
            }
            .padding(contentPadding)
            .gesture(
                enableSwipe ?
                DragGesture().onEnded { value in
                    let threshold: CGFloat = 50 // 최소 스와이프 거리
                    if value.translation.width > threshold {
                        // 오른쪽 스와이프 → 이전
                        calendarViewModel.moveCalendar(by: -1, onDateSelected: onDateSelected)
                    } else if value.translation.width < -threshold {
                        // 왼쪽 스와이프 → 다음
                        calendarViewModel.moveCalendar(by: 1, onDateSelected: onDateSelected)
                    }
                }
                : nil
            )
        }
    }
}


// 캘린더 헤더
struct CalendarHeaderView: View {
    @State var calendarViewModel: CalendarViewModel
    var onDateSelected: ((Date) -> Void)? = nil
    var onAddTapped: (() -> Void)? = nil
    
    @State private var showDatePicker = false
    // 사용자가 휠을 돌릴 때 임시로 값을 저장할 변수
    @State private var tempDate = Date()
    
    private var yearAndMonth: (year: String, month: String) {
        let date = calendarViewModel.displayedMonthDate
        return (year: date.toString(format: "yyyy"), month: date.toString(format: "M"))
    }
    
    var body: some View {
        HStack(spacing: 8) {
            // 년/월 표시 영역
            Button {
                // 팝오버가 열릴 때 현재 달력의 날짜로 임시 날짜 초기화
                tempDate = calendarViewModel.displayedMonthDate
                showDatePicker.toggle()
            } label: {
                HStack(spacing: 4) {
                    Text("\(yearAndMonth.year)년 \(yearAndMonth.month)월")
                        .font(.bold18)
                        .foregroundColor(.black)
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                }
            }
            .popover(isPresented: $showDatePicker) {
                VStack(spacing: 0) {
                    HStack {
                        Button("취소") {
                            showDatePicker = false
                        }
                        .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Button("확인") {
                            calendarViewModel.updateSelectedDate(tempDate, onDateSelected: onDateSelected)
                            showDatePicker = false
                        }
                        .font(.headline)
                        .foregroundColor(.mainMint)
                    }
                    .padding([.top, .horizontal])

                    DatePicker(
                        "",
                        selection: $tempDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .frame(width: 300, height: 200)
                }
                .presentationCompactAdaptation(.popover)
            }
            
            Spacer()
            
            Button {
                //TODO: 일정 추가 기능 제작
            } label: {
                HStack(spacing: 4) {
                    Text("추가")
                    Image(systemName: "plus")
                }
                .font(.medium13)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.mainMint)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 16)
    }
}


// 요일 헤더
struct WeekdayHeaderView: View {
    private let weekday = ["일", "월", "화", "수", "목", "금", "토"]
    
    var body: some View {
        HStack {
            ForEach(weekday, id: \.self) { day in
                Text(day)
                    .foregroundStyle(.gray2)
                    .font(.regular13)
                    .frame(maxWidth: .infinity)  // 최대 너비로 확장
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.vertical)
    }
}

// 월 캘린더
struct MonthlyCalendarView: View {
    @State var calendarViewModel: CalendarViewModel
    var onDateSelected: ((Date) -> Void)?
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    
    var body: some View {
        
        LazyVGrid(columns: columns) {
            ForEach(calendarViewModel.extractDate()) { value in

                    let isToday = value.date.isToday
                    let isSelected = value.date.isSameDay(as: calendarViewModel.selectDate)
                    
                    DateButton(
                        value: value,
                        isToday: isToday,
                        isSelected: isSelected,
                        isCurrentMonth: value.isCurrentMonth,
                        onSelectDate: {
                            calendarViewModel.updateSelectedDate(value.date, onDateSelected: onDateSelected)
                        },
                        markers: calendarViewModel.dateMarkers[value.date.startOfDay] ?? []
                    )
                    .padding(.bottom, 8)
            }
        }
    }
}

// 일자 버튼
struct DateButton: View {
    var value: DateValue
    var isToday: Bool
    var isSelected: Bool
    var isCurrentMonth: Bool
    var onSelectDate: () -> Void
    var markers: [Marker] // 마커 배열
    
    var body: some View {
        Button {
            onSelectDate()
        } label: {
            VStack(spacing: 0) {
                Text("\(value.day)")
                    .frame(width: 36, height: 36)
                    .font(.regular13)
                    .foregroundStyle(isSelected ? .mainMint : (isCurrentMonth ? .black00 : .gray1))
                
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
            .padding([.bottom, .horizontal], 4)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? .mainMint.opacity(0.2) : (isToday ? .subMint: .clear)
                )
            )
            .frame(height: 30)
        }
    }
}

#Preview {
    let viewModel = CalendarViewModel()
    
    // 프리뷰가 로드될 때 마커 데이터 주입
    viewModel.addMarker(for: Date(), color: .red)
    viewModel.addMarker(for: Date(), color: .blue)
    
    return CalendarView(calendarViewModel: viewModel)
}
