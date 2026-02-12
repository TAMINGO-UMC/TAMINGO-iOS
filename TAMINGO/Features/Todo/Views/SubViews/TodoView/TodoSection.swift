//
//  Untitled.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/29/26.
//
import SwiftUI

struct TodoSection: View {
    let headerTitle: String
    let headerDate: String?
    let items: [TodoItem]
    let onToggle: (TodoItem) -> Void
    let onEdit: (TodoItem) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeaderComponent(
                title: headerTitle,
                date: headerDate,
                count: items.count
            )
            
            ForEach(items) { item in
                TodoRow(
                    item: item,
                    onToggle: { onToggle(item) },
                    onEdit: { onEdit(item) }
                )
            }
        }
    }
}
