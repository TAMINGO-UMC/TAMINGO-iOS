//
//  TimelineVerticalLineView.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/8/26.
//

import SwiftUI

struct TimelineVerticalLineView: View {

    let node: NodeStyle
    let above: LineStyle
    let below: LineStyle

    private let lineWidth: CGFloat = 6
    private let nodeSize: CGFloat = 22
    private let colWidth: CGFloat = 34

    var body: some View {
        VStack(spacing: 0) {

            // 위 라인
            lineView(style: above)
                .frame(width: lineWidth)
                .frame(maxHeight: .infinity)

            // 노드
            nodeView()
                .frame(width: colWidth, height: nodeSize)

            // 아래 라인
            lineView(style: below)
                .frame(width: lineWidth)
                .frame(maxHeight: .infinity)
        }
        .frame(width: colWidth)
    }

    @ViewBuilder
    private func lineView(style: LineStyle) -> some View {
        switch style {
        case .none:
            Color.clear

        case .solid(let color):
            color

        case .dashed(let color):
            // 점선은 StrokeStyle로 그리기
            Canvas { ctx, size in
                var path = Path()
                path.move(to: CGPoint(x: size.width/2, y: 0))
                path.addLine(to: CGPoint(x: size.width/2, y: size.height))
                ctx.stroke(path, with: .color(color), style: StrokeStyle(lineWidth: lineWidth, dash: [8, 4]))
            }
        }
    }

    @ViewBuilder
    private func nodeView() -> some View {
        switch node {

        // 시작 원
        case .start(let color):
            Circle()
                .stroke(color, lineWidth: 6)
                .background(Circle().fill(Color.white))
                .frame(width: 20, height: 20)

        // 도착 원
        case .end(let color):
            Circle()
                .stroke(color, lineWidth: 6)
                .background(Circle().fill(Color.white))
                .frame(width: 20, height: 20)

        // 도보 (사람 이모지)
        case .walk(let color):
            Image(systemName: "figure.walk")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.gray2)

        // 지하철 (호선 숫자 + 색상)
        case .subway(let lineText, let color):
            RoundedRectangle(cornerRadius: 5)
                .stroke(color, lineWidth: 2)
                .frame(width: 20, height: 20)
                .overlay {
                    Text(lineText)
                        .font(.medium14)
                        .foregroundStyle(color)
                }

        // 버스 (버스 아이콘)
        case .bus(let color):
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.white)
                .frame(width: 20, height: 20)
                .overlay{
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(color, lineWidth: 2)
                }
                .overlay(
                    Image(systemName: "bus.fill")
                        .font(.semiBold12)
                        .foregroundStyle(color)
                )
        }
    }
}

struct SubwayLineBadge: View {
    
    let text: String
    let color: Color
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 20, height: 20)
            .overlay(
                Text(text)
                    .font(.medium12)
                    .foregroundStyle(.white)
            )
    }
}
