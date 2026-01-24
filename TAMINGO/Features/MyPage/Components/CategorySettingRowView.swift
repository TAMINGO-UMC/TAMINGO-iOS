//
//  CategorySettingRowView.swift
//  TAMINGO
//
//  Created by 권예원 on 1/24/26.
//

import SwiftUI


struct CategorySettingRowView: View {
    let title: String
    let sub: RowSubContent
    let action:() -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(){
                VStack(alignment: .leading, spacing: 2.5){
                    Text(title)
                        .font(.medium14)
                        .foregroundStyle(.black)
                    subView
                }
                Spacer()
                Image("icon_rChevron")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
        }
        .frame(width: .infinity)
        .frame(height:61)
    }
}

private extension CategorySettingRowView {

    @ViewBuilder
    var subView: some View {
        switch sub {
        case .count(let value):
            Text("\(value)개")
                .font(.regular12)
                .foregroundColor(.gray2)

        case .status(let value, let color):
            Text("\(value)개 연동됨")
                .font(.regular12)
                .foregroundColor(color)

        case .timeRange(let range):
            Text(range)
                .font(.regular12)
                .foregroundColor(.gray2)

        case .summary(let transports):
            Text(transports.joined(separator: " > ") + " 선호")
                .font(.caption)
                .foregroundColor(.gray2)
        case .placeCount(let count):
            Text("\(count)개 등록됨")
                .font(.regular12)
                .foregroundColor(.gray2)
        case .comment(let comment, let color):
            Text(comment)
                .font(.regular12)
                .foregroundColor(color)
        }
    }
}


#Preview {
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







