//
//  Arrow.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/7/22.
//

import SwiftUI

struct Arrow: View {
    let arrow_img = "VM_Dropdown-Btn"
    var body: some View {
        Group {
            Image(arrow_img)
                .resizable()
                .frame(width: 20, height: 10)
                .rotationEffect(Angle(degrees: -90))
        }.frame(width: 20, height: 20)
    }
}

struct Arrow_Previews: PreviewProvider {
    static var previews: some View {
        Arrow()
    }
}
