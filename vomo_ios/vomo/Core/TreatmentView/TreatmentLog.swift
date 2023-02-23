//
//  TreatmentLog.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/29/22.
//

import SwiftUI

/// This is the log of treatments that have occured or will occur in the future
/// It features an interface at the top allowing you to switch between upcoming or previous treatment
/// These treatment occuring in future or past are listed bellow
struct TreatmentLog: View {
    @EnvironmentObject var entries: Entries
    
    @Binding var newTreatment: Bool
    
    @State private var note: String = ""
    @State private var targetTreatment = Date()
    
    let svm = SharedViewModel()
    
    var body: some View {
        VStack {
            header
            
            treatmentList
            
            Spacer()
            
            newTreatmentButton
        }
        .onAppear() {
            entries.getItems()
        }
    }
}

extension TreatmentLog {
    /// Button/title to allow viewing of previous or past treatment
    private var header: some View {
        Color.gray.frame(height: 7)
    }
    
    /// Button switches you to the new treatment form
    private var newTreatmentButton: some View {
        Button("+ NEW TREATMENT") {
            withAnimation() { self.newTreatment.toggle() }
        }
        .buttonStyle(SubmitButton())
        .padding(.top, 5)
    }
    
    /// Displays treatments in either the previous or the future form
    private var treatmentList: some View {
        ScrollView(showsIndicators: false) {
            ForEach(entries.treatments.reversed()) { treatment in
                TreatmentRow(note: self.$note, targetTreatment: self.$targetTreatment, treatment: treatment, img: "")
            }
        }
        .font((._fieldLabel))
        .frame(minHeight: 250)
    }
}
struct TreatmentLog_Previews: PreviewProvider {
    static var previews: some View {
        TreatmentLog(newTreatment: .constant(true))
            .environmentObject(Entries())
    }
}
