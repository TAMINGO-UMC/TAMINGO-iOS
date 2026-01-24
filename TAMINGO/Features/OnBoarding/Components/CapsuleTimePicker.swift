//
//  TimePicker.swift
//  TAMINGO
//
//  Created by 권예원 on 1/17/26.
//

import SwiftUI

// 캡슐 형태로 시간을 표시, 선택 시 UIDatePicker를 popover로 보여줌
struct CapsuleTimePicker: View {
    @Binding var date: Date
    @State private var showPicker = false
    let isSelected: Bool
    let backgroundColor: Color
    let highlightColor: Color
    
    let onTimeChanged: () -> Void

    var defaultBackgroundColor: Color = Color(
        red: 118/255,
        green: 118/255,
        blue: 128/255
    ).opacity(0.12)


    var body: some View {
        Button {
            showPicker = true
        } label: {
            Text(timeString)
                .font(.medium13)
                .foregroundStyle(isSelected ? highlightColor : .black)
                .padding(.horizontal, 8.7)
                .padding(.vertical, 4.74)
                .background(
                    Capsule()
                        .fill(
                            isSelected
                            ? backgroundColor
                            : defaultBackgroundColor
                        )
                )
                .overlay(
                    Capsule()
                        .stroke(isSelected ? highlightColor : .clear, lineWidth: 1)
                )
        }
        .popover(
            isPresented: $showPicker,
            attachmentAnchor: .rect(.bounds),
            arrowEdge: .top
        ) {
            UIKitTimePicker(date: $date)
                .frame(width: 260, height: 280)
                .presentationCompactAdaptation(.popover)
                .onChange(of: date) {
                    onTimeChanged()
                }
        }

    }

    private var timeString: String {
        let f = DateFormatter()
        f.dateFormat = "h:mm a"
        return f.string(from: date)
    }
}


// SwiftUI에서 UIDatePicker(wheels)를 사용하기 위한 래퍼
struct UIKitTimePicker: UIViewRepresentable {
    @Binding var date: Date

    func makeUIView(context: Context) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.tintColor = .label
        picker.addTarget(
            context.coordinator,
            action: #selector(Coordinator.changed),
            for: .valueChanged
        )
        return picker
    }

    func updateUIView(_ uiView: UIDatePicker, context: Context) {
        uiView.date = date
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject {
        let parent: UIKitTimePicker
        init(_ parent: UIKitTimePicker) {
            self.parent = parent
        }

        @objc func changed(_ sender: UIDatePicker) {
            parent.date = sender.date
        }
    }
}

#Preview {
    CapsuleTimePicker(
        date: .constant(Date()),
        isSelected: true,
        backgroundColor: .subMint,
        highlightColor: .mainMint,
        onTimeChanged: {}
    )
}
