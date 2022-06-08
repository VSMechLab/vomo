//
//  YesButton.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/18/22.
//

import SwiftUI

struct YesButton: ButtonStyle {
    let selected: Bool
    let select_img = "VM_Select-Btn-Prpl-Field"
    let unselect_img = "VM_Unselect-Btn-Gry-Field"
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Image(selected ? select_img : unselect_img)
                .resizable()
                .frame(height:  35)
            
            HStack {
                Text("Yes")
                    .font(._buttonFieldCopy)
                    .foregroundColor(selected ? Color.white : Color.BODY_COPY)
                    .padding(.leading, 26)
                
                Spacer()
            }
        }
    }
}
