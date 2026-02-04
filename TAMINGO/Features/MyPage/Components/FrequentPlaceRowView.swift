//
//  FrequentPlaceRowView.swift
//  TAMINGO
//
//  Created by 권예원 on 2/4/26.
//

import SwiftUI

struct FrequentPlaceRowView: View {

    let place: PlaceUIModel
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack(alignment: .top) {

                VStack(alignment: .leading, spacing: 7) {

                    HStack(spacing: 6) {
                        Text(place.name)
                            .font(.medium14)
                            .foregroundStyle(.black00)
                        
                        if place.isAISuggested {
                            Text("AI 추론")
                                .font(.regular10)
                                .foregroundColor(.mainMint)
                                .padding(.horizontal, 9)
                                .padding(.vertical, 1.5)
                                .background(
                                    Capsule()
                                        .fill(.subMint)
                                )
                        }
                    }

                    HStack(spacing: 4) {
                        Image("MyPage_icon_spot")
                            .resizable()
                            .frame(width: 12, height: 12)

                        Text(place.address)
                            .font(.regular12)
                            .foregroundColor(.gray2)
                    }
                }

                Spacer()

                VStack(spacing: 14) {
                    Button(action: onEdit) {
                        Image("MyPage_icon_pencil")
                    }

                    Button(action: onDelete) {
                        Image(systemName: "MyPage_icon_trash")
                            .foregroundColor(.red)
                    }
                }
            }
            .frame(height: 40)

            Rectangle()
                .foregroundStyle(.gray0)
                .frame(height: 1)

            HStack(spacing:0) {
                Text("이번 주 방문")
                    .font(.regular12)
                    .foregroundColor(.gray2)

                Spacer()

                Text("\(place.weeklyVisitCount)회")
                    .font(.regular12)
                    .foregroundColor(.mainMint)
            }
        }
        .padding(16)
        .cardStyle()
    }
}


#Preview {
    VStack(spacing: 16) {
        FrequentPlaceRowView(
            place: PlaceUIModel(
                name: "집",
                address: "서울시 노원구 광운로 21",
                weeklyVisitCount: 6,
                isAISuggested: false
            ),
            onEdit: {},
            onDelete: {}
        )

        FrequentPlaceRowView(
            place: PlaceUIModel(
                name: "중앙도서관",
                address: "서울시 노원구 광운로 21",
                weeklyVisitCount: 12,
                isAISuggested: true
            ),
            onEdit: {},
            onDelete: {}
        )
    }
    .padding()
    .background(Color.gray0)
}
