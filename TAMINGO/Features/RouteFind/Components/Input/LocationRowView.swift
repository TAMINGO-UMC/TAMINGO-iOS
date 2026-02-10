//
//  LocationRowView.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/8/26.
//

import SwiftUI

struct LocationRowView: View {

    let title: String
    let locationName: String
    let iconName: String = "mappin"

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            Text(title)
                .font(.regular12)
                .foregroundStyle(.gray2)

            HStack(spacing: 6) {
                Image(systemName: iconName)
                    .foregroundStyle(.gray2)

                Text(locationName)
                    .font(.medium14)
                    .foregroundStyle(.gray2)

                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background{
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray1)
                    .fill(Color.gray0)
                    
            }
        }
    }
}
