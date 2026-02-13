//
//  CalendarSyncView.swift
//  TAMINGO
//
//  Created by 권예원 on 2/4/26.
//

import SwiftUI


struct CalendarSyncView: View {

    @State private var vm = CalendarSyncViewModel(
        service: CalendarSyncService()
    )
    let onBack: () -> Void

    var body: some View {
        VStack(spacing:0){
            header
                .padding(.horizontal, 16)
            
            VStack(alignment:.leading, spacing: 12) {
                
                introText
                
                linkedCalendarCard


                GuideBoxView(
                    title: "동기화 안내",
                    description: """
    • 양방향 동기화: 타밍고와 외부 캘린더 간 실시간 동기화
    • 일정 생성, 수정, 삭제가 자동으로 반영됩니다
    • 캘린더별로 동기화 방향을 개별 설정할 수 있습니다
    """
                )

                Spacer()
            }
            .padding(16)

        }
        .padding(16)
        .navigationBarBackButtonHidden(true)
        .task {
            await vm.loadConnectionStatus()
        }
        
    }
    var header : some View {
        HStack(spacing: 14) {
            Button {
                onBack()
            } label: {
                Image("Previous_Chevron")
                    .resizable()
                    .frame(width: 5, height: 10)
            }
            
            Text("캘린더 연동")
                .font(.semiBold16)
                .foregroundStyle(.black00)
            
            Spacer()

        }
    }
    var introText: some View {
        Text("연동된 캘린더")
            .font(.regular12)
            .foregroundStyle(.gray2)
    }
}

private extension CalendarSyncView {

    var linkedCalendarCard: some View {
        VStack() {
            calendarInfoRow
                .padding(.bottom, 16)
            
            Rectangle()
                .fill(.gray0)
                .frame(height: 1)
                .padding(.bottom, 13)
            
            VStack(spacing: 8) {
//                toggleRow(
//                    title: "TAMINGO! → Apple 캘린더",
//                    isOn: $vm.syncToApple
//                )

                toggleRow(
                    title: "Apple 캘린더 → TAMINGO!",
                    isOn: Binding(
                        get: { vm.isLinked },
                        set: { newValue in
                            Task {
                                await vm.toggleLink(newValue)
                            }
                        }
                    )
                )
            }
            .padding(.bottom, 23)

        }
        .padding(16)
        .cardStyle()
    }
}

private extension CalendarSyncView {

    var calendarInfoRow: some View {
        HStack(spacing: 12) {

            Image("OnBoarding_calLogo")
                .resizable()
                .frame(width: 34, height: 34)
            VStack(alignment: .leading, spacing: 4) {
                Text("Apple 캘린더")
                    .font(.medium14)

                Text(vm.isLoading ? "동기화 중..." : (vm.isLinked ? "동기화 활성화" : "동기화 중지"))
                    .font(.regular12)
                    .foregroundColor(.mainMint)
            }

            Spacer()
        }
    }
}

private extension CalendarSyncView {

    func toggleRow(
        title: String,
        isOn: Binding<Bool>,
    ) -> some View {
        HStack {
            Text(title)
                .font(.regular12)
                .foregroundColor(.gray2)

            Spacer()

            ToggleButton(isOn: isOn)
        }
    }
}





#Preview {
    CalendarSyncView(onBack: {
        print("back")
    })
}
