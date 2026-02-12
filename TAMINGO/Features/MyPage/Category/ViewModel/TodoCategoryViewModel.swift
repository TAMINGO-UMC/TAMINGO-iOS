//
//  TodoCategoryViewModel.swift
//  TAMINGO
//
//  Created by 권예원 on 2/4/26.
//

import SwiftUI
import Observation

// Mock 데이터
extension TodoCategory {

    static let mockList: [TodoCategory] = [
        TodoCategory(id: 1, name: "일상", color: .lightBlue),
        TodoCategory(id: 2, name: "운동", color: .mint)
    ]
}

@Observable
final class TodoCategoryViewModel: CategoryViewModel {

    typealias CategoryType = TodoCategory

    // MARK: - Dependency
    private let service: TodoCategoryServiceProtocol

    init(service: TodoCategoryServiceProtocol = TodoCategoryService()) {
        self.service = service
    }

    // MARK: - State
    var categories: [TodoCategory] = []
    var editingCategoryId: Int? = nil
    var name: String = ""
    var selectedColor: CategoryColor = .mint

    var isLoading: Bool = false
    var errorMessage: String?

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

        let newCategory = TodoCategory(
            id: tempId,
            name: "",
            color: selectedColor
        )

        categories.append(newCategory)
        editingCategoryId = tempId
    }



    // MARK: - Edit
    func didTapEdit(_ category: TodoCategory) {
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


}

@MainActor
extension TodoCategoryViewModel {
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
    // MARK: - Save
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
    func deleteCategory(_ category: TodoCategory) async {
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
