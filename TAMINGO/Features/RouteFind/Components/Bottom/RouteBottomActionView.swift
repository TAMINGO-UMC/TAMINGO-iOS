//
//  RouteBottomActionView.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 2/8/26.
//

import SwiftUI

struct RouteBottomActionView: View {
    
    var onEndTap: (() -> Void)?
    
    var body: some View {
        VStack {
            Button {
                onEndTap?()
            } label: {
                Text("안내 종료")
                    .font(.semiBold14)
                    .foregroundStyle(Color("MainPink"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background{
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color("SubPink"))
                    }
                    .overlay{
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color("MainPink"), lineWidth: 1)
                    }
            }
        }
        .padding(.horizontal, 28)
        .padding(.bottom, 21)
        .background(Color.white)
    }
}

#Preview {
    RouteBottomActionView()
}
