//
//  ExpandStationsView.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/10/26.
//

import SwiftUI

struct ExpandStationsView: View {

    let count: Int
    let time: Int
    let stations: [String]

    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: 6) {
                    Text("\(count)개 역")
                        .foregroundStyle(.black00)
                    
                    Text("\(time)분")
                        .font(.medium12)
                        .foregroundStyle(.gray2)
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                }
                .font(.medium12)
            }
            .buttonStyle(.plain)
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

            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(stations, id: \.self) { station in
                        Text("\(station)")
                            .font(.regular12)
                            .foregroundStyle(.gray2)
                    }
                }
                .padding(.top, 4)
                .padding(.horizontal, 10)
            }
        }
    }
}
