//
//  CategoryViewModel.swift
//  TAMINGO
//
//  Created by 권예원 on 2/4/26.
//
import Observation

protocol CategoryViewModel: AnyObject {
    associatedtype CategoryType: CategoryItem

    var categories: [CategoryType] { get set }
    var editingCategoryId: Int? { get set }

    var name: String { get set }
    var selectedColor: CategoryColor { get set }

    var isLoading: Bool { get set }
    var errorMessage: String? { get set }

    var isEmpty: Bool { get }
    var canSaveCategory: Bool { get }

    func fetchCategories() async
    func didTapAdd()
    func didTapEdit(_ category: CategoryType)
    func cancelEditing()
    func saveCategory() async
    func deleteCategory(_ category: CategoryType) async
}

