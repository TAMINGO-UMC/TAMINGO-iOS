//
//  ScheduleViewModel.swift
//  TAMINGO
//
//  Created by 김도연 on 1/18/26.
//

import SwiftUI
import Observation
import Moya

@Observable
class ScheduleViewModel {
    private let provider = MoyaProvider<ScheduleTarget>(stubClosure: MoyaProvider.immediatelyStub)
    
    var todaySchedules: [ScheduleListDTO] = []
    var categoryMap: [String: Color] = [:]
    
    func getSchedules(date: String) async {
        do {
            let categoryResponse: BaseResponse<[ScheduleCategoryDTO]> = try await provider.request(.getCategories)
            updateCategoryMap(with: categoryResponse.result ?? [])
            
            let scheduleResponse: BaseResponse<[ScheduleListDTO]> = try await provider.request(.getScheduleList(date: date))
            self.todaySchedules = scheduleResponse.result ?? []
            
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
        
    private func updateCategoryMap(with categories: [ScheduleCategoryDTO]) {
        var newMap: [String: Color] = [:]
        for cat in categories {
            newMap[cat.name] = Color(hex: cat.colorCode)
        }
        self.categoryMap = newMap
    }
}
