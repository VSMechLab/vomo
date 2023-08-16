//
//  TreatmentRow.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/29/22.
//

import SwiftUI

/// Contains a row of a treatment
/// Displays basic information and allows editiing of treatments
struct TreatmentRow: View {
    @EnvironmentObject var entries: Entries
    @State private var droppedDown = false
    
    @FocusState private var focused: Bool
    
    @Binding var note: String
    @Binding var targetTreatment: Date
    
    let treatment: TreatmentModel
    let img: String
    let svm = SharedViewModel()
    
    @State var deletionTarget: (Date, String) = (.now, "")
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Button(action: {
                    withAnimation() {
                        self.droppedDown.toggle()
                    }
                }) {
                    HStack(spacing: 0) {
                        VStack {
                            HStack {
                                Text("\(treatment.date.dayOfWeek())")
                                Spacer()
                            }
                            .font(._fieldCopyBold)
                            HStack {
                                Text("\(treatment.date.toDOB())")
                                Spacer()
                            }
                            .font(._fieldCopyRegular)
                        }
                        .padding(.trailing, 12)
                        .frame(maxWidth: 95)

                        Text("\(treatment.type)")
                        
                        Spacer()
                        
                        Arrow()
                            .rotationEffect(self.droppedDown ? Angle(degrees: 90.0) : Angle(degrees: 0.0))
                            .padding(.horizontal, 5)
                            .transition(.slide)
                    }
                    .padding(.horizontal, 3)
                    .foregroundColor(Color.gray)
                    .cornerRadius(5)
                }
                
                if droppedDown {
                    Color.gray.frame(height: 1)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 3)
                    
                    HStack {
                        Text("\(treatment.date.toString(dateFormat: "hh:mm a"))")
                        Spacer()
                        AltDeleteButton(deletionTarget: $deletionTarget, type: "Treatment", date: treatment.date)
                    }
                    
                    HStack {
                        if treatment.note == "" {
                            Button(action: {
                                treatment.note = ""
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
                            addNote(date: treatment.date, change: change)
                        }
                        .onAppear() {
                            note = treatment.note
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
        .onAppear() {
            note = ""
            targetTreatment = treatment.date
        }
    }
    
    /// System for adding/editing/removing notes
    func addNote(date: Date, change: String) {
        var index = 0
        for treatment in entries.treatments {
            if treatment.date == date {
                entries.treatments[index].note = change
            }
            index += 1
        }
        
        entries.saveTreatments()
    }
    
    /// Sensitive delete function, once performed cannot be recovered
    /// Searches through treatments for the proper one to delete matching by date
    func deleteAtDate(createdAt: Date) {
        
        Logging.defaultLog.notice("Deleting treatment at: \(deletionTarget.0), \(deletionTarget.1)")
                
        var type = ""
        var count = -1
        
        if type == "" && count == -1 {
            for index in 0..<entries.treatments.count {
                if createdAt == entries.treatments[index].date {
                    type = "Treatment"
                    count = index
                }
            }
        }
        
        if count != -1 {
            if type == "Treatment" {
                if entries.treatments[count].date == createdAt {
                    entries.treatments.remove(at: count)
                    count = -1
                }
            } else {
                Logging.defaultLog.error("There was a mismatch in data. In order to prevent erroneous deletion of data we have disabled the functionality of deleting this specific entry.")
            }
        }
    }
}

extension TreatmentRow {
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

struct TreatmentRow_Previews: PreviewProvider {
    static var previews: some View {
        TreatmentRow(note: .constant(""), targetTreatment: .constant(.now), treatment: TreatmentModel(date: .now, type: "", note: ""), img: "")
    }
}
