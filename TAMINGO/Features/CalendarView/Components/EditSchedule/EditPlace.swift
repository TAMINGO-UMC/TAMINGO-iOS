//
//  EditPlace.swift
//  TAMINGO
//
//  Created by 김도연 on 2/8/26.
//

import SwiftUI

// MARK: - EditPlace Component
struct EditPlace: View {
    var placeName: String
    
    // Data
    var myPlaces: [MyPlaceDTO]
    
    // Action
    var onSelectPlace: (MyPlaceDTO) -> Void
    var onDeletePlace: () -> Void
    
    // Local State
    @State private var isEditing: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                ScheduleSectionHeader(title: "장소", isRequired: false)
            }
            
            if isEditing {
                //TODO: 장소 검색 추가
                placeListScroll
                if myPlaces.isEmpty {
                    GuideText(text: "저장된 장소가 없습니다")
                } else {
                    placeListScroll
                }
            } else {
                SelectedItemRow(
                    title: placeName,
                    onEdit: {
                        withAnimation { isEditing = true }
                    },
                    onDelete: {
                        onDeletePlace()
                    }
                )
            }
        }
    }
    
    private var placeListScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(myPlaces) { place in
                    Button {
                        onSelectPlace(place)
                        withAnimation { isEditing = false }
                    } label: {
                        Text(place.name)
                            .font(.regular12)
                            .foregroundStyle(.black)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                            )
                    }
                }
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 4)
        }
    }
}
