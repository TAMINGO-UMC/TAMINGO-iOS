//
//  FrequentPlacesView.swift
//  TAMINGO
//
//  Created by 권예원 on 2/4/26.
//

import SwiftUI

struct FrequentPlacesView: View {

    @State private var vm = FrequentPlacesViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {

            header
                .padding(.horizontal, 16)

            ScrollView {
                VStack(spacing: 12) {

                    ForEach(vm.places) { place in
                        FrequentPlaceRowView(
                            place: place,
                            onEdit: {
                                vm.editPlace(place)
                            },
                            onDelete: {
                                vm.deletePlace(place)
                            }
                        )
                    }

//                    GuidBox() // TODO: 캘린더 연동 브랜치 머지 후 추가
                }
                .padding(16)
            }
        }
        .padding(.horizontal, 16)
    }

    private var header: some View {
        HStack(spacing: 14) {
            Button {
                dismiss()
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
                /* 기능 준비 후 구현 예정 */
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
    FrequentPlacesView()
}
