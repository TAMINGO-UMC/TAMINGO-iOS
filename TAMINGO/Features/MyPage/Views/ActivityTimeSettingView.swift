//
//  ActivityTimeSettingView.swift
//  TAMINGO
//
//  Created by 권예원 on 2/7/26.
//

import SwiftUI

struct ActivityTimeSettingView: View {

    @State private var vm = TimeSettingViewModel()
    let onSave: (ActivityTime) -> Void

    var body: some View {
        VStack(alignment:.leading, spacing:12) {
            header
            VStack{
                ActivityTimeSection(
                    startTime: $vm.startTime,
                    endTime: $vm.endTime,
                    timeDescription: vm.timeDescription,
                    startOffset: vm.startOffsetRatio,
                    duration: vm.activityProgress,
                    onStartTimeChanged: { vm.didSelectStartTime = true },
                    onEndTimeChanged: { vm.didSelectEndTime = true }
                )

                WeekdaySection(vm: $vm)

                SaveButton(
                    isEnabled: vm.canSave,
                    onTap: {
                        onSave(vm.makeActivityTime())
                    }
                )
                
                GuideBoxView(
                    title: "활동 시간 안내",
                    description: """
    • 설정한 시간을 기반으로 하루 일정을 구성합니다
    • 설정한 시간 외에는 알림이 울리지 않습니다
    • To-do 자동 제안도 활동 시간 내에만 발송됩니다
    """
                )
                
                Spacer()
            }
            .padding(.top, 16)
        }
        .padding(.horizontal, 32)
    }
    
    var header: some View {
        HStack(spacing: 14){
            Button(action: {
                
            }, label: {
                Image("Previous_Chevron")
                    .resizable()
                    .frame(width: 5, height: 10)
            })
            
            Text("활동 시간 설정")
                .font(.semiBold16)
                .foregroundStyle(.black00)
        }
    }
}



struct ActivityTimeSection: View {

    @Binding var startTime: Date
    @Binding var endTime: Date

    let timeDescription: String
    let startOffset: CGFloat
    let duration: CGFloat

    let onStartTimeChanged: () -> Void
    let onEndTimeChanged: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            TimeInputButton(
                title: "활동 시작 시간",
                date: $startTime,
                onTimeChanged: onStartTimeChanged
            )

            TimeInputButton(
                title: "활동 종료 시간",
                date: $endTime,
                onTimeChanged: onEndTimeChanged
            )

            Text(timeDescription)
                .font(.regular12)
                .foregroundColor(.gray2)
                .frame(maxWidth: .infinity, alignment: .leading)

            ActiveTimeProgressBar(
                startOffset: startOffset,
                duration: duration
            )
        }
        .padding(16)
        .cardStyle()
    }
}

struct TimeInputButton: View {
    let title: String
    @Binding var date: Date
    let onTimeChanged: () -> Void

    @State private var showPicker = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.regular12)
                .foregroundColor(.gray2)

            Button {
                showPicker = true
            } label: {
                HStack {
                    Text(date.toString(format: "HH:mm"))
                        .foregroundColor(.gray2)
                        .font(.medium14)
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.gray0)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                    .inset(by: 0.25)
                    .stroke(.gray1, lineWidth: 0.5)
                )
            }
            .buttonStyle(.plain)
            .popover(
                isPresented: $showPicker,
                attachmentAnchor: .rect(.bounds),
                arrowEdge: .top
            ) {
                UIKitTimePicker(
                    date: $date,
                    onTimeChanged: onTimeChanged
                )
                .frame(width: 260, height: 280)
                .presentationCompactAdaptation(.popover)
            }
        }
    }
}

struct ActiveTimeProgressBar: View {
    let startOffset: CGFloat
    let duration: CGFloat
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color(red: 245/255, green: 245/255, blue: 245/255))
                
                Capsule()
                    .fill(.mainPink)
                    .frame(width: geo.size.width * duration)
                    .offset(x: geo.size.width * startOffset)
            }
        }
        .frame(height: 10)
    }
}

struct WeekdaySection: View {
    @Binding var vm: TimeSettingViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text("활동 요일")
                .font(.regular12)
                .foregroundColor(.gray2)

            VStack(spacing: 12) {

                weekdayRow("월요일", day: .mon)
                weekdayRow("화요일", day: .tue)
                weekdayRow("수요일", day: .wed)
                weekdayRow("목요일", day: .thu)
                weekdayRow("금요일", day: .fri)

                Divider().padding(.vertical, 8)

                weekendRow()
            }
        }
        .padding()
        .cardStyle()
    }

    private func weekdayRow(
        _ title: String,
        day: Weekday
    ) -> some View {
        HStack {
            Text(title)
                .font(.medium14)

            Spacer()

            ToggleButton(
                isOn: Binding(
                    get: {
                        vm.isDayActive(day)
                    },
                    set: { isOn in
                        vm.toggleDay(day, isOn: isOn)
                    }
                )
            )
        }
    }

    private func weekendRow() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("주말")
                    .font(.medium14)
                    .foregroundStyle(.black00)

                Text("토요일, 일요일")
                    .font(.regular12)
                    .foregroundColor(.gray2)
            }

            Spacer()

            ToggleButton(
                isOn: Binding(
                    get: {
                        vm.isWeekendActive()
                    },
                    set: { isOn in
                        vm.toggleWeekend(isOn: isOn)
                    }
                )
            )
        }
    }

}

struct SaveButton: View {
    let isEnabled: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text("저장")
                .font(.semiBold14)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 47)
                .background(isEnabled ? .mainMint : .gray1)
                .cornerRadius(5)
                .shadow(color: .black.opacity(0.06),
                        radius: 3.4, x: 0, y: 2.3)
        }
        .disabled(!isEnabled)
    }
}




#Preview {
    ActivityTimeSettingView(onSave: {_ in 
        print("save")
    })
}
