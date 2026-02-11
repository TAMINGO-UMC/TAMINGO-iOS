//
//  ScheduleCategoryViewModel.swift
//  TAMINGO
//
//  Created by 권예원 on 2/4/26.
//

import SwiftUI
import Observation

// Mock 데이터
extension ScheduleCategory {

    static let mockList: [ScheduleCategory] = [
        ScheduleCategory(
            id: 1,
            name: "일상",
            color: .lightBlue
        ),
        ScheduleCategory(
            id: 2,
            name: "운동",
            color: .mint
        )
    ]

}


@Observable
final class ScheduleCategoryViewModel: CategoryViewModel {
    
    typealias CategoryType = ScheduleCategory
    
    private let service: ScheduleCategoryServiceProtocol
    init(service: ScheduleCategoryServiceProtocol = ScheduleCategoryService()) {
        self.service = service
    }


    // MARK: - List
    var categories: [ScheduleCategory] = ScheduleCategory.mockList
    
    var isLoading: Bool = false
    var errorMessage: String?

    // MARK: - Edit State
    var editingCategoryId: Int? = nil
    var name: String = ""
    var selectedColor: CategoryColor = .mint
    
    // MARK: - Validation
    var canSaveCategory: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    var isEmpty: Bool {
        categories.isEmpty
    }


    // MARK: - Add
    func didTapAdd() {
        name = ""
        selectedColor = .mint

        // 항상 음수로 생성
        let tempId = -((categories.count) + 1)

        let newCategory = ScheduleCategory(
            id: tempId,
            name: "",
            color: selectedColor
        )

        categories.append(newCategory)
        editingCategoryId = tempId
    }


    // MARK: - Edit
    func didTapEdit(_ category: ScheduleCategory) {
        editingCategoryId = category.id
        name = category.name
        selectedColor = category.color
    }
    
    func cancelEditing() {
        if let id = editingCategoryId, id < 0 {
            categories.removeAll { $0.id == id }
        }
        editingCategoryId = nil
    }
    
    // MARK: - Fetch
    func fetchCategories() async {
            isLoading = true
            defer { isLoading = false }

            do {
                categories = try await service.fetchCategories()
            } catch {
                errorMessage = error.localizedDescription
            }
        }

    // MARK: - Save (Create / Update)
    func saveCategory() async {
        guard canSaveCategory else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            if let id = editingCategoryId {

                if id < 0 {
                    let created = try await service.createCategory(
                        name: name,
                        colorCode: selectedColor.hexCode
                    )

                    categories.removeAll { $0.id == id }
                    categories.append(created)

                } else {
                    let updated = try await service.updateCategory(
                        id: id,
                        name: name,
                        colorCode: selectedColor.hexCode
                    )

                    if let index = categories.firstIndex(where: { $0.id == id }) {
                        categories[index] = updated
                    }
                }
            }

            editingCategoryId = nil

        } catch {
            errorMessage = error.localizedDescription
        }
    }


    // MARK: - Delete
    func deleteCategory(_ category: ScheduleCategory) async {
        isLoading = true
        defer { isLoading = false }

        do {
            try await service.deleteCategory(id: category.id)
            categories.removeAll { $0.id == category.id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

}
