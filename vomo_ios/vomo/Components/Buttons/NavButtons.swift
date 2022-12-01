//
//  NavButtons.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/1/22.
//

import SwiftUI

struct BackButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 5) {
            Arrow()
                .rotationEffect(Angle(degrees:-180))
            configuration.label
                .foregroundColor(Color.DARK_PURPLE)
                .font(._pageNavLink)
        }
    }
}

struct NextButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 5) {
            configuration.label
                .foregroundColor(Color.DARK_PURPLE)
                .font(._pageNavLink)
            Arrow()
        }
    }
}

struct SkipButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 5) {
            configuration.label
                .foregroundColor(Color.BODY_COPY)
                .font(._pageNavLink)
            GrayArrow()
        }
    }
}

struct NavButtonView: View {
    var body: some View {
        VStack {
            Button("Back") {
                print("Button pressed!")
            }
            .buttonStyle(BackButton())
            
            Button("Next") {
                print("Button pressed!")
            }
            .buttonStyle(NextButton())
            
        }
    }
}

struct NavButtonView_Previews: PreviewProvider {
    static var previews: some View {
        NavButtonView()
    }
}
