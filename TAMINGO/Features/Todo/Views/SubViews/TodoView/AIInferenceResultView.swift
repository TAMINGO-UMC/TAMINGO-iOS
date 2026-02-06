
import SwiftUI

struct AIInferenceResultView: View {
    let result: AIInferenceResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 헤더
            HStack(spacing: 4) {
                Text("💡")
                Text("AI 추론")
                    .font(.regular12)
                    .foregroundColor(.black)
                
                Spacer()
            }
            
            // 카테고리
            HStack {
                Text("카테고리")
                    .font(.regular12)
                    .foregroundColor(.black)
                
                Spacer()
                
                Text(result.category)
                    .font(.regular10)
                    .foregroundColor(.black)
            }
            
            // 추론 장소
            HStack {
                Text("추론 장소")
                    .font(.regular12)
                    .foregroundColor(.black)
                
                Spacer()
                
                Text(result.locationDisplay)
                    .font(.regular10)
                    .foregroundColor(.black)
            }
            
            // 예상 소요
            HStack {
                Text("예상 소요")
                    .font(.regular12)
                    .foregroundColor(.black)
                
                Spacer()
                
                Text(result.durationDisplay)
                    .font(.regular10)
                    .foregroundColor(.black)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.subMint, Color.subPink]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.mainMint, lineWidth: 1)
        )
        .cornerRadius(5)
    }
}

#Preview {
    AIInferenceResultView(
        result: AIInferenceResult(
            category: "일상",
            placeName: "광운대학교 중앙도서관",
            address: "서울 노원구 광운로 20",
            latitude: 37.6192404638865,
            longitude: 127.058270608867,
            duration: 10
        )
    )
    .padding()
}
