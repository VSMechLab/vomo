//
//  NoButton.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/8/22.
//

import SwiftUI

struct NoButton: ButtonStyle {
    let selected: Bool
    let select_img = "VM_Select-Btn-Prpl-Field"
    let unselect_img = "VM_Unselect-Btn-Gry-Field"
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Image(selected ? unselect_img : select_img)
                .resizable()
                .frame(height:  35)
            
            HStack {
                Text("No")
                    .font(Font.vomoButtons)
                    .foregroundColor(selected ? Color.BODY_COPY : Color.white)
                    .padding(.leading, 26)
                
                Spacer()
            }
        }
    }
}
