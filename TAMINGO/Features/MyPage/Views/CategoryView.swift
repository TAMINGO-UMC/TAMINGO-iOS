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
    VM.CategoryType: CategoryItem{
    let type: CategoryType
    @State var vm: VM

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            header

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

                    if type == .todo {
                        AIInfoView()
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.horizontal, 16)
    }
}

private extension CategoryView {

    var header: some View {
        HStack(spacing: 14) {
            Button { } label: {
                Image("Previous_Chevron")
                    .resizable()
                    .frame(width: 5, height: 10)
            }

            Text(type.title)
                .font(.semiBold16)
                .foregroundStyle(.black00)

            Spacer()

            Button { } label: {
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


// 프리뷰 용
struct CategoryEditPreviewView: View {

    let category: TodoCategory?

    var body: some View {
        VStack(spacing: 24) {
            Text(category == nil ? "카테고리 추가" : "카테고리 수정")
                .font(.title2)
                .bold()

            if let category {
                CategoryRowView(
                    category: category,
                    onEdit: {},
                    onDelete: {}
                )
            } else {
                Text("새 카테고리")
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding()
    }
}



#Preview {
    let vm = TodoCategoryViewModel()
    CategoryView(type: .schedule, vm:vm)
}
