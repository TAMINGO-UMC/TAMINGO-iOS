//
//  SettingsView.swift
//  TAMINGO
//
//  Created by 김도연 on 2/10/26.
//

import SwiftUI

struct SettingsView: View {
    @State private var viewModel = SettingsViewModel()
    
    // 팝업 표시 여부를 제어하는 상태 변수 추가
    @State private var showLogoutAlert = false
    @State private var showWithdrawAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            MyPageHeader(title: "설정")
                .padding(.horizontal, 32)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 12){
                    // 앱 정보
                    SectionContainerView(title: "앱 정보") {
                        SettingCard(title: "버전 정보", sub: viewModel.appVersion) {
                            print("버전 정보 탭")
                        }
                        SettingCard(title: "업데이트 확인", sub: "최신 버전", subColor: .mainMint) {
                            print("업데이트 확인 탭")
                        }
                        SettingCard(title: "오픈소스 라이선스") {
                            print("오픈소스 라이선스 탭")
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    // 계정
                    SectionContainerView(title: "계정") {
                        SettingCard(title: "로그아웃") {
                            showLogoutAlert = true
                        }
                        SettingCard(title: "회원 탈퇴", isRed: true) {
                            showWithdrawAlert = true
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    // 약관 및 정책
                    SectionContainerView(title: "약관 및 정책") {
                        SettingCard(title: "서비스 이용약관") {
                            print("서비스 이용약관 탭")
                        }
                        SettingCard(title: "개인정보 처리방침") {
                            print("개인정보 처리방침 탭")
                        }
                        SettingCard(title: "위치 정보 이용약관") {
                            print("위치 정보 이용약관 탭")
                        }
                    }
                    .padding(.horizontal, 32)
                        
                    // 고객센터
                    SectionContainerView(title: "고객센터") {
                        SettingCard(title: "의견 보내기") {
                            print("의견 보내기 탭")
                        }
                    }
                    .padding(.bottom, 80)
                    .padding(.horizontal, 32)
                }
            }
        }
        .padding(.vertical, 16)
        .task {
            viewModel.loadAppVersion()
        }
        // 로그아웃 알림
        .alert("로그아웃 하시겠습니까?", isPresented: $showLogoutAlert) {
            Button("취소", role: .cancel) { }
            Button("로그아웃", role: .destructive) {
                viewModel.logout() // 실제 로그아웃 로직 실행
            }
        } message: {
            Text("로그인 화면으로 이동합니다.")
        }
        // 회원탈퇴 알림
        .alert("정말 탈퇴하시겠습니까?", isPresented: $showWithdrawAlert) {
            Button("취소", role: .cancel) { }
            Button("탈퇴", role: .destructive) { // 빨간색 버튼으로 표시됨
                viewModel.withdraw() // 실제 탈퇴 로직 실행
            }
        } message: {
            Text("탈퇴 시 계정 정보는 복구할 수 없습니다.")
        }
        
    }
}

struct SettingCard: View {
    let title: String
    var isRed: Bool = false
    var sub: String = ""
    var subColor: Color = .gray2
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(title)
                    .font(.medium14)
                    .foregroundStyle(isRed ? .red : .black)
                
                Spacer()
                
                Text(sub)
                    .font(.regular12)
                    .foregroundStyle(subColor)
                
                Image(systemName: "chevron.right")
                    .resizable()
                    .frame(width: 6, height: 8)
                    .foregroundStyle(.gray2)
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    SettingsView()
}
