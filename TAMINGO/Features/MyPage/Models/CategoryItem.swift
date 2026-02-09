//
//  CategoryItem.swift
//  TAMINGO
//
//  Created by 권예원 on 2/4/26.
//

import SwiftUI

protocol CategoryItem: Identifiable {
    var id: Int { get }
    var name: String { get }
    var color: Color { get }
    var colorName: String { get }
}
