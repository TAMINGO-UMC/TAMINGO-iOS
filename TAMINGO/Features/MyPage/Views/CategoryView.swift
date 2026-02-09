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
   
    @State private var vm: VM
    @Environment(\.dismiss) private var dismiss

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
                                onDelete: { vm.deleteCategory(category) }
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


                    AIInfoView()

                }
                .padding(.horizontal, 16)
            }
        }
        .padding(16)
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
                /* 기능 준비 후 구현 예정 */
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

// 프리뷰용
extension CategoryView {
    init(type: CategoryType, previewVM: VM) {
        self.type = type
        _vm = State(wrappedValue: previewVM)
    }
}

#Preview {
    CategoryView(
        type: .todo,
        previewVM: TodoCategoryViewModel()
    )
}
