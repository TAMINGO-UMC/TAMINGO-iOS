//
//  RouteInputCardView.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/8/26.
//

import SwiftUI

struct RouteInputCardView: View {

    let route: RouteResultModel?
    let wayPoints: [String]

    var body: some View {
        VStack(spacing: 12) {

            if let route {
                LocationRowView(
                    title: "출발",
                    locationName: route.startPlaceName
                )

                if !wayPoints.isEmpty {
                    LocationRowView(
                        title: "경유",
                        locationName: wayPoints.joined(separator: ", ")
                    )
                }

                LocationRowView(
                    title: "도착",
                    locationName: route.arrivePlaceName
                )
            }
        }
        .padding(16)
        .background{
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
        }
        .padding(.horizontal, 30)
        .padding(.top, 8)
    }
}

