//
//  RouteLinkCardView.swift
//  TAMINGO
//
//  Created by Jung Hyun Han on 1/28/26.
//

import SwiftUI

struct RouteLinkCardView: View {
    
    let routeLink: RouteLink
    let onVisitTap: () -> Void
    let onDeleteTap: () -> Void
    
    var body: some View {
        
        // 카드
        VStack(alignment: .leading, spacing: 12) {
            
            // 상단
            VStack(alignment: .leading, spacing: 6) {
                
                HStack(spacing: 8) {
                    Text(routeLink.title)
                        .font(.medium14)
                        .foregroundStyle(Color("Black00"))
                    
                    Text("동선 연계")
                        .font(.regular10)
                        .foregroundStyle(Color("SubBlue2"))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background{
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color("SubBlue1"))
                        }
                }
                
                HStack(spacing: 3) {
                    
                    Text(routeLink.location)
                    
                    Text("·")
                    
                    Text(routeLink.detourText)
                }
                .font(.regular10)
                .foregroundStyle(Color("Gray2"))
            }
            
            // 추천 문구
            Text("🚶 \(routeLink.suggestionText)")
                .font(.regular10)
                .foregroundStyle(Color("SubBlue2"))
            
            // 버튼
            HStack {
                Spacer()
                
                HStack(spacing: 12) {
                    Button("들르기", action: onVisitTap)
                        .buttonStyle(RouteVisitButtonStyle())
                    
                    Button("삭제", action: onDeleteTap)
                        .buttonStyle(RouteDeleteButtonStyle())
                }
            }
        }
        .padding(16)
        .background{
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.white)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color("SubBlue3"), lineWidth: 1)
        }
    }
}

// MARK: - Button Styles

private struct RouteVisitButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.regular12)
            .foregroundStyle(Color("Black00"))
            .padding(.horizontal, 9)
            .padding(.vertical, 4)
            .background{
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.white)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color("Gray1"), lineWidth: 0.5)
            }
            .opacity(configuration.isPressed ? 0.85 : 1)
    }
}

private struct RouteDeleteButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.regular12)
            .foregroundStyle(Color("MainPink"))
            .padding(.horizontal, 9)
            .padding(.vertical, 4)
            .background{
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color("SubPink"))
            }
            .opacity(configuration.isPressed ? 0.85 : 1)
    }
}


#Preview {
    RouteLinkCardView(
        routeLink: RouteLink(
            time: "12:30",
            title: "약 수령",
            location: "명동역 약국",
            detourText: "+2분 우회",
            suggestionText: "팀플 미팅 가는 길에 들를 수 있어요"
        ),
        onVisitTap: {},
        onDeleteTap: {}
    )
    .padding()
}

