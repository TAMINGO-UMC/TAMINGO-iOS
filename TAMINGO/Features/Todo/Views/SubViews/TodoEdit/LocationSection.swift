//
//  LocationSection.swift
//  TAMINGO
//
//  Created by 엄지용 on 1/29/26.
//

import SwiftUI

struct LocationSection: View {
    @Binding var viewModel: TodoEditViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("장소")
                    .font(.medium14)
                    .foregroundColor(.black)
                
                if viewModel.isLocationAIGenerated {
                    AIBadge()
                }
                
                Spacer()
            }
            
            // 축소 상태: 선택된 장소 표시 + 수정/삭제 버튼
            if !viewModel.isLocationExpanded {
                collapsedView
            }
            
            // 확장 상태: 검색 바 + 내 장소 목록 + 취소 버튼
            if viewModel.isLocationExpanded {
                expandedView
            }
        }
    }
    
    // MARK: - Collapsed View
    private var collapsedView: some View {
        HStack(spacing: 8) {
            Text(viewModel.location.isEmpty ? "장소를 선택하세요" : viewModel.location)
                .font(.medium14)
                .foregroundColor(viewModel.location.isEmpty ? .gray2 : .black)
            
            Spacer()
            
            EditButton(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    viewModel.isLocationExpanded = true
                }
            })
            
            if !viewModel.location.isEmpty {
                DeleteButton(action: {
                    viewModel.location = ""
                    viewModel.isLocationAIGenerated = false
                })
            }
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                viewModel.isLocationExpanded = true
            }
        }
    }
    
    // MARK: - Expanded View
    private var expandedView: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 검색 바
            HStack {
                TextField("장소를 검색하세요", text: $viewModel.locationSearchText)
                    .font(.medium12)
                    .foregroundColor(.black)
                
                Button(action: {
                    // 카카오 주소 검색 API 호출
                }) {
                    Image(systemName: "magnifyingglass")
                        .frame(width: 15.99, height: 15.99)
                        .foregroundColor(.gray2)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 36)
            .padding(.horizontal, 12)
            .background(Color.gray0)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color(red: 254/255, green: 254/255, blue: 254/255, opacity: 0.1), lineWidth: 1)
            )
            
            // 내 장소
            VStack(alignment: .leading, spacing: 12) {
                Text("내 장소")
                    .font(.regular12)
                    .foregroundColor(.gray2)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.myLocations) { location in
                            LocationButton(location: location) {
                                viewModel.location = location.name
                                viewModel.isLocationAIGenerated = false
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    viewModel.isLocationExpanded = false
                                }
                            }
                        }
                    }
                }
            }
            
            // 취소 버튼
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    viewModel.isLocationExpanded = false
                    viewModel.locationSearchText = ""
                }
            }) {
                Text("취소")
                    .font(.medium12)
                    .foregroundColor(.gray2)
                    .frame(maxWidth: .infinity)
                    .frame(height: 32)
                    .background(Color.gray0)
                    .cornerRadius(6)
            }
        }
        .padding(16)
        .background(Color.gray0.opacity(0.5))
        .cornerRadius(8)
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }
}

// MARK: - LocationButton Component
struct LocationButton: View {
    let location: MyLocation
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: location.icon)
                    .font(.system(size: 12))
                    .foregroundColor(location.color)
                
                Text(location.name)
                    .font(.regular12)
                    .foregroundColor(location.color)
            }
            .padding(.horizontal, 12)
            .frame(height: 32)
            .background(location.color.opacity(0.1))
            .cornerRadius(8)
        }
    }
}
