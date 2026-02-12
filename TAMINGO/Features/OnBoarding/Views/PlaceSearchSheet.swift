//
//  PlaceSearchSheet.swift
//  TAMINGO
//
//  Created by 권예원 on 1/28/26.
//

import SwiftUI

enum PlaceSearchStep {
    case addressSearch      // 주소 검색
    case nameInput      // 장소 이름 입력
}

struct PlaceSearchSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var vm = PlaceSearchViewModel()
    let editingPlace: FavoritePlace?
    private var isEditMode: Bool {
        editingPlace != nil
    }
    let onAdd: (Place) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
                .padding(.top, 30)
                .padding(.horizontal, 30)
                .padding(.bottom, 22)

            switch vm.step {
            case .addressSearch:
                AddressSearchView { result in
                    vm.didSelectAddress(result)
                }
                .padding(.horizontal, 30)

            case .nameInput:
                PlaceNameInputView(vm: vm)
                    .padding(.horizontal, 30)
            }
            Spacer()
            Divider()
            buttons
        }
        .onAppear {
            if let place = editingPlace {
               vm.address = place.address
               vm.placeName = place.name
               vm.latitude = place.latitude
               vm.longitude = place.longitude
               vm.step = .nameInput
           } else {
               vm.reset()
           }
        }
    }

    private var header: some View {
        HStack{
            Text("장소 검색")
                .font(.semiBold18)
                .foregroundStyle(.black00)
            Spacer()
            Button(action: {
                dismiss()
            }, label: {
                Image("OnBoarding_icon_sheetX")
                    .resizable()
                    .frame(width: 20, height: 20)
            })
        }
    }

    private var buttons: some View {
        HStack {
            Button {
                vm.reset()
                dismiss()
            } label: {
                cancelButtonLabel
            }

            Button {
                if let place = vm.makePlace(editingPlace: editingPlace) {
                    onAdd(place)
                    vm.reset()
                }
            } label: {
                addButtonLabel
            }
            .disabled(!vm.canProceed)
        }
        .padding(.top, 10)
        .padding(.horizontal,46)
    }

    private var cancelButtonLabel: some View {
        Text("취소")
            .frame(maxWidth: .infinity)
            .frame(height: 47)
            .font(.semiBold14)
            .foregroundColor(.gray1)
            .background(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray1, lineWidth: 1)
            )
            .cornerRadius(5)

    }

    private var addButtonLabel: some View {
        Text(isEditMode ? "수정" : "장소추가")
            .frame(maxWidth: .infinity)
            .frame(height: 47)
            .font(.semiBold14)
            .foregroundColor(vm.canProceed ? .white : .gray2)
            .background(vm.canProceed ? .mainMint : .gray1)
            .cornerRadius(5)
    }
}


struct PlaceNameInputView : View {
    @Bindable var vm: PlaceSearchViewModel
    
    var body: some View {
        VStack{
            address
                .padding(.bottom, 29)
            inputPlaceName
        }
    }
    
    var address: some View {
        Button {
            vm.step = .addressSearch
        } label: {
            VStack(alignment: .leading) {
                Text(vm.address)
                    .foregroundStyle(.black00)
                    .font(.medium14)
                Divider()
            }
        }
    }
    
    var inputPlaceName : some View {
        VStack(alignment: .leading){
            HStack{
                Text("장소 이름")
                    .font(.medium14)
                Text("*")
                    .font(.medium14)
                    .foregroundStyle(.mainMint)
            }
            TextField("예) 집, 학교, 직장, 본가, 집 앞 카페", text: $vm.placeName)
                .font(.medium12)
                .padding(14)
                .background(.gray0)
                .cornerRadius(5)
        }
    }
}

//// 기본
//#Preview("Add Mode") {
//    PlaceSearchSheet(
//        editingPlace: nil
//    ) { place in
//        print("추가된 장소:", place)
//    }
//}

// 수정
#Preview("Edit Mode") {
    PlaceSearchSheet(
        editingPlace: FavoritePlace(
            id: 1,
            name: "집",
            address: "서울시 강남구 테헤란로 123",
            latitude: 37.123,
            longitude: 127.123,
            weeklyVisitCount: 5
        )
    ) { place in
        print("수정된 장소:", place)
    }
}

