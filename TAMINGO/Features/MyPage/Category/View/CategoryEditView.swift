//
//  CategoryEditView.swift
//  TAMINGO
//
//  Created by 권예원 on 2/4/26.
//

import SwiftUI

struct CategoryEditView<VM: CategoryViewModel>: View
where
    VM: CategoryViewModel & Observable & AnyObject,
    VM.CategoryType: CategoryItem {
    @Bindable var vm: VM
    let category: VM.CategoryType

    var body: some View {
        VStack(spacing: 19) {
            formSection
            CategoryColorPickerView(
                selectedColor: $vm.selectedColor
            )
            bottomButtons
        }
        .categoryStyle(height: 321, color:vm.selectedColor.color)
    }
}


private extension CategoryEditView {

    var formSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("카테고리 이름")
                .font(.regular12)
                .foregroundColor(.gray2)

            TextField("카테고리 이름", text: $vm.name)
                .font(.medium14)
                .foregroundColor(Color(red: 0.04, green: 0.04, blue: 0.04).opacity(0.5))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, minHeight: 38, maxHeight: 38, alignment: .leading)
                .background(.gray0)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                .stroke(.gray1, lineWidth: 0.5)
                )
        }
    }
}

struct CategoryColorPickerView: View {

    @Binding var selectedColor: CategoryColor

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 8),
        count: 6
    )

    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            Text("색상 선택")
                .font(.regular12)
                .foregroundColor(.gray2)
            LazyVGrid(columns: columns, spacing:8) {
                ForEach(CategoryColor.allCases, id: \.self) { color in
                    Button {
                        selectedColor = color
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(color.color)
                                .frame(width: 40, height: 40)
                            
                            if selectedColor == color {
                                Image("MyPage_icon_check")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}



private extension CategoryEditView {

    var bottomButtons: some View {
        HStack(spacing: 8) {

            Button {
                vm.cancelEditing()
            } label: {
                Text("취소")
                    .font(.semiBold14)
                    .foregroundStyle(.gray2)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray1)
                    )
                    .shadow(color: .black.opacity(0.06), radius: 3.44483, x: 0, y: 2.29655)

            }

            Button {
                Task {
                    await vm.saveCategory()
               }
            } label: {
                Text("저장")
                    .font(.semiBold14)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(
                        vm.canSaveCategory
                        ? .mainMint
                        : .gray1
                    )
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            .disabled(!vm.canSaveCategory || vm.isLoading)
        }
    }
}

#Preview {
    let vm = TodoCategoryViewModel()

    let category = TodoCategory(
        id: 1,
        name: "집",
        color: .peach
    )

    CategoryEditView(
        vm: vm,
        category: category
    )
    .padding()
}
