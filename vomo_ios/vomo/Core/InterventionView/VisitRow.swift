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
    
    @State var deletionTarget: (Date, String) = (.now, "")
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    // CHANGED: add date to VStack to hold date and time
                    Text("\(visit.date.toString(dateFormat: "MM/dd/yyyy"))")
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
                        Text("\(visit.date.toString(dateFormat: "hh:mm a"))")
                        Spacer()
                        AltDeleteButton(deletionTarget: $deletionTarget, type: "intervention", date: targetVisit)
                    }
                    
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
            
            VStack(spacing: 0) {
                Spacer()
                if focused {
                    Button(action: {
                        focused = false
                    }) {
                        HStack {
                            Spacer()
                            Text("DONE")
                                .font(._bodyCopyBold)
                                .foregroundColor(Color.DARK_PURPLE)
                                .padding(5)
                                .background(Color.INPUT_FIELDS)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.5), radius: 2)
                                .padding(2)
                                .padding(.bottom, -10)
                        }
                    }
                }
            }
            
            if deletionTarget.1 != "" {
                deletePopUpSection
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
    
    /// Sensitive delete function, once performed cannot be recovered
    /// Seaches through interventions for the proper one to delete matching by date
    func deleteAtDate(createdAt: Date) {
        print("delete at \(deletionTarget.0), \(deletionTarget.1)")
        
        var type = ""
        var count = -1
        
        if type == "" && count == -1 {
            for index in 0..<entries.interventions.count {
                if createdAt == entries.interventions[index].date {
                    type = "survey"
                    count = index
                }
            }
        }
        
        if count != -1 {
            if type == "intervention" {
                if entries.interventions[count].date == createdAt {
                    
                    entries.interventions.remove(at: count)
                    print("deleting intervention")
                }
            } else {
                print("There was a mismatch in data. In order to prevent erroneous deletion of data we have disabled the functionality of deleting this specific entry.")
            }
        }
    }
}

extension VisitRow {
    private var deletePopUpSection: some View {
        ZStack {
            Color.white
                .frame(width: svm.content_width * 0.7, height: 200)
                .shadow(color: Color.gray, radius: 1)
            
            VStack(alignment: .leading) {
                Text("Confim you would like to delete this entry")
                    .font(._bodyCopyLargeMedium)
                    .multilineTextAlignment(.leading)
                Text("\(deletionTarget.1) at: \(deletionTarget.0.toStringDay())")
                    .font(._bodyCopy)
                    .multilineTextAlignment(.leading)
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        deletionTarget.0 = .now
                        deletionTarget.1 = ""
                    }) {
                        Text("Cancel")
                            .foregroundColor(Color.red)
                            .font(._bodyCopyMedium)
                    }
                    Spacer()
                    Button(action: {
                        deleteAtDate(createdAt: deletionTarget.0)
                        deletionTarget.0 = .now
                        deletionTarget.1 = ""
                    }) {
                        Text("Yes")
                            .foregroundColor(Color.green)
                            .font(._bodyCopyMedium)
                    }
                    Spacer()
                }
                .padding()
            }.padding(5)
            
                .frame(width: svm.content_width * 0.7, height: 200)
        }
    }
}

struct VisitRow_Previews: PreviewProvider {
    static var previews: some View {
        VisitRow(note: .constant(""), targetVisit: .constant(.now), visit: InterventionModel(date: .now, type: "", note: ""), img: "")
    }
}
