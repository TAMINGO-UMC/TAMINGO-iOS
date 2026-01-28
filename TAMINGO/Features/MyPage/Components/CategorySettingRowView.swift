//
//  CategorySettingRowView.swift
//  TAMINGO
//
//  Created by 권예원 on 1/24/26.
//

import SwiftUI


struct CategorySettingRowView: View {
    let title: String
    let sub: String
    let textColor: Color
    let action:() -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(){
                VStack(alignment: .leading, spacing: 2.5){
                    Text(title)
                        .font(.medium14)
                        .foregroundStyle(.black)
                    Text(sub)
                        .font(.regular12)
                        .foregroundStyle(textColor)
                }
                Spacer(minLength: 8)
                Image(systemName: "chevron.right")
                    .resizable()
                    .frame(width: 5, height: 10)
                    .foregroundStyle(.gray2)
            }
        }
        .frame(height:61)
    }
}


#Preview {
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







