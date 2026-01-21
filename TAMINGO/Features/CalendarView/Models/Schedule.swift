//
//  Schedule.swift
//  TAMINGO
//
//  Created by 김도연 on 1/18/26.
//

import Foundation
import SwiftUI

struct ScheduleItem: Identifiable {
    let id: Int
    var title: String
    var place: String
    var category: String
    var startTime: String
    var endTime: String
    var color: Color
}
