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

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                TimeSectionView(
                    startTime: $vm.startTime,
                    endTime: $vm.endTime
                )

                PlacesSectionView(
                    searchPlace: $vm.searchAddress,
                    placeName: $vm.placeName
                )

                TrafficSectionView(vm: $vm)
                TrafficTimeSectionView(buffer: $vm.arrivalBuffer)
            }
            .padding(.vertical,10)
            .padding(.horizontal, 30)
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

    var body: some View {
        VStack(spacing: 12) {
            TimeRow(
                title: "주요 활동 시작 시각",
                date: $startTime
            )

            TimeRow(
                title: "주요 활동 종료 시각",
                date: $endTime
            )
        }
    }
}

struct TimeRow: View {
    let title: String
    @Binding var date: Date

    var body: some View {
        HStack {
            Text(title)
                .font(.semiBold16)
            Spacer()
            CapsuleTimePicker(date: $date)
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
    
    var body: some View {
        VStack{
            HStack {
                Text("선호하는 교통 수단")
                    .font(.semiBold16)
                Spacer()
            }
            .padding(.bottom, 15)
            HStack(spacing: 15) {
                ForEach(TransportType.allCases) { type in
                    TransportButton(
                        type: type,
                        priority: vm.priority(of: type),
                        isSelected: vm.isSelected(type),
                        backgroundOpacity: vm.backgroundOpacity(for: type),
                        onTap: {
                            vm.toggle(type)
                        }
                    )
                }
            }
        }
        .modifier(FormCard())
    }
}




struct TrafficTimeSectionView: View {
    @Binding var buffer: ArrivalBufferType

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            HStack {
                Text("선호하는 이동 수단")
                    .font(.semiBold16)

                Spacer()

                Button {
                    // TODO: picker / popover 연결
                } label: {
                    HStack(spacing: 4) {
                        Text(buffer.title)
                            .font(.medium13)
                            .foregroundStyle(.mainPink)

                        VStack(spacing:2.5){
                            Image(systemName: "chevron.up")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 10)
                                .foregroundStyle(.mainPink)
                            Image(systemName: "chevron.down")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 10)
                                .foregroundStyle(.mainPink)
                        }
                    }
                }
                .buttonStyle(.plain)
            }

            Text(buffer.description)
                .font(.regular12) // TODO: regular10 변경 필요
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
