//
//  VisitLog.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/29/22.
//

import SwiftUI

/// This is the log of visits/interventions that have occured or will occur in the future
/// It features an interface at the top allowing you to switch between upcoming or previous visits
/// These visits occuring in future or past are listed bellow
struct VisitLog: View {
    @EnvironmentObject var entries: Entries
    
    @Binding var newVisit: Bool
    
    @State private var selected = "Upcoming"
    @State private var note: String = ""
    @State private var targetVisit = Date()
    
    let svm = SharedViewModel()
    
    var body: some View {
        VStack {
            header
            
            visitList
            
            Spacer()
            
            newVisitButton
        }
        .onAppear() {
            entries.getItems()
        }
    }
}

extension VisitLog {
    /// Button/title to allow viewing of previous or past visits
    private var header: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading) {
                Text("Upcoming")
                    .foregroundColor(selected == svm.upcoming ? Color.black : Color.gray)
                    .padding(.leading, 2.5)
                if selected == svm.upcoming {
                    Color.TEAL.frame(height: 7)
                } else {
                    Color.gray.frame(height: 7)
                }
            }
            .onTapGesture {
                if selected != svm.upcoming {
                    withAnimation() {
                        self.selected = svm.upcoming
                    }
                }
            }
            
            VStack(alignment: .leading) {
                Text("Past")
                    .foregroundColor(selected == svm.past ? Color.black : Color.gray)
                    .padding(.leading, 2.5)
                if selected == svm.past {
                    Color.TEAL.frame(height: 7)
                } else {
                    Color.gray.frame(height: 7)
                }
            }
            .onTapGesture {
                if selected != svm.past {
                    withAnimation() {
                        self.selected = svm.past
                    }
                }
            }
        }
        .font(._fieldLabel)
        .transition(.opacity)
    }
    
    /// Button switches you to the new visit form
    private var newVisitButton: some View {
        Button("+ NEW INTERVENTION") {
            withAnimation() { self.newVisit.toggle() }
        }
        .buttonStyle(SubmitButton())
        .padding(.top, 5)
    }
    
    /// Displays visits in either the previous or the future form
    private var visitList: some View {
        ScrollView(showsIndicators: false) {
            ForEach(entries.interventions.reversed()) { visit in
                if visit.date > .now && selected == "Upcoming" {
                    VisitRow(note: self.$note, targetVisit: self.$targetVisit, visit: visit, img: ""/*svm.plus_button*/)
                } else if visit.date < .now && selected == "Past" {
                    VisitRow(note: self.$note, targetVisit: self.$targetVisit, visit: visit, img: ""/*svm.plus_button*/)
                }
            }
        }
        .font((._fieldLabel))
        .frame(minHeight: 250)
    }
}
struct VisitLog_Previews: PreviewProvider {
    static var previews: some View {
        VisitLog(newVisit: .constant(true))
            .environmentObject(Entries())
    }
}
