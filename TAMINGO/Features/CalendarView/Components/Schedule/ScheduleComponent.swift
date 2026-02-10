//
//  ScheduleComponent.swift
//  TAMINGO
//
//  Created by 김도연 on 2/8/26.
//

import SwiftUI

// MARK: - Header View
struct ScheduleHeader: View {
    var title: String
    var onDismiss: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .font(.semiBold18)
                .foregroundStyle(.black)
            Spacer()
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .foregroundStyle(.gray)
            }
        }
        .padding(.top, 24)
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
}

// MARK: - Title Component
struct ScheduleTitleInput: View {
    @Binding var title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ScheduleSectionHeader(title: "제목", isRequired: true)
            
            TextField("일정 제목을 입력하세요", text: $title)
                .font(.medium12)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color.gray0)
                )
        }
    }
}

// MARK: - Section Header
struct ScheduleSectionHeader: View {
    let title: String
    let isRequired: Bool
    
    var body: some View {
        HStack(spacing: 2) {
            Text(title).font(.medium14)
            if isRequired {
                Text("*").font(.medium14).foregroundStyle(Color.mainMint)
            }
        }
    }
}

// MARK: - Guide Text
struct GuideText: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.medium12)
            .foregroundStyle(.gray)
            .padding(.top, 4)
    }
}

// MARK: - Memo Component
struct ScheduleMemo: View {
    @Binding var memo: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ScheduleSectionHeader(title: "메모", isRequired: false)
            TextField("추가 메모를 입력하세요", text: $memo, axis: .vertical)
                .font(.medium12)
                .padding(16)
                .frame(minHeight: 100, alignment: .top)
                .background(Color.gray0)
                .cornerRadius(8)
        }
    }
}

// MARK: - ScheduleOptionRow
struct ScheduleOptionRow: View {
    let title: String
    let image: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.medium12)
                    .foregroundStyle(.black)
                
                Spacer()
                
                Image(systemName: image)
                    .foregroundStyle(.black)
            }
            .padding()
        }
        .background(RoundedRectangle(cornerRadius: 8).foregroundStyle(.gray0))
    }
}

// MARK: - Selected Item Row
struct SelectedItemRow: View {
    let title: String
    let onEdit: () -> Void
    
    var body: some View {
        HStack {
            Text(title).font(.medium12)
            Spacer()
            Button("수정") { onEdit() }
                .font(.medium12)
                .foregroundStyle(Color.gray)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.gray0)
                )
        }
    }
}
