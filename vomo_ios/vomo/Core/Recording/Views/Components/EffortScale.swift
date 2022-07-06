//
//  EffortScale.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/18/22.
//

import SwiftUI

struct EffortScale: View {
    let scale_img = "VM_11-scale-bg-ds"
    let select_img = "VM_11-select-btn-ds"

    @Binding var position: Int
    
    @State private var svm = SharedViewModel()
    
    let prompt: Int
    
    var body: some View {
        ZStack {
            Image(scale_img)
                .resizable()
                .scaledToFit()
            
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    Color.green.opacity(0.2).frame(height: geometry.size.height / 2)
                    Color.blue.opacity(0.2).frame(height: geometry.size.height / 2)
                }
            }
        }.frame(width: svm.content_width)
    }
}

/*
ZStack {
    VStack {
        HStack(spacing: 0) {
            Text(prompt == 1 ? "How much physical effort did it take to make a voice?" : "How much mental effort did it take to make a voice?")
                .foregroundColor(Color.BODY_COPY)
            Spacer()
        }
        .font(._question)
        .multilineTextAlignment(.leading)
        
        Spacer()
    }.padding()
}

ZStack {
    VStack(spacing: 0) {
        Spacer()
        
        HStack(spacing: 0) {
            ForEach(0..<101) { index in
                Button(action: {
                    self.position = index
                    print("[EffortScale index] \(index)")
                }) {
                    Image(position == index ? select_img : "").resizable().frame(width: 28, height: 28)
                }
            }
        }
        .frame(width: svm.content_width - 30, alignment: .center)
        .padding(.bottom, 60)
    }
    
    VStack {
        Spacer()
        HStack {
            Text(prompt == 1 ? "Minimal effort,\neasy speaking" : "Minimal effort,\nno mental thought")
                .multilineTextAlignment(.leading)
            Spacer()
            Text(prompt == 1 ? "Maximal effort,\nhard to speak" : "Minimal effort,\ngreat mental thought")
                .multilineTextAlignment(.trailing)
        }
        .padding(.horizontal, 20)
        .font(.questionnaireScale)
        .foregroundColor(Color.BODY_COPY)
        .padding(.bottom, 20)
    }
}
*/
