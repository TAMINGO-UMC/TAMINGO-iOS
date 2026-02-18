//
//  PersonalizationView.swift
//  TAMINGO
//
//  Created by 김도연 on 2/9/26.
//

import SwiftUI

struct PersonalizationView: View {
    @State private var viewModel = PersonalizationViewModel()
    @State private var showResetAlert = false
    
    var body: some View {
        VStack(alignment: .leading) {
            MyPageHeader(title: "개인화 학습")
                .padding([.horizontal, .top])
            ScrollView {
                VStack(alignment: .leading) {
                    ToggleBox(
                        title: "사용자 행동 수집",
                        sub: "사용자의 행동을 학습하여\n 더 정확한 예측을 제공합니다",
                        isOn: $viewModel.personalizationSetting
                    )
                    .padding()
                    .cardStyle()
                    
                    if viewModel.personalizationSetting {
                        Text("학습 통계")
                            .font(.regular12)
                            .foregroundStyle(.gray2)
                            .padding(.top)
                        
                        StaticBox(
                            image: "MyPage_icon_report03",
                            color: .subBlue2,
                            title: "학습된 패턴",
                            sub: "이동 경로 및 시간 패턴",
                            stat: "\(viewModel.patternCount)개"
                        )
                        StaticBox(
                            image: "MyPage_icon_report04",
                            color: .subPP2,
                            title: "평균 정확도",
                            sub: "예측 시간 정확도",
                            stat: "\(viewModel.avgAccuracy)%"
                        )
                        StaticBox(
                            image: "MyPage_icon_spot",
                            color: .mainPink,
                            title: "자주 가는 장소",
                            sub: "AI가 학습한 장소",
                            stat: "\(viewModel.fvpCount)곳"
                        )
                        
                        SectionContainerView(title: "최근 학습 내역") {
                            if viewModel.recentPersonalized.isEmpty {
                                Text("아직 학습 내역이 없어요")
                                    .font(.regular12)
                                    .foregroundStyle(.gray2)
                                    .padding(.top)
                            } else {
                                ForEach(viewModel.recentPersonalized, id: \.self) { item in
                                    RecentPersonalizationView(
                                        startPlace: item.startPlace,
                                        arrivePlace: item.arrivePlace,
                                        expectedDuration: item.expectedDuration,
                                        actualDuration: item.actualDuration,
                                        errorMin: item.errorMin
                                    )
                                    Divider()
                                }
                            }
                        }
                    }
                    
                    dataManageButton
                    
                    GuideBoxView(title: "학습 데이터 안내", description: "• 이동 패턴이 학습되어 더 정확한 예측이 가능합니다\n• 사용자 수정 내역도 자동으로 학습됩니다\n• 모든 데이터는 기기 내에 안전하게 저장됩니다")
                        .padding(.bottom, 80)
                }
                .padding()
            }
        }
        .task {
            async let _ = viewModel.loadSetting()
            async let _ = viewModel.loadStatistics()
            async let _ = viewModel.loadRecent()
        }
        .onChange(of: viewModel.personalizationSetting) { _, newValue in
            Task {
                await viewModel.updateSetting()
            }
        }
        .alert("개인화 데이터를 리셋하시겠습니까?", isPresented: $showResetAlert) {
            Button("취소", role: .cancel) { }
            Button("리셋", role: .destructive) {
                Task { await viewModel.resetData() }
            }
        } message: {
            Text("리셋된 데이터는 복구할 수 없습니다.")
        }
    }
    
    var dataManageButton: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("데이터 관리")
                .font(.regular12)
                .foregroundStyle(.gray2)
            
            Button {
                showResetAlert = true
            } label: {
                Text("개인화 학습 데이터 리셋")
                    .font(.medium12)
                    .foregroundStyle(.mainPink)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.subPink)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(.mainPink, lineWidth: 1)
                            )
                    )
            }
        }
        .padding()
        .cardStyle()
    }
}

struct StaticBox: View {
    let image: String
    let color: Color
    let title: String
    let sub: String
    let stat: String
    
    var body: some View {
        HStack(spacing: 20) {
            Image(image)
                .renderingMode(.template)
                .resizable()
                .foregroundStyle(color)
                .frame(width: 20, height: 20)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.gray0)
                        .frame(width: 40, height: 40)
                )
            VStack(alignment: .leading) {
                Text(title)
                    .font(.regular12)
                Text(sub)
                    .font(.regular12)
                    .foregroundStyle(.gray2)
            }
            Spacer()
            Text(stat)
                .font(.semiBold18)
                .foregroundStyle(.mainMint)
        }
        .padding()
        .cardStyle()
    }
}

struct RecentPersonalizationView: View {
    let startPlace: String
    let arrivePlace: String
    let expectedDuration: Int
    let actualDuration: Int
    let errorMin: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(startPlace) → \(arrivePlace)")
                    .font(.regular12)
                Text("\(expectedDuration)분 → \(actualDuration)분")
                    .font(.regular12)
                    .foregroundStyle(.gray2)
            }
            Spacer()
            Text("\(errorMin)분 오차 학습")
                .font(.regular12)
                .foregroundStyle(.mainMint)
        }
        .padding()
    }
}

#Preview {
    PersonalizationView()
}
