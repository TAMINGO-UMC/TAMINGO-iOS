//
//  PeriodFilterView.swift
//  TAMINGO
//
//  Created by 권예원 on 2/1/26.
//

import SwiftUI

struct PeriodFilterView: View {
    
    @Bindable var vm: WeeklyReportViewModel
    
    var body: some View {
        HStack(spacing:3) {
            // 조회 기간 드롭다운
            Button(action: {
                vm.isPeriodListVisible.toggle()
            }, label: {
                Text("조회 기간")
                    .font(.regular12)
                    .foregroundStyle(.gray2)
                    .lineLimit(1)

                Image("MyPage_icon_chevronDown")
                    .resizable()
                    .frame(width: 20, height: 20)
                
            })
            Spacer()

            // 시작일
            DateBoxView(dateText: vm.startDateText)

            Text("~")
                .font(.regular12)
                .foregroundStyle(.gray2)

            // 종료일
            DateBoxView(dateText: vm.endDateText)
        }

    }

}

struct DateBoxView: View {
    let dateText: String

    var body: some View {
        HStack(spacing: 6) {
            Text(dateText)
                .font(.regular11)
                .foregroundStyle(.gray2)
                .frame(height:20)

            Image("MyPage_icon_cal")
                .resizable()
                .frame(width: 10.7, height: 10.1)
        }
        .frame(width: 98, height: 26)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.gray1, lineWidth: 1)
        )
    }
}


#Preview {
    PeriodFilterView(
        vm: WeeklyReportViewModel(
            baseDate: Date() // 오늘 기준
        )
    )
    .padding()
}

