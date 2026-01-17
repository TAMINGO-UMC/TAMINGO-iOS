//
//  IntroPageView.swift
//  TAMINGO
//
//  Created by 권예원 on 1/16/26.
//

import SwiftUI

struct IntroOverViewSection: View {
    var body: some View {
        VStack{
            Image(.onBoardingOverView)
                .resizable()
                .frame(width: 269, height: 179)
            
            featureCards
        }
    }
    
    var featureCards: some View {
        VStack(spacing:14.41){
            FeatureCard(icon: Image("OnBoarding_icon_cal"), title: "하루 일과 보드 제공", text: "일정, To-do, 이동 시간이 모두 정리된 '오늘의 일과 보드'를 제공해요", highlights: ["'오늘의 일과 보드'"])
            
            FeatureCard(icon: Image("OnBoarding_icon_noti"), title: "지각 없는 모닝 브리핑", text: "매일 아침, 오늘 하루 스케줄을 미리 확인하고 놓칠 일을 점검해 드려요", highlights: ["오늘 하루 스케줄을 미리 확인"])
            
            FeatureCard(icon: Image("OnBoarding_icon_time"), title: "정시 도착 보장", text: "실시간 교통을 역산하여 지각 없는 최적의 출발 시각을 알려드려요", highlights: ["실시간 교통을 역산"])
        }
        .shadow(
            color: .black.opacity(0.05),
            radius: 4,
            x: 0,
            y: 2.069
        )
    }
    
}

struct IntroFlowSection: View {
    var body: some View {
        VStack(spacing:10){
            Image("OnBoarding_flow")
                .resizable()
                .frame(width: 287, height: 207)
            featureCards
        }
    }
    
    var featureCards: some View {
        VStack(spacing:14.41){
            FeatureCard(icon: Image("OnBoarding_icon_earth"), title: "이동경로에 경유지 통합", text: "다음 일정으로 가는 길에 위치한 책 반납하기 등 장소 기반 To-do를\n자동으로 포함하여 가장 효율적인 동선을 설계해요", highlights: ["다음 일정으로 가는 길","장소 기반 To-do를\n자동으로 포함하여"])
            
            FeatureCard(icon: Image("OnBoarding_icon_todo"), title: "이동 중 비실행 To-do 처리", text: "대중교통 이용 시간 등 이동 중에 발생하는 틈새 시간을 활용하여\n회의록 확인 등 장소 무관 To-do를 처리하도록 제안해요", highlights: ["틈새 시간을 활용","장소 무관 To-do를 처리하도록 제안"])
        }
        .shadow(
            color: .black.opacity(0.05),
            radius: 4,
            x: 0,
            y: 2.069
        )
    }
}

struct IntroCalenderSection: View {
    @Binding var vm : OnboardingViewModel
    
    var body: some View {
        VStack() {
            images
            Spacer(minLength: 0)
            appleCalButton
        }
        .padding(.bottom, 31)
    }

    var images: some View {
        ZStack {
            Image("OnBoarding_calBack")
                .scaleEffect(0.96)
                .offset(x: 35, y: -105)

            Image("OnBoarding_calFront")
                .scaleEffect(0.96)
                .offset(x: 0, y: 35)

            Image("OnBoarding_calLogo")
                .scaleEffect(0.96)
                .offset(x: -70, y: 100)
        }
        .frame(height: 400)
        .clipped()
    }

    var appleCalButton: some View {
        Button {
            vm.didConnectCalendar = true
            // TODO: 애플캘린더 연동 구현
        } label: {
            Text("apple 캘린더 연동하기")
                .font(.semiBold14)
                .foregroundStyle(.mainPink)
                .frame(width: 272, height: 47)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.subPink)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.mainPink, lineWidth: 1)
                        )
                )
        }
    }
}




struct IntroPermissionSection: View {
    @Binding var vm : OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            images
                .frame(height: 170)

            features
                .padding(.top, 15)
                .padding(.bottom, 27.91)

            permissionButton
        }
        .padding(.bottom, 31)
    }


    var images: some View {
        ZStack {
            Image("OnBoarding_permission02")
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .offset(x: 0, y: 0)

            Image("OnBoarding_permission01")
                .offset(x: 65, y: -20)
        }
        .frame(maxWidth: .infinity)
    }


    var features: some View {
        VStack(spacing: 14) {
            FeatureCard(
                icon: Image("OnBoarding_icon_pick"),
                title: "위치권한 : 정시 도착의 책임감을 위해",
                text: "지금 어디 계시는지 알아야 출발 시간 역산과\n경로상의 To-do를 정확히 추천해 드릴 수 있어요",
                highlights: []
            )

            FeatureCard(
                icon: Image("OnBoarding_icon_noti02"),
                title: "알림권한 : 중요한 순간을 절대 놓치지 않도록",
                text: "실시간 잔여 시각이나 출발 알림을 지연 없이 바로 전달할게요",
                highlights: []
            )
        }
    }


    var permissionButton: some View {
        Button {
            vm.didGrantPermission = true
            // TODO: 약관 동의 연동 구현
        } label: {
            Text("위치 및 알림 권한 허용하기")
                .font(.semiBold14)
                .foregroundStyle(.mainPink)
                .frame(width: 272, height: 47)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.subPink)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.mainPink, lineWidth: 1)
                        )
                )
        }
    }
}

struct Border: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray1, lineWidth: 1)
            )
    }
}

//#Preview {
//    IntroPermissionSection()
//}
