//
//  SetupView.swift
//  TAMINGO
//
//  Created by 권예원 on 1/16/26.
//

import SwiftUI
import UIKit



struct SetupView: View {
    
    @State private var vm: SetupViewModel = .init()
    @Binding var isCompleted: Bool
    
    @State private var isStartActive: Bool = false
    @State private var isEndActive: Bool = false


    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                TimeSectionView(
                    startTime: $vm.startTime,
                    endTime: $vm.endTime,
                    isStartActive: $isStartActive,
                    isEndActive: $isEndActive
                )

                PlacesSectionView(
                    searchPlace: $vm.searchAddress,
                    placeName: $vm.placeName
                )

                TrafficSectionView(vm: $vm)
                TrafficTimeSectionView(buffer: $vm.arrivalBuffer)
            }
            .padding(.vertical,10)
        }
        .scrollIndicators(.hidden)
        .frame(width:330, height: 459)
        .onChange(of: vm.isValid) { _, newValue in
            isCompleted = newValue
        }
    }
}

struct TimeSectionView: View {
    @Binding var startTime: Date
    @Binding var endTime: Date

    @Binding var isStartActive: Bool
    @Binding var isEndActive: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            TimeRow(
                title: "주요 활동 시작 시각",
                isSelected: isStartActive,
                backgroundColor: .subMint,
                highlightColor: .mainMint,
                date: $startTime,
                onTimeChanged: {
                    isStartActive = true
                }
            )

            TimeRow(
                title: "주요 활동 종료 시각",
                isSelected: isEndActive,
                backgroundColor: .subPink,
                highlightColor: .mainPink,
                date: $endTime,
                onTimeChanged: {
                    isEndActive = true
                }
            )
        }
    }
}

struct TimeRow: View {
    let title: String
    let isSelected: Bool
    let backgroundColor: Color
    let highlightColor: Color
    
    @Binding var date: Date
    
    let onTimeChanged: () -> Void
    

    var body: some View {
        HStack {
            Text(title)
                .font(.semiBold16)
            Spacer()
            CapsuleTimePicker(
                date: $date,
                isSelected: isSelected,
                backgroundColor: backgroundColor,
                highlightColor: highlightColor,
                onTimeChanged: onTimeChanged
            )
        }
        .modifier(FormCard())
    }
}

struct PlacesSectionView: View {
    @Binding var searchPlace: String
    @Binding var placeName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 11) {
            header
            inputRow
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
            addressInput
            Spacer()
            nameInput
        }
    }

    private var addressInput: some View {
        VStack(spacing: 5) {
            HStack {
                TextField("도로명, 지번, 건물명 검색", text: $searchPlace)
                    .font(.regular12)
                Button (action:{
                    // TODO: 장소 검색 및 등록 기능 구현
                }, label: {
                    Image("icon_search")
                })
                .frame(width: 21.466, height: 21.466)
            }
            Divider()
        }
        .frame(width: 196)
    }

    private var nameInput: some View {
        VStack {
            TextField("장소 이름", text: $placeName)
                .font(.regular12)
                .multilineTextAlignment(.center)
            Divider()
        }
        .frame(width: 66)
    }
}


struct TrafficSectionView: View {
    @Binding var vm: SetupViewModel
    
    @State private var showPicker = false
    @State private var selectedRank: Int = 1
    
    var body: some View {
        VStack{
            HStack {
                Text("선호하는 이동 수단")
                    .font(.semiBold16)
                Spacer()
            }
            .padding(.bottom, 15)
            HStack(spacing: 18) {
                ForEach(1...3, id: \.self) { rank in
                    RankLabel(
                        rank: rank,
                        title: vm.transport(for: rank)?.title ?? "Label"
                    ) {
                        selectedRank = rank
                        showPicker = true
                    }
                    .frame(maxWidth: .infinity)
                    .popover(
                        isPresented: Binding(
                                    get: {
                                        showPicker && selectedRank == rank
                                    },
                                    set: { newValue in
                                        showPicker = newValue
                                    }
                                ),
                        attachmentAnchor: .rect(.bounds),
                        arrowEdge: .bottom
                    ) {
                        RankWheelPicker(
                            selection: Binding(
                                get: {
                                    vm.transport(for: rank) ?? .none
                                },
                                set: { newValue in
                                    vm.updateTransport(newValue, for: rank)
                                }
                            ),
                            isDisabled: { type in
                                vm.isTransportSelected(type, excluding: selectedRank)
                            }
                        )
                        .presentationCompactAdaptation(.popover)
                    }
                }
            }

        }
        .modifier(FormCard())
    }
}

// 임시 픽커
struct RankWheelPicker: View {
    @Binding var selection: TransportType
    let isDisabled: (TransportType) -> Bool

    var body: some View {
        Picker("", selection: $selection) {
            ForEach(TransportType.allCases) { type in
                Text(type.title)
                    .tag(type)
                    .disabled(isDisabled(type))
            }
        }
        .pickerStyle(.wheel)
        .frame(width: 220, height: 200)
    }
}



struct TrafficTimeSectionView: View {
    @Binding var buffer: ArrivalBufferType

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            HStack {
                Text("목표 도착 시간") // TODO: 디자인 확정 후 섹션 제목 변경 예정
                    .font(.semiBold16)

                Spacer()

                Button {
                    // TODO: picker / popover 연결
                } label: {
                    HStack(spacing: 4) {
                        Text(buffer.title)
                            .font(.medium13)
                            .foregroundStyle(.mainPink)
                        Image("icon_pinkChevron")

//                        VStack(spacing:2.5){
//                            Image(systemName: "chevron.up")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 10)
//                                .foregroundStyle(.mainPink)
//                            Image(systemName: "chevron.down")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 10)
//                                .foregroundStyle(.mainPink)
//                        }
                    }
                }
                .buttonStyle(.plain)
            }

            Text(buffer.description)
                .font(.regular10)
                .foregroundStyle(.gray2)
        }
        .modifier(FormCard())
    }
}


struct FormCard: ViewModifier {
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
                    .stroke(.gray1, lineWidth: 1)
            )
            .shadow(
                color: .black.opacity(0.05),
                radius: 4,
                x: 0,
                y: 2.069
            )
    }
}




//#Preview {
//    SetupView()
//}
