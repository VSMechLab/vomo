//
//  Arrow.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/7/22.
//

import SwiftUI

struct SmallerArrow: View {
    let arrow_img = "VoMo-App-Assets_2"
    var body: some View {
        HStack {
            Spacer()
            Image(arrow_img)
                .resizable()
                .frame(width: 10, height: 16)
        }.frame(width: 16, height: 16)
        .scaleEffect(0.90)
    }
}

struct SmallArrow: View {
    let arrow_img = "VoMo-App-Assets_2"
    var body: some View {
        Group {
            Image(arrow_img)
                .resizable()
                .frame(width: 12, height: 18)
        }.frame(width: 18, height: 18)
        .scaleEffect(0.90)
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
