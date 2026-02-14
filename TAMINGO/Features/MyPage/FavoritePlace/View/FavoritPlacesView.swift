//
//  FrequentPlacesView.swift
//  TAMINGO
//
//  Created by 권예원 on 2/4/26.
//

import SwiftUI

struct FavoritPlacesView: View {

    @State private var vm = FavoritePlacesViewModel()
    @State private var isPlaceSearchPresented = false

    @Environment(\.dismiss) private var dismiss // 시트 용
    let onBack: () -> Void
    

    var body: some View {
        VStack(spacing: 0) {

            header
                .padding(.horizontal, 16)

            ScrollView {
                VStack(spacing: 12) {

                    ForEach(vm.places, id: \.id) { place in
                        FrequentPlaceRowView(
                            place: PlaceUIModel(place: place),
                            onEdit: {
                                vm.editPlace(place)
                                isPlaceSearchPresented = true
                            },
                            onDelete: {
                                Task { await vm.deletePlace(place) }
                            }
                        )
                    }

                    GuideBoxView(
                        title: "자주 가는 장소 활용",
                        description: """
        • 일정, 할 일 입력 시 장소를 자동으로 추천합니다
        • 이동 경로 계산 시 우선 사용됩니다
        • AI가 방문 패턴을 학습하여 자동 제안합니다
        """
                    )
                }
                .padding(16)
            }
        }
        .padding(16)
        .sheet(isPresented: $isPlaceSearchPresented) {
            PlaceSearchSheet(
                editingPlace: vm.editingPlace
            ) { place in
                Task {
                    await vm.savePlace(place)
                    isPlaceSearchPresented = false
                }
            }
            .presentationDetents([.height(701)])
            .presentationBackground(.white)
        }
        .task {
            await vm.fetchPlaces()
        }
        .navigationBarBackButtonHidden(true)

    }

    private var header: some View {
        HStack(spacing: 14) {
            Button {
                onBack()
            } label: {
                Image("Previous_Chevron")
                    .resizable()
                    .frame(width: 5, height: 10)
            }
            
            Text("자주 가는 장소")
                .font(.semiBold16)
                .foregroundStyle(.black00)
            
            Spacer()
            
            Button {
                vm.editPlace(nil)
                isPlaceSearchPresented = true
            } label: {
                Image("MyPage_icon_plus")
                    .resizable()
                    .frame(width: 13, height: 13)
                    .padding(6)
                    .background(.mainMint)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
        }
    }
}

#Preview {
    FavoritPlacesView(onBack: { print("back")})
}
