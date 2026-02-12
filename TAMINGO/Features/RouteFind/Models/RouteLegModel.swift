//
//  RouteLegModel.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/8/26.
//

import Foundation
import SwiftUI

struct RouteLegModel: Identifiable {
    let id = UUID()
    let mode: TransportMode
    let sectionTime: Int
    let distance: Int

    let walkDescription: String?

    let startName: String?
    let endName: String?
    let routeName: String?
    let routeColor: String?
    let stations: [String]
    let stationCount: Int
    
    let options: [TransitOptionModel]
}

struct TransitOptionModel: Identifiable {
    let id = UUID()
    let type: String          // "지선", "간선", "내선", "외선"
    let number: String        // "1024", "303"
    let sectionTime: Int
}

extension String {
    func subwayBadgeText() -> String {
        if contains("신분당") { return "신" }
        if contains("경의") { return "경" }
        if contains("경춘") { return "경" }
        if contains("수인") { return "수" }
        if contains("인천") { return "인" }

        // n호선
        let numbers = self.filter { $0.isNumber }
        return numbers.isEmpty ? "?" : numbers
    }
}

extension Color {
    init(routeHex: String) {
        let hex = routeHex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hex)

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        self.init(
            red: Double((rgb >> 16) & 0xff) / 255,
            green: Double((rgb >> 8) & 0xff) / 255,
            blue: Double(rgb & 0xff) / 255
        )
    }
}
