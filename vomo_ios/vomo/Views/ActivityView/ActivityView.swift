//
//  ActivityView.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/7/22.
//

import SwiftUI

struct Activityiew: View {
    
    let next_img = "VM_next-nav-btn"
    let navArrowWidth = CGFloat(20)
    let navArrowHeight = CGFloat(25)
    
    var body: some View {
        VStack {
            ProfileButton()
            
            HStack {
                Text("Activity")
                    .font(Font.vomoTitle)
                Spacer()
            }
            
            HStack {
                Text("View activity over XXXXX lorem ipsomes")
                    .font(Font.vomoLightBodyText)
                    .foregroundColor(Color.BODY_COPY)
                Spacer()
            }
            
            HStack {
                Button(action: { }) {
                    Image(next_img)
                        .resizable()
                        .rotationEffect(Angle(degrees: 180))
                        .frame(width: navArrowWidth, height: navArrowHeight)
                }
                
                ZStack {
                    Color.BLUE.frame(width: 350, height: 325).cornerRadius(10)
                    Text("Graph display here").foregroundColor(.white)
                }
                
                Button(action: { }) {
                    Image(next_img)
                        .resizable()
                        .frame(width: navArrowWidth, height: navArrowHeight)
                }
            }
        }
    }
}
