//
//  TodoEditSheet.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/29/26.
//  Updated: 2/9/26 - 저장 시 서버 업데이트 호출
//

import SwiftUI

struct TodoEditSheet: View {
    @Binding var isPresented: Bool
    @Binding var item: TodoItem
    @State private var viewModel: TodoEditViewModel
    
    // TodoViewModel 전달 추가
    var onSave: ((TodoItem) -> Void)?
    var onDelete: ((TodoItem) -> Void)?
    
    init(
        isPresented: Binding<Bool>,
        item: Binding<TodoItem>,
        onSave: ((TodoItem) -> Void)? = nil,
        onDelete: ((TodoItem) -> Void)? = nil
    ) {
        self._isPresented = isPresented
        self._item = item
        self.onSave = onSave
        self.onDelete = onDelete
        
        let viewModel = TodoEditViewModel(item: item.wrappedValue)
        self._viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible())], spacing: 20) {
                    Header(isPresented: $isPresented)
                    
                    TitleSection(title: Binding(
                        get: { viewModel.title },
                        set: { viewModel.onTitleChanged($0) }
                    ))
                    
                    DateSection(viewModel: $viewModel)
                    
                    LocationSection(viewModel: $viewModel)
                    
                    DurationSection(viewModel: $viewModel)
                    
                    CategorySections(viewModel: $viewModel)
                    
                    RelateSchedule(viewModel: $viewModel)
                    
                    RoutineSection(viewModel: $viewModel)
                    
                    BottomButtons(
                        viewModel: $viewModel,
                        item: $item,
                        isPresented: $isPresented,
                        onSave: { updatedItem in
                            // ✅ 저장 시 서버 업데이트 호출
                            onSave?(updatedItem)
                        },
                        onDelete: { deletedItem in
                            // ✅ 삭제 시 서버 삭제 호출
                            onDelete?(deletedItem)
                        }
                    )
                }
                .padding(.horizontal, 21)
                .padding(.top, 20)
            }
            .task {
                await viewModel.loadMyPlaces()
                await viewModel.loadCategories()
            }
        }
    }
}
