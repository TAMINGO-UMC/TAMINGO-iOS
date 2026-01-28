//
//  GapTime.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/27/26.
//

import Foundation

struct GapTime: Identifiable {
    let id: UUID = UUID()
    let time: String
    let title: String
    let location: String
    let availableText: String
}
