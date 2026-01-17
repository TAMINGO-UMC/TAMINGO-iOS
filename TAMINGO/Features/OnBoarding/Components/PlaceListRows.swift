//
//  PlaceListLows.swift
//  TAMINGO
//
//  Created by 권예원 on 1/17/26.
//

import SwiftUI

struct PlaceListRow: View {

    let address: String
    let name: String
    let onDelete: () -> Void

    var body: some View {
        HStack {
            Text("\(address), \(name)")
                .font(.regular09) // TODO: regular10 변경 필요
                .foregroundStyle(.black)
                .lineLimit(1)
                .truncationMode(.tail)

            Button(action: onDelete){
                Image("icon_xmark")
                    .frame(width: 12, height: 12)
            }
        }
        .padding(.vertical, 6)
    }
}


#Preview {
    PlaceListRow(address: "서울특별시 노원구 광운로21", name: "집 앞 카페", onDelete: {return})
}
