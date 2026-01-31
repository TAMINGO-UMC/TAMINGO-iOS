//
//  AddSchedule+Data.swift
//  TAMINGO
//
//  Created by 김도연 on 1/31/26.
//

import Foundation
import Moya

extension AddScheduleViewModel {
    
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
    
    // MARK: - Place Logic
    func loadFavoritePlaces() {
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
    
    func addFavoritePlace() {
        guard let lat = latitude, let lon = longitude else { return }
        let requestBody = addPlaceDTO(
            name: placeName, address: address, latitude: lat, longitude: lon, isAiSuggested: true
        )
        
        let target: ScheduleTarget = .aiFavoritePlaces(body: requestBody)

            _Concurrency.Task {
            do {
                let _: BaseResponse<Int> = try await provider.request(target)
            } catch {
                print("\(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Todo Logic
    var selectedTodoObjects: [TodoSummaryDTO] {
        let allTodos = nearbyTodos + candidateTodos
        return allTodos.filter { linkedTodoIds.contains($0.todoId) }
    }
    
    func toggleTodoSelection(_ todoId: Int) {
        if let index = linkedTodoIds.firstIndex(of: todoId) {
            linkedTodoIds.remove(at: index)
        } else {
            linkedTodoIds = [todoId]
            isTodoExpanded = false
        }
    }
}
