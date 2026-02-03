

import SwiftUI

struct CategoryTag: View {
    let category: String
    let categoryColor: TodoItem.CategoryColor
    
    var body: some View {
        Text(category)
            .font(.regular10)
            .foregroundColor(Color(
                red: categoryColor.textColor.r / 255,
                green: categoryColor.textColor.g / 255,
                blue: categoryColor.textColor.b / 255
            ))
            .frame(width: 32, height: 17)
            .background(Color(
                red: categoryColor.backgroundColor.r / 255,
                green: categoryColor.backgroundColor.g / 255,
                blue: categoryColor.backgroundColor.b / 255
            ))
            .cornerRadius(4)
    }
}

