
import SwiftUI

// MARK: - Related Schedule Container
struct RelatedScheduleContainer: View {
    @Binding var schedules: [RelatedScheduleItem]
    @Binding var isExpanded: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Schedule Rows (Divider 제거)
            ForEach(schedules.prefix(isExpanded ? schedules.count : 2)) { schedule in
                RelatedScheduleRow(schedule: binding(for: schedule))
            }
            
            // 일정 전체보기/추론된 일정만 보기 버튼
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Spacer()
                    
                    Text(isExpanded ? "추론된 일정만 보기" : "일정 전체보기")
                        .font(.regular12)
                        .foregroundColor(.gray2)
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 10))
                        .foregroundColor(.gray2)
                    
                    Spacer()
                }
                .frame(width: 309, height: 41.79)
            }
            .background(Color.white)
            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.06), radius: 6.89, x: 0, y: 2.3)
        }
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray1, lineWidth: 1)
        )
    }
    
    private func binding(for schedule: RelatedScheduleItem) -> Binding<RelatedScheduleItem> {
        guard let index = schedules.firstIndex(where: { $0.id == schedule.id }) else {
            fatalError("Schedule not found")
        }
        return $schedules[index]
    }
}
