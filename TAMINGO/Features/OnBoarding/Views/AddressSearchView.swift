//
//  AddressSearchWebView.swift
//  TAMINGO
//
//  Created by 권예원 on 1/28/26.
//

import SwiftUI

struct AddressSearchView: View {

    @State private var vm = PlaceSearchViewModel()
    let onSelect: (AddressDocument) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            searchBar

            if vm.query.isEmpty {
                tipView
            } else {
                resultList
            }

            Spacer()
        }
    }
}

private extension AddressSearchView {
    var tipView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("tip")
                .font(.semiBold14)

            Text("아래와 같은 조합으로 검색을 하시면 더욱 정확한 결과가\n검색됩니다.")
                .font(.regular12)

            VStack(alignment: .leading, spacing: 13) {
                tipItem("도로명 + 건물번호", "판교역로 166")
                tipItem("지역명(동/리) + 번지", "백현동 532")
                tipItem("지역명 + 건물명", "분당 주공")
                tipItem("사서함명 + 번호", "분당우체국사서함 1-100")
            }
        }
        .padding(.top, 39)
    }

    func tipItem(_ title: String, _ example: String) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(title)
                .font(.regular12)
            Text("예) \(example)")
                .font(.regular10)
                .foregroundColor(.blue)
        }
    }
}


private extension AddressSearchView {
    var searchBar: some View {
        VStack{
            HStack {
                TextField(
                    "예) 판교역 166, 분당 주공, 백현동 532",
                    text: $vm.query
                )
                .font(.medium14)
                .onChange(of: vm.query) {
                    vm.search()
                }

                if !vm.query.isEmpty {
                    Button {
                        vm.reset()
                    } label: {
                        Image("OnBoarding_icon_searchX")
                            .resizable()
                            .frame(width: 20, height: 20)
                            
                    }
                } else {
                    Image("OnBoarding_icon_search")
                        .resizable()
                        .frame(width: 28, height: 28)
                }
            }
            Rectangle()
                .frame(height: 1)
                .foregroundColor(vm.query.isEmpty ? .gray1 : .black00)
        }
    }
}

private extension AddressSearchView {
    var resultList: some View {
        List(vm.results) { doc in
            Button {
                onSelect(doc)
            } label: {
                HStack {
                    Text(doc.address_name)
                        .font(.regular12)
                        .foregroundColor(.black00)

                    Spacer()

                    Image("OnBoarding_icon_arrowup")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                
            }
            .listRowSeparator(.hidden, edges: .top)
            .listRowSeparator(.visible)
            .listRowInsets(
                EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0)
            )
        }
        .listStyle(.plain)
    }
}

#Preview {
    AddressSearchView { document in
        print("선택된 주소:", document.address_name)
    }
}
