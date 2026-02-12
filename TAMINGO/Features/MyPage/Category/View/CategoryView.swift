//
//  CategoryView.swift
//  TAMINGO
//
//  Created by 권예원 on 2/2/26.
//

import SwiftUI

struct CategoryView<VM: CategoryViewModel>: View
where
VM: CategoryViewModel & Observable & AnyObject,
VM.CategoryType: CategoryItem {

    let type: CategoryType
    @Bindable var vm: VM
    @Environment(\.dismiss) private var dismiss // 시트용
    let onBack: () -> Void

    init(
        type: CategoryType,
        vm: VM,
        onBack: @escaping () -> Void
    ) {
        self.type = type
        self.onBack = onBack          
        self.vm = vm
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            header
                .padding(.horizontal, 16)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    introText

                    ForEach(vm.categories) { category in
                        VStack(spacing: 8) {
                            CategoryRowView(
                                category: category,
                                onEdit: { vm.didTapEdit(category) },
                                onDelete: {
                                    Task {
                                        await vm.deleteCategory(category)
                                    }
                                }
                            )

                            if vm.editingCategoryId == category.id {
                                CategoryEditView(
                                    vm: vm,
                                    category: category
                                )
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                    }
                    
                    if vm.categories.isEmpty {
                        CategoryEmptyView()
                    }
                    AIInfoView()

                }
                .padding(.horizontal, 16)
            }
        }
        .padding(16)
        .navigationBarBackButtonHidden(true)
        .task {
            await vm.fetchCategories()
        }
        .alert(
            "알림",
            isPresented: Binding(
                get: { vm.errorMessage != nil },
                set: { _ in vm.errorMessage = nil }
            )
        ) {
            Button("확인", role: .cancel) {
                vm.errorMessage = nil
            }
        } message: {
            Text(vm.errorMessage ?? "")
        }


    }
}

private extension CategoryView {

    var header: some View {
        HStack(spacing: 14) {
            Button {
                dismiss()
            } label: {
                Image("Previous_Chevron")
                    .resizable()
                    .frame(width: 5, height: 10)
            }

            Text(type.title)
                .font(.semiBold16)
                .foregroundStyle(.black00)

            Spacer()

            Button {
                withAnimation {
                    vm.didTapAdd()
                }
            } label: {
                Image("MyPage_icon_plus")
                    .resizable()
                    .frame(width: 13, height: 13)
                    .padding(6)
                    .background(.mainMint)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
        }
    }

    var introText: some View {
        Text(type.description)
            .font(.regular12)
            .foregroundStyle(.gray2)
    }
}


struct CategoryEmptyView: View {
    var body: some View {
        VStack(spacing:0){
            Image("MyPage_monoCal")
                .resizable()
                .frame(width: 134, height: 134)
            Text("할 일 카테고리를 추가해보세요!")
                .font(.medium12)
                .foregroundStyle(Color(hex: "#BEBEBE"))
        }
        .frame(height: 193)
        .frame(maxWidth: .infinity)
    }
}

#Preview("Todo Category") {
    CategoryView<TodoCategoryViewModel>(
        type: .todo,
        vm: TodoCategoryViewModel(),
        onBack: {}
    )
}
