//
//  SectionContainerView.swift
//  TAMINGO
//
//  Created by 권예원 on 1/24/26.
//

import SwiftUI

struct SectionContainerView<Content: View>: View  {
    let title:String
    let contents:Content
    
    init(
        title:String,
        @ViewBuilder contents: () -> Content
    ){
        self.title = title
        self.contents = contents()
    }
    
    var body: some View {
        VStack(spacing:0){
            HStack{
                Text(title)
                    .font(.medium12)
                    .foregroundStyle(.gray2)
                Spacer()
            }
            .padding(.bottom, 10)
            
            Divider()
            
            contents
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 8)
        .cardStyle()
    }
    
}

#Preview {
    SectionContainerView(title: "카테고리 설정") {
        VStack(spacing: 0) {
            CategorySettingRowView(
                title: "일정 카테고리",
                sub: "4개", textColor: .gray2
            ) {
                print("일정 카테고리 탭")
            }

            Divider()

            CategorySettingRowView(
                title: "캘린더 연동",
                sub: "3개 연동됨",
                textColor: .mainMint
            ) {
                print("캘린더 연동 탭")
            }

            Divider()

            CategorySettingRowView(
                title: "활동 시간 설정",
                sub: "매일 6:00 ~ 22:00",
                textColor: .gray2
            ) {
                print("활동 시간 설정 탭")
            }
        }
    }
}
