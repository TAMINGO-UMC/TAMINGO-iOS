//
//  SheetType.swift
//  TAMINGO
//
//  Created by 김도연 on 1/25/26.
//

enum SheetType: Identifiable {
    case date
    case startTime
    case endTime
    case repeatType
    
    var id: Self { self }
}
