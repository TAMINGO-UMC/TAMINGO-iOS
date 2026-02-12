//
//  GuideBoxView.swift
//  TAMINGO
//
//  Created by 권예원 on 2/4/26.
//

import SwiftUI

struct GuideBoxView: View {

    let title: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            Text("💡 \(title)")
                .font(.regular12)
                .foregroundStyle(.black00)

            Text(description)
                .font(.regular12)
                .kerning(0.5)
                .foregroundColor(.gray2)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(.gray0)
        .cornerRadius(14)
    }
}


#Preview {
    GuideBoxView(
        title: "동기화 안내",
        description: """
    • 양방향 동기화: 타밍고와 외부 캘린더 간 실시간 동기화
    • 일정 생성, 수정, 삭제가 자동으로 반영됩니다
    • 캘린더별로 동기화 방향을 개별 설정할 수 있습니다
    """
    )
}
