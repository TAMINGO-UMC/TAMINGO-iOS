//
//  SetupView.swift
//  TAMINGO
//
//  Created by 권예원 on 1/16/26.
//

import SwiftUI



struct SetupView: View {
    let setupHeader = (
        title: "당신에게 딱 맞는\n하루를 설계 중입니다",
        subtitle: OnboardingSubtitle.none
    )
    
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var searchPlace :String = ""
    @State private var placeName : String = ""
 
    
    var body: some View {
        ScrollView{
            VStack(spacing:12){
                setStartTime
                setEndTime
                setPlaces
            }
            .padding(.horizontal, 30)
        }
    }
    
    var setStartTime : some View {
        HStack{
            Text("주요 활동 시작 시각")
                .font(.system(size: 16, weight: .bold))
            Spacer()
            DatePicker("", selection:$startTime, displayedComponents: .hourAndMinute)
        }
        .padding(.vertical, 13)
        .padding(.horizontal, 18)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray1, lineWidth: 1)
        )
    }
    
    var setEndTime : some View {
        HStack{
            Text("주요 활동 종료 시각")
                .font(.system(size: 16, weight: .bold))
            Spacer()
            DatePicker("", selection:$endTime, displayedComponents: .hourAndMinute)
        }
        .padding(.vertical, 13)
        .padding(.horizontal, 18)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray1, lineWidth: 1)
        )
    }
    
    var setPlaces : some View {
        VStack(spacing:11){
            HStack(spacing:5){
                Text("자주 가는 장소")
                    .font(.system(size: 16, weight: .bold))
                Text("(최대 5개)")
                    .font(Font.system(size: 12, weight: .regular))
                    .foregroundStyle(.gray2)
                Spacer()
            }
            HStack{
                
                TextField("도로명, 지번, 건물명 검색", text: $searchPlace)
                    .font(.system(size: 12))
                    .frame(width:162)
                Image("icon_Search")
                    .resizable()
                    .frame(width: 21.46, height: 21.46)
                Spacer()

                TextField("장소 이름", text: $placeName)
                    .frame(width:66, alignment: .trailing)

                
            }
        }
        .padding(.vertical, 13)
        .padding(.horizontal, 18)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray1, lineWidth: 1)
        )
    }
}

#Preview {
    SetupView()
}
