//
//  TransportButton.swift
//  TAMINGO
//
//  Created by 권예원 on 1/17/26.
//

import SwiftUI

struct TransportButton: View {
    let type: TransportType
    let priority: Int?
    let isSelected: Bool
    let backgroundOpacity: Double
    let onTap: () -> Void
    
    private var backgroundColor: Color {
        isSelected
        ? .mainMint.opacity(backgroundOpacity)
        : .gray1
    }

    var body: some View {
        Button(action: onTap) {
            HStack() {

                Text(type.title)
                    .font(.medium13) // TODO: medium 12 변경 필요
                    .foregroundStyle(isSelected ? .white : .gray)
                Spacer()
                ZStack{
                    RoundedRectangle(cornerRadius: 4.35)
                        .fill(.white)
                        .frame(width: 20, height: 20)
                    if let priority {
                        Text("\(priority)")
                            .font(.medium13) // TODO: medium 12 변경 필요
                            .foregroundStyle(backgroundColor)
                    }
                }


            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(backgroundColor)
            )
            .frame(width: 88, height: 32)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 12) {

        TransportButton(
            type: .walk,
            priority: nil,
            isSelected: false,
            backgroundOpacity: 1.0,
            onTap: {}
        )

        TransportButton(
            type: .walk,
            priority: 1,
            isSelected: true,
            backgroundOpacity: 1.0,
            onTap: {}
        )

        TransportButton(
            type: .subway,
            priority: 2,
            isSelected: true,
            backgroundOpacity: 0.7,
            onTap: {}
        )

        TransportButton(
            type: .bus,
            priority: 3,
            isSelected: true,
            backgroundOpacity: 0.4,
            onTap: {}
        )
    }
    .padding()
}


