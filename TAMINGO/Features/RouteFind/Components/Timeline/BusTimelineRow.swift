//
//  BusTimelineRow.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/8/26.
//

import SwiftUI

struct BusTimelineRow: View {

    let leg: RouteLegModel
    let isFirst: Bool
    let isLast: Bool

    @State private var selectedOption: TransitOptionModel
    @State private var isExpanded = false

    init(leg: RouteLegModel, isFirst: Bool, isLast: Bool) {
        self.leg = leg
        self.isFirst = isFirst
        self.isLast = isLast
        _selectedOption = State(initialValue: leg.options.first ?? TransitOptionModel(type: "", number: "", sectionTime: 0))
    }

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            TimelineVerticalLineView(
                node: .bus(.mainMint),
                above: isFirst ? .none : .solid(.mainMint),
                below: isLast ? .none : .solid(.mainMint)
            )

            VStack(alignment: .leading, spacing: 10) {
                
                Text(leg.startName ?? "버스 정류장")
                    .font(.semiBold14)
                
                ForEach(leg.options) { option in
                    optionRow(option)
                }
                
                ExpandStationsView(
                    count: leg.stationCount,
                    time: leg.sectionTime,
                    stations: leg.stations
                )
            }
            .padding(.vertical, 20)

            Spacer()
        }
        .padding(.horizontal, 40)
    }

    private func optionRow(_ option: TransitOptionModel) -> some View {
        Button {
            selectedOption = option
        } label: {
            HStack(spacing: 10) {
                Text(option.type)
                    .font(.regular10)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(typeColor(option.type))
                    .cornerRadius(5)

                Text(option.number)
                    .font(.semiBold14)

                Text("\(option.sectionTime)분")
                    .font(.medium14)
                    .foregroundStyle(.gray2)

                Spacer()
            }
        }
        .buttonStyle(.plain)
    }

    private var expandButton: some View {
        Button {
            withAnimation { isExpanded.toggle() }
        } label: {
            HStack {
                Text("\(leg.stationCount)개 정류장")
                    .foregroundStyle(.black00)
                Text("\(selectedOption.sectionTime)분")
                    .foregroundStyle(.gray2)
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundStyle(.gray2)
            }
            .font(.medium12)
        }
        .padding(.horizontal,8)
        .padding(.vertical,4)
        .background{
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray0, lineWidth: 1)
                )
                .shadow(
                    color: Color.black.opacity(0.06),
                    radius: 6.89,
                    x: 0,
                    y: 2.297
                )
        }
    }

    private func typeColor(_ type: String) -> Color {
        type == "지선" ? Color("SubGreen2") : Color("SubBlue2")
    }
}
