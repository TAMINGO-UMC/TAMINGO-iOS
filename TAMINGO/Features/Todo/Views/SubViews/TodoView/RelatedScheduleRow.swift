//
//  RelatedScheduleRow.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/31/26.
//
import SwiftUI
// MARK: - Related Schedule Row
struct RelatedScheduleRow: View {
    @Binding var schedule: RelatedScheduleItem
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                schedule.isSelected.toggle()
            }) {
                Image(systemName: schedule.isSelected ? "checkmark.square.fill" : "square")
                    .foregroundColor(schedule.isSelected ? .mainMint : .gray)
                    .frame(width: 16, height: 16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 3.5)
                            .stroke(Color.gray1, lineWidth: schedule.isSelected ? 0 : 1)
                    )
            }
            
            Text(schedule.title)
                .font(.medium14)
                .foregroundColor(.gray2)
            
            Spacer()
            
            Text(schedule.location)
                .font(.regular12)
                .foregroundColor(.gray2)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray1, lineWidth: 1)
                )
        }
        .frame(height: 41.79)
        .padding(.horizontal, 12)
    }
}
