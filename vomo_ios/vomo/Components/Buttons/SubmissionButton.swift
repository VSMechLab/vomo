//
//  SubmissionButton.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/8/22.
//

import SwiftUI

struct SubmissionButton: ButtonStyle {
    let button_img = "VM_Gradient-Btn"
    let label: String
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Image(button_img)
                .resizable()
                .frame(width: 225, height: 40)
            
            Text(label)
                .font(Font.vomoHeader)
                .foregroundColor(Color.white)
        }
    }
}
