//
//  RoundLink.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/28/26.
//

import Foundation

struct RouteLink: Identifiable {
    let id = UUID()
    let time: String
    let title: String
    let location: String
    let detourText: String
    let suggestionText: String
}
