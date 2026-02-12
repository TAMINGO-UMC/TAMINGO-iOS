//
//  EditSchedule+Data.swift
//  TAMINGO
//
//  Created by 김도연 on 2/8/26.
//

import Foundation
import Moya

extension EditScheduleViewModel {
    func updateRepeatEndDate(isEnabled: Bool) {
        if isEnabled {
            // 활성화 시: 오늘 날짜로 초기화
            self.repeatEndDate = Date()
        } else {
            // 비활성화 시: 먼 미래로 설정
            let components = DateComponents(year: 2999, month: 12, day: 31)
            if let farFuture = Calendar.current.date(from: components) {
                self.repeatEndDate = farFuture
            }
        }
    }
    
    // MARK: - Place Logic
    func loadPlaces() {
        _Concurrency.Task {
            do {
                let response: BaseResponse<[MyPlaceDTO]> = try await provider.request(.getFavoritePlaces)
                self.myPlaces = response.result ?? []
            } catch {
                print("내 장소 로딩 실패: \(error)")
            }
        }
    }
    
    func selectPlace(_ place: MyPlaceDTO) {
        self.placeName = place.name
        self.address = place.address
        self.latitude = place.latitude
        self.longitude = place.longitude
    }
    
    func removePlace() {
        self.placeName = ""
        self.address = ""
        self.latitude = nil
        self.longitude = nil
        self.aiInferenceSource.aiSuggestedPlaceName = ""
    }
    
    // MARK: - Todo Logic
    func toggleTodoSelection(_ todo: TodoSummaryDTO) {
        // 이미 연결된 목록(linkedTodos)에 있는지 확인
        if let index = linkedTodos.firstIndex(where: { $0.todoId == todo.todoId }) {
            // 연결 해제: linked -> candidate 이동
            let removedItem = linkedTodos.remove(at: index)
            candidateTodos.insert(removedItem, at: 0)
        }
        // 후보 목록(candidateTodos)에 있는지 확인
        else if let index = candidateTodos.firstIndex(where: { $0.todoId == todo.todoId }) {
            // 연결 추가: candidate -> linked 이동
            let selectedItem = candidateTodos.remove(at: index)
            linkedTodos.append(selectedItem)
        }
    }
    
    // MARK: - Category Logic
    func loadCategories() {
        _Concurrency.Task {
            do {
                let response: BaseResponse<[ScheduleCategoryDTO]> = try await provider.request(.getCategories)
                self.categories = response.result ?? []
            } catch {
                print("카테고리 로딩 실패")
            }
        }
    }
    
    func findCategoryId(by name: String) -> Int? {
        return self.categories.first { $0.name == name }?.id
    }
    
    func selectCategory(_ category: ScheduleCategoryDTO) {
        self.categoryName = category.name
        self.scheduleCategoryId = category.id
    }
    
    func removeCategory() {
        self.scheduleCategoryId = 0
        self.categoryName = ""
        self.aiInferenceSource.aiSuggestedCategoryName = ""
    }
}
