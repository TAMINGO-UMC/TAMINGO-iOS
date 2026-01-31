//
//  AddScheduleView.swift
//  TAMINGO
//
//  Created by 김도연 on 1/23/26.
//

import SwiftUI

struct AddScheduleView: View {
    @State var viewModel = AddScheduleViewModel()
    
    @Environment(\.dismiss) var dismiss
    @State var activeSheet: SheetType? = nil
    @State var isEndDated: Bool = true
    @State var editCategory: Bool = false
    @State var editPlace: Bool = false
    @State var isFavoriteAdded: Bool = false
    
    var onSave: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    titleSection
                    dateTimeSection
                    placeSection
                    todoConnectionSection
                    categorySection
                    repeatSection
                    memoSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            
            bottomButtonSection
        }
        .overlay(alignment: .bottom) {
            if viewModel.isFavoriteRecommendation {
                recommendationOverlay
                    .padding(.bottom, 100)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .task(id: viewModel.startTime) {
            // 시작 시간이 바뀌면 종료시간 자동 +1시간
            viewModel.endTime = viewModel.startTime.addingTimeInterval(3600)
        }
        .sheet(item: $activeSheet) { type in
            sheetContent(for: type)
                .presentationDetents([.height(240)])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    AddScheduleView()
}
