//
//  InterventionView.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/2/22.
//

import SwiftUI

struct InterventionView: View {
    @EnvironmentObject var entries: Entries
    
    @State var newVisit = false
    @State private var submitAnimation = false
    
    let svm = SharedViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                header
                
                if self.newVisit {
                    NewVisitForm(submitAnimation: $submitAnimation, newVisit: $newVisit)
                } else {
                    VisitLog(newVisit: $newVisit)
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

extension InterventionView {
    private var header: some View {
        VStack(spacing: 0) {
            HStack {
                Text(newVisit ? "Add new visit" : "Visit Log")
                    .font(._subHeadline)
                Spacer()
            }.padding(5)
        }
    }
    
    private var animationSection: some View {
        ZStack {
            Color.gray
                .frame(width: 125, height: 125)
                .cornerRadius(10)
            
            VStack {
                Image(systemName: "checkmark")
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                    .padding(.vertical)
                Text("Visit Added!")
                    .foregroundColor(Color.white)
                    .font(._BTNCopy)
                    .padding(.bottom)
            }
        }
        .onAppear() {
            withAnimation(.easeOut(duration: 2.5)) {
                submitAnimation.toggle()
            }
        }
        .opacity(submitAnimation ? 0.6 : 0.0)
        .zIndex(1)
    }
    
    private var visitRow: some View {
        VStack {
            Text("teset")
        }
    }
}

struct InterventionView_Previews: PreviewProvider {
    static var previews: some View {
        InterventionView()
            .environmentObject(Entries())
    }
}
