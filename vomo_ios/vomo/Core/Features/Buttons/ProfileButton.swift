//
//  ProfileButton.swift
//  VoMo
//
//  Created by Neil McGrogan on 4/12/22.
//

import SwiftUI

struct ProfileButton: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var svm = SharedViewModel()
    let profile_img = "VM_7-avatar-photo-placeholder-gfx"
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            Button(action: {
                viewRouter.currentPage = .home
            }) {
                Image(profile_img)
                    .resizable().frame(width: 60, height: 60, alignment: .center)
            }
        }
        .padding(.top, 4)
        .frame(width: svm.content_width)
    }
}
