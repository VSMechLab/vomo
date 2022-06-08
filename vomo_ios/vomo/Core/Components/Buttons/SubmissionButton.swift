//
//  SubmissionButton.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/18/22.
//

import SwiftUI

struct SubmissionButton: View {
    let button_img = "VM_Gradient-Btn"
    let label: String
    var body: some View {
        ZStack {
            Image(button_img)
                .resizable()
                .frame(width: 225, height: 40)
            
            Text(label)
                .font(._BTNCopy)
                .foregroundColor(Color.white)
        }
    }
}
