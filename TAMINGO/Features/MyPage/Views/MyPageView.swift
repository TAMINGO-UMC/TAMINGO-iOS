//
//  MyPageView.swift
//  TAMINGO
//
//  Created by 권예원 on 1/24/26.
//

import SwiftUI

struct MyPageView: View {
    let onSelect: (MyPageRoute) -> Void
    @State var vm: MyPageViewModel
    
    var body: some View {
        ScrollView{
            VStack(alignment:.leading){
                Text("마이페이지")
                    .font(.semiBold18)
                profile
                WeeklyReportSection(
                    metrics: weeklyMetricMocks,
                    onTap: {
                        onSelect(.weeklyReport)
                    }
                )
                CategorySection(onTapSchedule: {
                    onSelect(.scheduleCategory)
                }, onTapTodo: {
                    onSelect(.todoCategory)
                })
                SyncSection(onTap: {
                    onSelect(.calendarSetting)
                })
                PlaceTimeSection(vm:vm, onTapPlace: {
                    onSelect(.favoritePlace)
                }, onTapTime: {
                    onSelect(.activityTime)
                }, onTapTransport: {
                    onSelect(.transport)
                })
                NotificationSection(vm:vm, onTapNotification: {
                    onSelect(.notification)
                }, onTapErrorLog: {
                    onSelect(.personalization)
                })
                AppInfoSection(onTap:{
                    onSelect(.setting)
                })
            }
            .padding(.horizontal, 30)
        }
        .scrollIndicators(.hidden)
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
    let onTap: () -> Void

    var body: some View {
        Button(action:{
            onTap()
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
    let onTapSchedule: () -> Void
    let onTapTodo: () -> Void

    var body: some View {
        SectionContainerView(title: "카테고리 설정"){
            VStack(spacing: 0) {
                CategorySettingRowView(
                    title: "일정 카테고리",
                    sub: "4개",
                    textColor: .gray2
                ) {
                    onTapSchedule()
                }

                Divider()

                CategorySettingRowView(
                    title: "할일 카테고리",
                    sub: "6개",
                    textColor: .gray2
                ) {
                    onTapTodo()
                }

            }
        }
    }
}

struct SyncSection: View {
    let onTap: () -> Void
    
    var body: some View {
        SectionContainerView(title: "연동 & 동기화"){
            VStack(spacing: 0) {
                CategorySettingRowView(
                    title: "캘린더 연동",
                    sub: "연동되지 않음",
                    textColor: .gray2
                ) {
                    onTap()
                }

            }
        }
    }
}

struct PlaceTimeSection: View {
    let vm: MyPageViewModel
    let onTapPlace: () -> Void
    let onTapTime: () -> Void
    let onTapTransport: () -> Void
    
    
    var body: some View {
        SectionContainerView(title: "장소 & 시간 설정"){
            VStack(spacing: 0) {
                CategorySettingRowView(
                    title: "자주 가는 장소",
                    sub: vm.favoritePlacesText,
                    textColor: .gray2
                ) {
                    onTapPlace()
                }
            }
            
            Divider()
            
            VStack(spacing: 0) {
                CategorySettingRowView(
                    title: "활동 시간 설정",
                    sub: vm.activityTimeText,
                    textColor: .gray2
                ) {
                    onTapTime()
                }
            }
            
            Divider()
            
            CategorySettingRowView(
                title: "이동수단 설정",
                sub: "버스 > 지하철 > 도보",
                textColor: .gray2
            ) {
                onTapTransport()
            }
        }
    }
}

struct NotificationSection: View {
    let vm: MyPageViewModel
    let onTapNotification: () -> Void
    let onTapErrorLog: () -> Void
    
    var body: some View {
        SectionContainerView(title: "알림 & 데이터"){
            VStack(spacing: 0) {
                CategorySettingRowView(
                    title: "알림 설정",
                    sub: vm.notificationStatusText, textColor: .mainMint
                ) {
                    onTapNotification()
                }
            }
            
            Divider()
            
            VStack(spacing: 0) {
                CategorySettingRowView(
                    title: "개인화 학습 데이터",
                    sub: vm.errorLogSettingText,
                    textColor: .gray2
                ) {
                    onTapErrorLog()
                }
            }
        
        }
    }
}

struct AppInfoSection: View {
    let onTap: () -> Void
    
    var body: some View {
        SectionContainerView(title: "앱 정보"){
            VStack(spacing: 0) {
                CategorySettingRowView(
                    title: "설정",
                    sub: "앱 설정 및 정보",
                    textColor: .gray2
                ) {
                    onTap()
                }
            }
        }
    }
}



#Preview {
    MyPageView(onSelect: {_ in print("myPageView")}, vm: MyPageViewModel())
}
