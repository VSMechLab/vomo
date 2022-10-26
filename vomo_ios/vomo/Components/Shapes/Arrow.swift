//
//  Arrow.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/7/22.
//

import SwiftUI

struct SmallArrow: View {
    let arrow_img = "VoMo-App-Assets_2"
    var body: some View {
        Group {
            Image(arrow_img)
                .resizable()
                .frame(width: 9.2, height: 18.4)
                //.rotationEffect(Angle(degrees: -90))
        }.frame(width: 23, height: 23)
    }
}

struct Arrow: View {
    let arrow_img = "VM_Dropdown-Btn"
    var body: some View {
        Group {
            Image(arrow_img)
                .resizable()
                .frame(width: 23, height: 11.5)
                .rotationEffect(Angle(degrees: -90))
        }.frame(width: 23, height: 23)
    }
}

struct Arrow_Previews: PreviewProvider {
    static var previews: some View {
        Arrow()
    }
}

struct GrayArrow: View {
    let arrow_img = "VoMo-App-Assets_2"
    var body: some View {
        Group {
            Image(arrow_img)
                .resizable()
                .rotationEffect(Angle(degrees: 0))
                .frame(width: 11.5, height: 23)
        }.frame(width: 23, height: 23)
    }
}

struct GrayArrow_Previews: PreviewProvider {
    static var previews: some View {
        SmallArrow()
    }
}
