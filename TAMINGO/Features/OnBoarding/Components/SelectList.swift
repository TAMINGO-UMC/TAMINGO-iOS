//
//  SelectList.swift
//  TAMINGO
//
//  Created by 권예원 on 1/28/26.
//

import SwiftUI



struct SelectList<Item: Identifiable & Equatable>: View {

    let items: [Item]
    let selected: Item?
    let width: CGFloat
    let isDisabled: (Item) -> Bool
    let onSelect: (Item) -> Void
    let titleProvider: (Item) -> String

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                Button {
                    if !isDisabled(item) {
                        onSelect(item)
                    }
                } label: {
                    HStack(spacing: 2) {
                        Image("OnBoarding_icon_check")
                            .resizable()
                            .frame(width: 14, height: 14)
                            .opacity(selected == item ? 1 : 0)

                        Text(titleProvider(item))
                            .font(.regular10)
                            .foregroundColor(
                                isDisabled(item) ? .gray2 : .black
                            )

                        Spacer()
                    }
                    .padding(.horizontal, 4)
                    .frame(height: 20)
                    .opacity(isDisabled(item) ? 0.5 : 1)
                }
                .disabled(isDisabled(item))

                if index < items.count - 1 {
                    Divider()
                        .foregroundStyle(Color(red: 0.85, green: 0.85, blue: 0.85))
                }
            }
        }
        .background(.gray1)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 8)
        .frame(width: width)
    }
}





