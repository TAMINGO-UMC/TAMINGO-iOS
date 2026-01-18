//
//  Schedule.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/18/26.
//

import Foundation

struct Schedule: Identifiable {
    let id: UUID = UUID()
    let title: String
    let time: String
    let location: String
    let remainingText: String?
    let isHighlighted: Bool
}
