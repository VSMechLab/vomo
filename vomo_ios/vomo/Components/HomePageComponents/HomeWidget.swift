//
//  HomeWidget.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/8/22.
//

import SwiftUI

struct HomeWidget: View {
    let widget_img = "VM_7-cover-banner-img2"
    var body: some View {
        ZStack {
            Image(widget_img)
                .resizable()
            
            VStack(spacing: 0) {
                Spacer()
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing.")
                    .font(Font.vomoHeader)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
            }
        }.frame(width: 317.5, height: 155)
    }
}
