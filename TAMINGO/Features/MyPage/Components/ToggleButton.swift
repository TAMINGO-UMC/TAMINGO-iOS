//
//  ToggleButton.swift
//  TAMINGO
//
//  Created by 권예원 on 2/4/26.
//

import SwiftUI

struct SwitchToggleStyle: ToggleStyle {
    
    private let width: CGFloat = 43
    private let height: CGFloat = 24
    private let thumbSize: CGFloat = 20

    private let onColor: Color = .mainMint
    private let offColor: Color = .gray1

    func makeBody(configuration: Configuration) -> some View {
        let thumbOffset = (width - height) / 2

        return track(isOn: configuration.isOn)
            .overlay(
                thumb(isOn: configuration.isOn, offset: thumbOffset)
            )
            .contentShape(Rectangle())
            .onTapGesture {
                configuration.isOn.toggle()
            }
    }
}

private extension SwitchToggleStyle {

    func thumb(isOn: Bool, offset: CGFloat) -> some View {
        Circle()
            .fill(Color.white)
            .frame(width: thumbSize, height: thumbSize)
            .offset(x: isOn ? offset : -offset)
            .animation(.easeInOut(duration: 0.2), value: isOn)
    }
}


private extension SwitchToggleStyle {

    func track(isOn: Bool) -> some View {
        RoundedRectangle(cornerRadius: height / 2)
            .fill(isOn ? onColor : offColor)
            .frame(width: width, height: height)
    }
}




struct ToggleButton: View {

    @Binding var isOn: Bool

    var body: some View {
        Toggle("", isOn: $isOn)
            .labelsHidden()
            .toggleStyle(SwitchToggleStyle())
    }
}


#Preview {
    VStack{
        ToggleButton(isOn: .constant(true))
        ToggleButton(isOn: .constant(false))
    }
}
