//
//  YesButton.swift
//  VoMo
//
//  Created by Neil McGrogan on 8/10/22.
//

import SwiftUI

struct YesButton: ButtonStyle {
    let selected: Bool
    let select_img = "VM_Select-Btn-Prpl-Field"
    let unselect_img = "VM_Unselect-Btn-Gry-Field"
    
    @State private var svm = SharedViewModel()
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Image(selected ? select_img : unselect_img)
                .resizable()
                .scaledToFit()
            
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
