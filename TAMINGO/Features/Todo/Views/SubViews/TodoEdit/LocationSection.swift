//
//  LocationSection.swift
//  TAMINGO
//
//  Created by 엄지용 on 2/8/26.
//  Updated: async/await 호출 반영
//

import SwiftUI

struct LocationSection: View {
    @Binding var viewModel: TodoEditViewModel
    @State private var showingPlaceSearch = false
    
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
            
            // ✅ [수정] AI 추론 중일 때 로딩 UI 표시
            // viewModel.isInferringCategory 변수가 현재 AI 추론 전체 로딩 상태를 담당하고 있습니다.
            if viewModel.isInferringCategory {
                AILoadingRow(text: "장소 추론중 ...")
            } else {
                // 기존 로직 유지
                if !viewModel.isLocationExpanded {
                    collapsedView
                } else {
                    expandedView
                }
            }
        }
        .sheet(isPresented: $showingPlaceSearch) {
            PlaceSearchSheet { place in
                Task {
                    await viewModel.selectPlace(
                        name: place.name,
                        address: place.address,
                        latitude: place.latitude,
                        longitude: place.longitude
                    )
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        viewModel.isLocationExpanded = false
                    }
                    showingPlaceSearch = false
                }
            }
        }
    }
    
    // MARK: - Collapsed View
    private var collapsedView: some View {
        HStack(spacing: 8) {
            Text(viewModel.placeName.isEmpty ? "장소를 선택하세요" : viewModel.placeName)
                .font(.medium14)
                .foregroundColor(viewModel.placeName.isEmpty ? .gray2 : .black)
            
            Spacer()
            
            EditButton(action: {
                // ✅ 확장 시 내 장소 조회
                Task {
                    await viewModel.loadMyPlaces()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        viewModel.isLocationExpanded = true
                    }
                }
            })
            
            if !viewModel.placeName.isEmpty {
                DeleteButton(action: {
                    viewModel.placeName = ""
                    viewModel.address = nil
                    viewModel.latitude = nil
                    viewModel.longitude = nil
                    viewModel.isLocationAIGenerated = false
                })
            }
        }
        .onTapGesture {
            // ✅ 탭 시에도 내 장소 조회
            Task {
                await viewModel.loadMyPlaces()
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    viewModel.isLocationExpanded = true
                }
            }
        }
    }
    
    // MARK: - Expanded View
    private var expandedView: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 검색 바
            Button(action: {
                showingPlaceSearch = true
            }) {
                HStack {
                    Text(viewModel.locationSearchText.isEmpty ? "장소를 검색하세요" : viewModel.locationSearchText)
                        .font(.medium12)
                        .foregroundColor(viewModel.locationSearchText.isEmpty ? .gray2 : .black)
                    
                    Spacer()
                    
                    Image(systemName: "magnifyingglass")
                        .frame(width: 15.99, height: 15.99)
                        .foregroundColor(.gray2)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 36)
                .padding(.horizontal, 12)
                .background(Color.gray0)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(red: 254/255, green: 254/255, blue: 254/255, opacity: 0.1), lineWidth: 1)
                )
            }
            
            // 내 장소
            VStack(alignment: .leading, spacing: 12) {
                Text("내 장소")
                    .font(.regular12)
                    .foregroundColor(.gray2)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.myLocations, id: \.id) { location in
                            TodoLocationButton(location: location) {
                                Task {
                                    await viewModel.selectPlace(
                                        name: location.name,
                                        address: location.address,
                                        latitude: location.latitude,
                                        longitude: location.longitude
                                    )
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                        viewModel.isLocationExpanded = false
                                    }
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

// MARK: - TodoLocationButton (아이콘 제거, ID 기반 색상)
struct TodoLocationButton: View {
    let location: TodoMyLocation
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(location.name)
                .font(.regular12)
                .foregroundColor(location.color)
                .padding(.horizontal, 12)
                .frame(height: 32)
                .background(location.color.opacity(0.15))
                .cornerRadius(8)
        }
    }
}

struct PlaceInfo {
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
}
