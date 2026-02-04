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
            color: CategoryColor.lightBlue.color,
            colorName: CategoryColor.lightBlue.displayName
        ),
        ScheduleCategory(
            id: 2,
            name: "운동",
            color: CategoryColor.mint.color,
            colorName: CategoryColor.mint.displayName
        ),
        ScheduleCategory(
            id: 3,
            name: "학교",
            color: CategoryColor.peach.color,
            colorName: CategoryColor.peach.displayName
        ),
        ScheduleCategory(
            id: 4,
            name: "업무",
            color: CategoryColor.purple.color,
            colorName: CategoryColor.purple.displayName
        ),
        ScheduleCategory(
            id: 6,
            name: "여행",
            color: CategoryColor.lightMint.color,
            colorName: CategoryColor.lightMint.displayName
        )
    ]
}


@Observable
final class ScheduleCategoryViewModel: CategoryViewModel {
    
    typealias CategoryType = ScheduleCategory

    // MARK: - List
    var categories: [ScheduleCategory] = ScheduleCategory.mockList

    // MARK: - Edit State
    var editingCategoryId: Int? = nil
    var name: String = ""
    var selectedColor: CategoryColor = .mint
    
    // MARK: - Validation
    var canSaveCategory: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }


    // MARK: - Add
    func didTapAdd() {
        editingCategoryId = nil
        name = ""
        selectedColor = .mint
    }

    // MARK: - Edit
    func didTapEdit(_ category: ScheduleCategory) {
        editingCategoryId = category.id
        name = category.name
        selectedColor =
            CategoryColor.allCases.first {
                $0.displayName == category.colorName
            } ?? .mint
    }

    // MARK: - Save (Create / Update)
    func saveCategory() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedName.isEmpty else { return }
        
        if let id = editingCategoryId,
           let index = categories.firstIndex(where: { $0.id == id }) {

            // update
            categories[index] = ScheduleCategory(
                id: id,
                name: name,
                color: selectedColor.color,
                colorName: selectedColor.displayName
            )

        } else {
            // create
            let newId = (categories.map { $0.id }.max() ?? 0) + 1
            categories.append(
                ScheduleCategory(
                    id: newId,
                    name: name,
                    color: selectedColor.color,
                    colorName: selectedColor.displayName
                )
            )
        }
    }

    // MARK: - Delete
    func deleteCategory(_ category: ScheduleCategory) {
        categories.removeAll { $0.id == category.id }
    }
}
