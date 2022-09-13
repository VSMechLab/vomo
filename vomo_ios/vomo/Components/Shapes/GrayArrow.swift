//
//  GrayArrow.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/9/22.
//

import SwiftUI

struct GrayArrow: View {
    let arrow_img = "VoMo-App-Assets_2"
    var body: some View {
        Group {
            Image(arrow_img)
                .resizable()
                .rotationEffect(Angle(degrees: 0))
                .frame(width: 10, height: 20)
        }.frame(width: 20, height: 20)
    }
}

struct GrayArrow_Previews: PreviewProvider {
    static var previews: some View {
        GrayArrow()
    }
}
