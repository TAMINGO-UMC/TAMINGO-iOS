//
//  SetupView.swift
//  TAMINGO
//
//  Created by 권예원 on 1/16/26.
//

import SwiftUI
import UIKit

enum SetUpActivePicker: Equatable {

    case transport(rank: Int)
    case arrivalTime
    case activityTime(ActivityTimePicker)
    enum ActivityTimePicker: Equatable {
        case start
        case end
    }
}


struct SetupView: View {
    
    @Bindable var vm: SetupViewModel
    @Binding var isCompleted: Bool
    
    @State private var isStartActive: Bool = false
    @State private var isEndActive: Bool = false
    @State private var isPlaceSearchPresented = false
    @State private var activePicker: SetUpActivePicker? = nil



    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                TimeSectionView(
                    startTime: $vm.startTime,
                    endTime: $vm.endTime,
                    didSelectStartTime: $vm.didSelectStartTime,
                    didSelectEndTime: $vm.didSelectEndTime,
                    activePicker: $activePicker
                )

                PlacesSectionView(
                    isPlaceSearchPresented: $isPlaceSearchPresented,
                    places: vm.places,
                    onDelete: { place in
                        vm.removePlace(place)
                    }
                )

                TrafficSectionView(vm: vm, activePicker: $activePicker)
                TrafficTimeSectionView(buffer: $vm.arrivalBuffer, activePicker: $activePicker)
            }
            .padding(.vertical,10)
        }
        .scrollIndicators(.hidden)
        .frame(width:330, height: 459)
        .onChange(of: vm.isValid) { _, newValue in
            isCompleted = newValue
        }
        .sheet(isPresented: $isPlaceSearchPresented) {
            PlaceSearchSheet(
                editingPlace: nil
            ) { place in
                vm.addPlace(place)
                isPlaceSearchPresented = false
            }
            .presentationDetents([.height(701)])
            .presentationBackground(.white)
        }
    }
    


}

struct TimeSectionView: View {
    @Binding var startTime: Date
    @Binding var endTime: Date
    
    @Binding var didSelectStartTime: Bool
    @Binding var didSelectEndTime: Bool

    @Binding var activePicker: SetUpActivePicker?


    var body: some View {
        VStack(spacing: 12) {

            TimeRow(
                title: "주요 활동 시작 시각",
                isHighlighted: activePicker == .activityTime(.start),   // 카드 보더
                isFilled: didSelectStartTime,                // 캡슐 색상
                backgroundColor: .subMint,
                highlightColor: .mainMint,
                date: $startTime,
                onActivate: {
                    activePicker = .activityTime(.start)
                },
                onDismiss: {
                    if activePicker == .activityTime(.start) {
                        activePicker = nil
                    }
                },
                onTimeChanged: {
                    didSelectStartTime = true
                }
            )

            TimeRow(
                title: "주요 활동 종료 시각",
                isHighlighted: activePicker == .activityTime(.end),
                isFilled: didSelectEndTime,
                backgroundColor: .subPink,
                highlightColor: .mainPink,
                date: $endTime,
                onActivate: {
                    activePicker = .activityTime(.end)
                },
                onDismiss: {
                    if activePicker == .activityTime(.end) {
                        activePicker = nil
                    }
                },
                onTimeChanged: {
                    didSelectEndTime = true
                }
            )
        }
    }
}


struct TimeRow: View {
    let title: String
    let isHighlighted: Bool   // 카드 보더
    let isFilled: Bool        // 캡슐 색상

    let backgroundColor: Color
    let highlightColor: Color

    @Binding var date: Date

    let onActivate: () -> Void
    let onDismiss: () -> Void
    let onTimeChanged: () -> Void

    var body: some View {
        HStack {
            Text(title)
                .font(.semiBold16)

            Spacer()

            CapsuleTimePicker(
                date: $date,
                isSelected: isFilled,
                backgroundColor: backgroundColor,
                highlightColor: highlightColor,
                onActivate: onActivate,
                onDismiss: onDismiss,
                onTimeChanged: onTimeChanged
            )
        }
        .modifier(FormCard(isHighlighted: isHighlighted))
    }
}
 


struct PlacesSectionView: View {
    @Binding var isPlaceSearchPresented: Bool
    let places: [Place]
    let onDelete: (Place) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 11) {
            header
            inputRow
            placeList
        }
        .modifier(FormCard())
    }

    private var header: some View {
        HStack {
            Text("자주 가는 장소")
                .font(.semiBold16)
            Text("(최대 5개)")
                .font(.medium13)
                .foregroundStyle(.gray2)
            Spacer()
        }
        .padding(.bottom, 17.39)
    }

    private var inputRow: some View {
        HStack {
            Button (action:{
                isPlaceSearchPresented = true
            }, label: {
                VStack(spacing: 5){
                    Group{
                        HStack(){
                            Text("도로명, 지번, 건물명 검색")
                                .font(.regular12)
                                .foregroundStyle(.gray2)
                            Spacer()
                            Image("icon_search")
                                .frame(width: 21.466, height: 21.466)
                            
                        }
                        Divider()
                    }
                    .frame(width: 196)
                }
            })
            Spacer()
            
            Button (action : {
                isPlaceSearchPresented = true
            }, label: {
                VStack {
                    Text("장소 이름")
                        .font(.regular12)
                        .foregroundStyle(.gray2)
                        .multilineTextAlignment(.center)
                    Divider()
                }
                .frame(width: 66)
            } )
            
        }
    }
    
    private var placeList: some View {
        VStack(spacing: 4) {
            ForEach(places) { place in
                PlaceListRow(
                    address: place.address,
                    name: place.name,
                    onDelete: {
                        onDelete(place)
                    }
                )
            }
        }

    }
}


struct TrafficSectionView: View {
    @Bindable var vm: SetupViewModel
    @Binding var activePicker: SetUpActivePicker?
    @State private var labelFrames: [Int: CGRect] = [:]
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("선호하는 이동 수단")
                        .font(.semiBold16)
                    Spacer()
                }
                .padding(.bottom, 15)

                HStack(spacing: 18) {
                    ForEach(1...3, id: \.self) { rank in
                        let transport = vm.transport(for: rank)
                        RankLabel(
                            rank: rank,
                            title: (transport == nil || transport == TransportType.none)
                                ? "Label"
                                : transport!.title
                        ) {
                            activePicker = .transport(rank: rank)
                        }
                        .frame(maxWidth: .infinity)
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .onAppear {
                                        labelFrames[rank] = geo.frame(in: .named("TrafficSpace"))
                                    }
                            }
                        )
                    }
                }
            }
            .modifier(FormCard())
            .coordinateSpace(name: "TrafficSpace")

            if case let .transport(rank) = activePicker,
               let frame = labelFrames[rank] {

                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        activePicker = nil
                    }

                RankWheelPicker(
                    selection: Binding(
                        get: { vm.transport(for: rank) ?? .none },
                        set: { newValue in
                            vm.updateTransport(newValue, for: rank)
                            activePicker = nil
                        }
                    ),
                    isDisabled: { type in
                        vm.isTransportSelected(type, excluding: rank)
                    }
                )
                .position(x: frame.midX + 10, y: frame.minY - 45)
                .transition(.scale.combined(with: .opacity))
                .zIndex(10)
            }
        }
    }
}


struct RankWheelPicker: View {
    @Binding var selection: TransportType
    let isDisabled: (TransportType) -> Bool

    var body: some View {
        SelectList(
            items: TransportType.allCases,
            selected: selection,
            width: 86,
            isDisabled: isDisabled
        ) { selected in
            selection = selected             
        } titleProvider: { item in
            item.title
        }
    }
}




struct TrafficTimeSectionView: View {
    @Binding var buffer: ArrivalBufferType
    @Binding var activePicker: SetUpActivePicker?
    @State private var buttonFrame: CGRect = .zero

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 8) {

                HStack {
                    Text("목표 도착 시간")
                        .font(.semiBold16)

                    Spacer()

                    Button {
                        activePicker = .arrivalTime
                    } label: {
                        HStack(spacing: 4) {
                            Text("\(buffer.rawValue)분 전")
                                .font(.medium13)
                                .foregroundStyle(.mainPink)
                            Image("icon_pinkChevron")
                        }
                    }
                    .buttonStyle(.plain)
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    buttonFrame = geo.frame(in: .named("ArrivalTimeSpace"))
                                }
                        }
                    )
                }

                Text("T-\(buffer.rawValue)분 기준으로 역산 알림이 전송됩니다.")
                    .font(.regular10)
                    .foregroundStyle(.gray2)
            }
            .modifier(FormCard())
            .coordinateSpace(name: "ArrivalTimeSpace")

            if activePicker == .arrivalTime {

                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        activePicker = nil
                    }

                SelectList(
                    items: ArrivalBufferType.allCases,
                    selected: buffer,
                    width: 86,
                    isDisabled: { _ in false }
                ) { selected in
                    buffer = selected
                    activePicker = nil
                } titleProvider: { item in
                    "\(item.rawValue)분 전"
                }
                .position(x: buttonFrame.midX , y: buttonFrame.minY - 35)
                .transition(.scale.combined(with: .opacity))
                .zIndex(10)
            }
        }
    }
}


struct FormCard: ViewModifier {
    var isHighlighted: Bool = false

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(
                        isHighlighted ? .gray2 :.gray1,
                        lineWidth: 1
                    )
            )
            .shadow(
                color: .black.opacity(0.05),
                radius: 4,
                x: 0,
                y: 2.069
            )
    }
}


// 프리뷰용
//struct SetupView_PreviewWrapper: View {
//    @State private var isCompleted: Bool = false
//
//    var body: some View {
//        SetupView(isCompleted: $isCompleted)
//            .padding()
//            .background(Color.gray.opacity(0.1))
//    }
//}
//
//#Preview {
//    SetupView_PreviewWrapper()
//}
