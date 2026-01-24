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
        ScrollView{
            VStack(alignment:.leading){
                Text("마이페이지")
                    .font(.semiBold18)
                profile
                CategorySection()
                SyncSection()
                PlaceTimeSection(vm:vm)
                NotificationSection()
                AppInfoSection()
            }
        }
        .padding(.horizontal, 30)
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
                Text("aaa@aaa.aaa")
                    .font(.regular12)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .frame(height: 96)
        .padding(16)
        
    }
}

struct CategorySection: View {
    var body: some View {
        SectionContainerView(title: "카테고리 설정"){
            VStack(spacing: 0) {
                CategorySettingRowView(
                    title: "일정 카테고리",
                    sub: .count(4)
                ) {
                    print("일정 카테고리 이동")
                }

                Divider()

                CategorySettingRowView(
                    title: "할일 카테고리",
                    sub: .count(6)
                ) {
                    print("일정 카테고리 이동")
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
                    sub: .status(3, .mainMint)
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
                    sub: .placeCount(4)
                ) {
                    print("자주 가는 장소 이동")
                }
            }
            
            Divider()
            
            VStack(spacing: 0) {
                CategorySettingRowView(
                    title: "활동 시간 설정",
                    sub: .timeRange(vm.activityTimeText)
                ) {
                    print("활동 시간 설정 이동")
                }
            }
            
            Divider()
            
            CategorySettingRowView(
                title: "이동수단 설정",
                sub: .summary(["버스","지하철","도보"])
            ) {
                print("이동수단 설정 이동")
            }
        }
    }
}

struct NotificationSection: View {
    var body: some View {
        SectionContainerView(title: "알림 & 데이터"){
            VStack(spacing: 0) {
                CategorySettingRowView(
                    title: "알림 설정",
                    sub: .comment("출발 알림 켜짐", .mainMint)
                ) {
                    print("알림 설정 이동")
                }
            }
            
            Divider()
            
            VStack(spacing: 0) {
                CategorySettingRowView(
                    title: "개인화 학습 데이터",
                    sub: .comment("오차 로그 수집 중", .gray2)
                ) {
                    print("개인화 학습 데이터 이동")
                }
            }
        
        }
    }
}

struct AppInfoSection: View {
    var body: some View {
        SectionContainerView(title: "앱 정보"){
            VStack(spacing: 0) {
                CategorySettingRowView(
                    title: "설정",
                    sub: .comment("앱 설정 및 정보", .gray2)
                ) {
                    print("설정 이동")
                }
            }
        }
    }
}



#Preview {
    MyPageView()
}
