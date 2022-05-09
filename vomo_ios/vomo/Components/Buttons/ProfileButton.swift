//
//  ProfileButton.swift
//  VoMo
//
//  Created by Neil McGrogan on 4/12/22.
//

import SwiftUI

struct ProfileButton: View {
    @EnvironmentObject var viewRouter: ViewRouter
    let profile_img = "VM_7-avatar-photo-placeholder-gfx"
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            Button(action: {
                viewRouter.currentPage = .profileView
            }) {
                Image(profile_img)
                    .resizable().frame(width: 60, height: 60, alignment: .center)
            }
        }.frame(width: 317.5)
    }
}
