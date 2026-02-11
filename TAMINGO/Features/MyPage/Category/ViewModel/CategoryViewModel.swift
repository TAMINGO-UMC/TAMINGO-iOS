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
    
    var isEmpty: Bool { get }
    var canSaveCategory: Bool { get }

    func didTapAdd()
    func didTapEdit(_ category: CategoryType)
    func saveCategory()
    func deleteCategory(_ category: CategoryType)
}

