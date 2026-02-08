//
//  RecommendationOverlay.swift
//  TAMINGO
//
//  Created by 김도연 on 2/8/26.
//

import SwiftUI

// MARK: - Recommendation Overlay (AI 장소 추가 팝업)
struct RecommendationOverlay: View {
    let placeName: String
    @Binding var isAdded: Bool
    var onAddAction: () -> Void
    var onCancelAction: () -> Void
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 0) {
                if isAdded {
                    Text("\"\(placeName)\" 을(를) 추가했습니다!")
                        .font(.regular12)
                        .foregroundStyle(.white)
                    Text("설정에서 이름을 바꿀 수 있어요.")
                        .font(.regular12)
                        .foregroundStyle(.gray1)
                } else {
                    Text("'\(placeName)' 을(를) 자주 가시네요! \n자주가는 장소에 추가할까요 ?")
                        .font(.regular12)
                        .foregroundStyle(.white)
                }
            }
            
            Spacer()
            
            Button {
                if !isAdded {
                    withAnimation {
                        onAddAction()
                        isAdded = true
                    }
                } else {
                    withAnimation {
                        onCancelAction()
                        isAdded = false
                    }
                }
            } label: {
                Text(isAdded ? "취소하기" : "추가")
                    .font(.semiBold12)
                    .foregroundStyle(isAdded ? .gray2 : .white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(isAdded ? .white : .mainPink)
                    )
            }
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(0.8)))
        .padding(.horizontal, 20)
    }
}
