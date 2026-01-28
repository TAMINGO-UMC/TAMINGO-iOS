//
//  GapTimeCardView.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/27/26.
//

import SwiftUI

struct GapTimeCardView: View {

    let gapTime: GapTime
    let onAssignTap: () -> Void
    let onLaterTap: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 17) {

            // 시간
            Text(gapTime.time)
                .font(.medium14)
                .foregroundStyle(Color("Black00"))
                .frame(alignment: .leading)

            // 카드
            VStack(alignment: .leading, spacing: 8) {

                // 상단 텍스트 영역
                VStack(alignment: .leading, spacing: 6) {

                    HStack(spacing: 6) {
                        Text(gapTime.title)
                            .font(.medium14)
                            .foregroundStyle(Color("Black00"))

                        Text("틈새 시간")
                            .font(.regular12)
                            .foregroundStyle(Color("SubYellow2"))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background{
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color("SubYellow"))
                            }
                    }

                    Text(gapTime.location)
                        .font(.regular12)
                        .foregroundStyle(Color("Gray2"))

                    Text(gapTime.availableText)
                        .font(.regular10)
                        .foregroundStyle(Color("SubYellow2"))
                }

                // 버튼 영역 (오른쪽 하단)
                HStack {
                    Spacer()

                    HStack(spacing: 12) {
                        Button("편성") {
                            onAssignTap()
                        }
                        .buttonStyle(GapPrimaryButtonStyle())

                        Button("나중에") {
                            onLaterTap()
                        }
                        .buttonStyle(GapSecondaryButtonStyle())
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.white)
            )
            .overlay{
                RoundedRectangle(cornerRadius: 5)
                    .stroke(
                        Color("SubYellow4"),
                        style: StrokeStyle(lineWidth: 1, dash: [4])
                    )
            }
            .shadow(
                color: Color.black.opacity(0.06),
                radius: 6.89,
                x: 0,
                y: 2.297
            )
        }
    }
}

private struct GapPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.regular12)
            .foregroundStyle(Color("Black00"))
            .padding(.horizontal, 9)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color("SubYellow"))
            )
            .overlay{
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color("SubYellow2"), lineWidth: 1)
            }
            .opacity(configuration.isPressed ? 0.85 : 1)
    }
}

private struct GapSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.regular12)
            .foregroundStyle(Color("Gray2"))
            .padding(.horizontal, 9)
            .padding(.vertical, 4)
            .background{
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.white)
            }
            .overlay{
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color("Gray1"), lineWidth: 1)
            }
            .opacity(configuration.isPressed ? 0.85 : 1)
    }
}

#Preview {
    GapTimeCardView(
        gapTime: GapTime(
            time: "12:30",
            title: "도서 반납",
            location: "도서관 · 5–7분",
            availableText: "12:10–12:30 공강에 처리 가능"
        ),
        onAssignTap: {},
        onLaterTap: {}
    )
    .padding()
}
