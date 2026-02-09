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
            Text("조회 기간")
                .font(.regular12)
                .foregroundStyle(.gray2)
                .lineLimit(1)
            Spacer()
            
            // 조회 기간 드롭다운
            Button(action: {
                vm.isPeriodListVisible.toggle()
            }, label: {

                HStack(spacing: 10) {
                    Text(vm.selectedPeriodText)
                        .font(.regular11)
                        .foregroundStyle(.gray2)
                        .frame(height:20)

                    Image("MyPage_icon_chevronDown")
                        .resizable()
                        .frame(width: 10, height: 5)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 3)
                .frame(height: 26)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color(hex: "#FAFAFA"))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(hex: "#E5E5E5"))
                    )
            }
                
            )

        }

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

