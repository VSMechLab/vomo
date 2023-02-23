//
//  SubmissionButton.swift
//  VoMo
//
//  Created by Neil McGrogan on 8/10/22.
//

import SwiftUI

struct SubmitButton: ButtonStyle {
    let button_img = "VM_Gradient-Btn"
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Image(button_img)
                .resizable()
                .frame(width: 250, height: 46)
            
            configuration.label
                .font(._BTNCopy)
                .foregroundColor(Color.white)
        }
        .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        .animation(.easeInOut, value: configuration.isPressed)
    }
}

struct GraySubmitButton: ButtonStyle {
    let button_img = "VM_Gradient-Btn"
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Image(button_img)
                .resizable()
                .frame(width: 250, height: 46)
            
            configuration.label
                .font(._BTNCopyUnbold)
                .foregroundColor(Color.INPUT_FIELDS)
        }
    }
}

struct SubmitButtonView: View {
    var body: some View {
        Button("Press Me") {
            print("Button pressed!")
        }
        .buttonStyle(SubmitButton())
    }
}

struct SubmitButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SubmitButtonView()
    }
}
