//
//  MyPageView.swift
//  TAMINGO
//
//  Created by 권예원 on 1/24/26.
//

import SwiftUI

struct MyPageView: View {
    
    @State private var vm: MyPageViewModel = MyPageViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack(alignment:.leading){
                    Text("마이페이지")
                        .font(.semiBold18)
                    profile
                    WeeklyReportSection(metrics: weeklyMetricMocks)
                    CategorySection()
                    SyncSection()
                    PlaceTimeSection(vm:vm)
                    NotificationSection(vm:vm)
                    AppInfoSection()
                }
                .padding(.horizontal, 30)
            }
        }
    }
    
    var profile: some View {
        HStack(spacing: 12){
            Image("person")
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipShape(Circle())
            
            VStack(alignment:.leading, spacing: 4){
                Text("사용자님")
                    .font(.medium14)
                    .foregroundStyle(.black00)
                Text(verbatim: "aaa@aaa.aaa")
                    .font(.regular12)
                    .foregroundColor(.gray2)
                    
            }
            Spacer()
        }
        .frame(height: 96)
        .padding(16)
        
    }
}

struct WeeklyReportSection: View {
    let metrics: [WeeklyMetric]

    var body: some View {
        Button(action:{
            print("주간 리포트 이동") // TODO: 주간리포트 페이지 연결
        }, label:{
            VStack(alignment: .leading, spacing: 12) {
                header

                HStack {
                    ForEach(Array(metrics.enumerated()), id: \.element.id) { index, metric in
                        MainWeeklyMetricItemView(metric: metric)

                        if index != metrics.count - 1 {
                            Spacer()
                        }
                    }
                }

            }
            .padding(16)
            .cardStyle()
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.mainMint, lineWidth: 1)
            )
        })
    }
    
    var header: some View {
        HStack{
            Image("MyPage_graph")
                .resizable()
                .scaledToFit()
                .frame(width: 16)
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray1, lineWidth: 1)
                )

            
            Text("주간 리포트")
                .font(.medium14)
                .foregroundStyle(.black00)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .resizable()
                .frame(width: 5, height: 10)
                .foregroundStyle(.black00)
        }

    }
}

struct CategorySection: View {
    var body: some View {
        SectionContainerView(title: "카테고리 설정"){
            VStack(spacing: 0) {
                CategorySettingRowView(
                    title: "일정 카테고리",
                    sub: "4개",
                    textColor: .gray2
                ) {
                    print("일정 카테고리 이동")
                }

                Divider()

                CategorySettingRowView(
                    title: "할일 카테고리",
                    sub: "6개",
                    textColor: .gray2
                ) {
                    print("할일 카테고리 이동")
                }

            }
        }
    }
}

struct SyncSection: View {
    var body: some View {
        SectionContainerView(title: "연동 & 동기화"){
            VStack(spacing: 0) {
                CategorySettingRowView(
                    title: "캘린더 연동",
                    sub: "연동되지 않음",
                    textColor: .gray2
                ) {
                    print("캘린더 연동 이동")
                }

            }
        }
    }
}

struct PlaceTimeSection: View {
    let vm: MyPageViewModel
    var body: some View {
        SectionContainerView(title: "장소 & 시간 설정"){
            VStack(spacing: 0) {
                CategorySettingRowView(
                    title: "자주 가는 장소",
                    sub: vm.favoritePlacesText,
                    textColor: .gray2
                ) {
                    print("자주 가는 장소 이동")
                }
            }
            
            Divider()
            
            VStack(spacing: 0) {
                CategorySettingRowView(
                    title: "활동 시간 설정",
                    sub: vm.activityTimeText,
                    textColor: .gray2
                ) {
                    print("활동 시간 설정 이동")
                }
            }
            
            Divider()
            
            CategorySettingRowView(
                title: "이동수단 설정",
                sub: "버스 > 지하철 > 도보",
                textColor: .gray2
            ) {
                print("이동수단 설정 이동")
            }
        }
    }
}

struct NotificationSection: View {
    let vm: MyPageViewModel
    var body: some View {
        SectionContainerView(title: "알림 & 데이터"){
            NavigationLink {
                NotificationView()
                    .navigationBarBackButtonHidden(true)
            } label: {
                CategorySettingRowView(
                    title: "알림 설정",
                    sub: vm.notificationStatusText, textColor: .mainMint
                ) {
                    print("알림 설정 이동")
                }
                .disabled(true)
            }
            
            Divider()
            
            NavigationLink {
                PersonalizationView()
                    .navigationBarBackButtonHidden(true)
            } label: {
                CategorySettingRowView(
                    title: "개인화 학습 데이터",
                    sub: vm.errorLogSettingText,
                    textColor: .gray2
                ) {
                    print("개인화 학습 데이터 이동")
                }
                .disabled(true)
            }
        }
    }
}

struct AppInfoSection: View {
    var body: some View {
        NavigationLink {
            SettingsView()
                .navigationBarBackButtonHidden(true)
        } label: {
            SectionContainerView(title: "앱 정보"){
                CategorySettingRowView(
                    title: "설정",
                    sub: "앱 설정 및 정보",
                    textColor: .gray2
                ) {
                    print("설정 이동")
                }
                .disabled(true)
            }
            .padding(.bottom, 80)
        }
    }
}



#Preview {
    MyPageView()
}
