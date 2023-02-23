//
//  TreatmentView.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/2/22.
//

import SwiftUI

struct TreatmentView: View {
    @EnvironmentObject var entries: Entries
    
    @State var newTreatment = false
    @State private var submitAnimation = false
    
    let svm = SharedViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                header
                
                if self.newTreatment {
                    NewTreatmentForm(submitAnimation: $submitAnimation, newTreatment: $newTreatment)
                } else {
                    TreatmentLog(newTreatment: $newTreatment)
                }
            }
            .frame(width: svm.content_width)
            .onAppear() {
                self.entries.getItems()
            }
            .padding()
            .background(Color.INPUT_FIELDS)
            .cornerRadius(15)
            .padding()
            
            if submitAnimation {
                animationSection
            }
        }
    }
}

extension TreatmentView {
    private var header: some View {
        VStack(spacing: 0) {
            HStack {
                Text(newTreatment ? "Add new treatment" : "Treatments")
                    .font(._subHeadline)
                Spacer()
            }.padding(5)
        }
    }
    
    private var animationSection: some View {
        VStack {
            Image(systemName: "checkmark")
                .font(.largeTitle)
                .foregroundColor(Color.white)
                .padding(.vertical)
            Text("Treatment Added!")
                .foregroundColor(Color.white)
                .font(._BTNCopy)
                .padding(.bottom)
        }
        .padding(25)
        .background( Color.gray.cornerRadius(10) )
        .onAppear() {
            withAnimation(.easeOut(duration: 2.5)) {
                submitAnimation.toggle()
            }
        }
        .opacity(submitAnimation ? 0.6 : 0.0)
        .zIndex(1)
    }
}

struct TreatmentView_Previews: PreviewProvider {
    static var previews: some View {
        TreatmentView()
            .environmentObject(Entries())
    }
}
