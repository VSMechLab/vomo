//
//  VisitRow.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/29/22.
//

import SwiftUI

/// Contains a row of a visit
/// Displays basic information and allows editiing of visit/intervention
struct VisitRow: View {
    @EnvironmentObject var entries: Entries
    @State private var droppedDown = false
    
    @FocusState private var focused: Bool
    
    @Binding var note: String
    @Binding var targetVisit: Date
    
    let visit: InterventionModel
    let img: String
    let svm = SharedViewModel()
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    // CHANGED: add date to VStack to hold date and time
                    VStack(alignment: .leading) {
                        Text("\(visit.date.toString(dateFormat: "MM/dd/yyyy"))")
                        
                        Text("\(visit.date.toString(dateFormat: "hh:mm a"))")
                    }
                    .padding(.trailing, 15)

                    Text("\(visit.type)")
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation() {
                            self.droppedDown.toggle()
                        }
                        if !droppedDown {
                            note = ""
                            targetVisit = visit.date
                        }
                    }) {
                        Arrow()
                            .rotationEffect(self.droppedDown ? Angle(degrees: 90.0) : Angle(degrees: 0.0))
                            .padding(.horizontal, 5)
                            .transition(.slide)
                    }
                }
                .padding(.horizontal, 3)
                .foregroundColor(Color.gray)
                .cornerRadius(5)
                
                if droppedDown {
                    Color.gray.frame(height: 1)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 3)
                    
                    HStack {
                        if visit.note == "" {
                            Button(action: {
                                visit.note = ""
                            }) {
                                Text("Add a note")
                            }
                        } else {
                            Text("Add a note")
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 3)
                    
                    TextEditor(text: self.$note)
                        .font(self.note.isEmpty ? ._fieldCopyItalic : ._fieldCopyRegular)
                        .focused($focused)
                        .font(._fieldCopyRegular)
                        .padding(.leading, 5)
                        .frame(height: 100)
                        .onChange(of: note) { change in
                            addNote(date: visit.date, change: change)
                        }
                        .onAppear() {
                            note = visit.note
                        }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Done") {
                        focused = false
                    }
                    .font(._subHeadline)
                    .foregroundColor(Color.DARK_PURPLE)
                }
            }
            
            VStack {
                Spacer()
                if focused {
                    Button(action: {
                        focused = false
                    }) {
                        HStack {
                            Text("DONE")
                                .font(._bodyCopyBold)
                                .foregroundColor(Color.DARK_PURPLE)
                                .padding()
                                .background(Color.INPUT_FIELDS)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.5), radius: 1)
                                .padding()
                            Spacer()
                        }
                    }
                }
            }
        }
    }
    
    /// System for adding/editing/removing notes
    func addNote(date: Date, change: String) {
        var index = 0
        for visit in entries.interventions {
            if visit.date == date {
                entries.interventions[index].note = change
            }
            index += 1
        }
        
        entries.saveInterventions()
    }
}

struct VisitRow_Previews: PreviewProvider {
    static var previews: some View {
        VisitRow(note: .constant(""), targetVisit: .constant(.now), visit: InterventionModel(date: .now, type: "", note: ""), img: "")
    }
}
