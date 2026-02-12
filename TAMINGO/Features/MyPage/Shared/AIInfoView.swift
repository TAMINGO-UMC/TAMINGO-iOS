//
//  AIInfoView.swift
//  TAMINGO
//
//  Created by 권예원 on 2/4/26.
//

import SwiftUI

struct AIInfoView: View {

    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 8) {
                Text("💡 AI 자동 분류")
                    .font(.regular12)
                    .foregroundStyle(.black00)

                Text("할일 입력 시 AI가 자동으로 이 카테고리들 중에서 \n가장 적합한 카테고리를 선택합니다")
                    .font(.regular12)
                    .foregroundColor(.gray2)
            }
            Spacer()
        }
        .padding(16)
        .frame(height: 90, alignment: .leading)
        .background(
            LinearGradient(
                stops: [
                Gradient.Stop(color: Color(red: 0.94, green: 0.96, blue: 1), location: 0.00),
                Gradient.Stop(color: Color(red: 0.98, green: 0.96, blue: 1), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0, y: 0),
                endPoint: UnitPoint(x: 1, y: 1)
            )
        )
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(.subBlue3, lineWidth: 1)
        )
    }
}


#Preview {
    AIInfoView()
}
