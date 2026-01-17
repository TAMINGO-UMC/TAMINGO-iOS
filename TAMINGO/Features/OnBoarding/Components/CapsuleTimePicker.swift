//
//  TimePicker.swift
//  TAMINGO
//
//  Created by 권예원 on 1/17/26.
//

import SwiftUI

struct CapsuleTimePicker: View {
    @Binding var date: Date
    @State private var showPicker = false

    var body: some View {
        Button {
            showPicker = true
        } label: {
            Text(timeString)
                .font(.medium13)
                .foregroundStyle(.black)
                .padding(.horizontal, 8.7)
                .padding(.vertical, 4.74)
                .background(
                    Capsule()
                        .fill(
                            Color(
                                red: 118/255,
                                green: 118/255,
                                blue: 128/255
                            )
                            .opacity(0.12)
                        )
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
        }
    }

    private var timeString: String {
        let f = DateFormatter()
        f.dateFormat = "h:mm a"
        return f.string(from: date)
    }
}



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
    CapsuleTimePicker(date: .constant(Date()))
}
