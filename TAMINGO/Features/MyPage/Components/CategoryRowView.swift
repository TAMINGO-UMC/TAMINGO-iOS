//
//  CategoryRowView.swift
//  TAMINGO
//
//  Created by 권예원 on 2/4/26.
//
import SwiftUI

struct CategoryRowView<Category: CategoryItem>: View {

    let category: Category
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {

        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 6) {
                Text(category.name)
                    .font(.medium14)
                    .foregroundColor(.black00)

                HStack(spacing: 4) {
                    Circle()
                        .fill(category.color)
                        .frame(width: 12, height: 12)

                    Text(category.colorName)
                        .font(.regular12)
                        .foregroundColor(.gray2)
                }
            }

            Spacer()

            Button(action: onEdit) {
                Image("MyPage_icon_pencil")
                    .resizable()
                    .frame(width: 16, height: 16)
            }
            .padding(.trailing, 24)

            Button(action: onDelete) {
                Image("MyPage_icon_trash")
                    .resizable()
                    .frame(width: 16, height: 16)
            }
        }
        .categotyStyle(height: 60, color:category.color)
    }
}


#Preview {
    CategoryRowView(
        category: TodoCategory(
            id: 1,
            name: "일상",
            color: .mint,
            colorName: "민트"
        ),
        onEdit: {},
        onDelete: {}
    )
    .padding()
}
