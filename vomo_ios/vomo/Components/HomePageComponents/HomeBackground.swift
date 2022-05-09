//
//  HomeBackground.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/8/22.
//

import SwiftUI

struct HomeBackground: View {
    let background_img = "VM_7-cover-waves-gfx"
    
    var body: some View {
        VStack {
            Image(background_img)
                .resizable()
                .padding(.horizontal, -10)
                .frame(width: UIScreen.main.bounds.width + 10, height: 120)
            
            Spacer()
        }
    }
}
