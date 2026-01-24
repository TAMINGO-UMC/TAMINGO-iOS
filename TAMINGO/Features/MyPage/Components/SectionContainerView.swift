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
        .padding(.bottom, 8)
        .cardStyle()
    }
    
}

#Preview {
    SectionContainerView(title: "카테고리 설정") {
        VStack(spacing: 0) {
            CategorySettingRowView(
                title: "일정 카테고리",
                sub: .count(4)
            ) {
                print("일정 카테고리 탭")
            }

            Divider()

            CategorySettingRowView(
                title: "캘린더 연동",
                sub: .status(3, .mint)
            ) {
                print("캘린더 연동 탭")
            }

            Divider()

            CategorySettingRowView(
                title: "활동 시간 설정",
                sub: .timeRange("09:00 - 22:00")
            ) {
                print("활동 시간 설정 탭")
            }

            Divider()

            CategorySettingRowView(
                title: "이동수단 설정",
                sub: .summary(["버스","지하철","도보"])
            ) {
                print("이동수단 설정 탭")
            }
        }
    }
}
