//
//  TransportRankSettingView.swift
//  TAMINGO
//
//  Created by 권예원 on 2/7/26.
//

import SwiftUI

struct TransportRankSettingView: View {

    @State private var vm = TransportRankSettingViewModel()
    @State private var activePicker: SetUpActivePicker?
    
    @State private var labelFrames: [Int: CGRect] = [:]
    let onBack: () -> Void

    var body: some View {
        ZStack(alignment: .topLeading) {

            VStack(alignment: .leading, spacing: 0) {
                header

                VStack(spacing: 12) {
                    TrafficSection(
                        vm: vm,
                        activePicker: $activePicker,
                        labelFrames: $labelFrames
                    )

                    GuideBoxView(
                        title: "목표 도착시간 & 이동수단 설정 안내",
                        description: """
• 선호 순위가 높은 이동수단을 우선 추천합니다
• 실시간 교통 상황에 따라 다른 경로를 제안할 수 있습니다
"""
                    )
                }
                .padding(16)

                Spacer()
            }
            .padding(.horizontal, 16)
            
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
                        set: {
                            vm.updateTransport($0, for: rank)
                            activePicker = nil
                        }
                    ),
                    isDisabled: { type in
                        vm.isTransportSelected(type, excluding: rank)
                    }
                )
                .position(
                    x: frame.midX,
                    y: frame.maxY + 45
                )
                .zIndex(100)
            }
        }
        .coordinateSpace(name: "TransportRankSpace")
        .navigationBarBackButtonHidden(true)

    }
    var header: some View {
        HStack(spacing: 14){
            Button(action: {
                onBack()
            }, label: {
                Image("Previous_Chevron")
                    .resizable()
                    .frame(width: 5, height: 10)
            })
            
            Text("이동 수단 설정")
                .font(.semiBold16)
                .foregroundStyle(.black00)
        }
        .padding(16)
    }
}


struct TrafficSection: View {

    let vm: TransportRankSettingViewModel
    @Binding var activePicker: SetUpActivePicker?

    @Binding var labelFrames: [Int: CGRect]

    var body: some View {
        VStack {
            HStack {
                Text("선호하는 이동 수단")
                    .font(.medium12)
                    .foregroundStyle(.gray2)
                Spacer()
            }
            .padding(.bottom, 15)

            HStack(spacing: 18) {
                ForEach(1...3, id: \.self) { rank in
                    let transport = vm.transport(for: rank)

                    RankLabel(
                        rank: rank,
                        title: transport?.title ?? "Label"
                    ) {
                        activePicker = .transport(rank: rank)
                    }
                    .frame(maxWidth: .infinity)
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    labelFrames[rank] =
                                        geo.frame(in: .named("TransportRankSpace"))
                                }
                        }
                    )
                }
            }
        }
        .padding(16)
        .cardStyle()
    }
}


#Preview {
    TransportRankSettingView(onBack: {
        print("back")
    })
}
