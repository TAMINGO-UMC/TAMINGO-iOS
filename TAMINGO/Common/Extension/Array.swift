//
//  Array.swift
//  TAMINGO
//
//  Created by 권예원 on 2/11/26.
//

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
