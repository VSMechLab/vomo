//
//  VisitTypeRow.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/31/22.
//

import SwiftUI

struct VisitTypeRow: View {
    @EnvironmentObject var visits: Visits
    
    @State private var vm = HomeViewModel()
    @State private var droppedDown = false
    
    @FocusState private var focused: Bool
    
    @Binding var note: String
    @Binding var targetVisit: Date
    
    let visit: VisitModel
    let img: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                // CHANGED: add date to VStack to hold date and time
                VStack(alignment: .leading) {
                    // CHANGED: from .toStringDay()
                    Text("\(visit.date.toString(dateFormat: "MM/dd/yyyy"))")
                    // ADD: add font and size
                    
                    Text("\(visit.date.toString(dateFormat: "hh:mm a"))")
                    // ADD: add font and size
                }
                .padding(.trailing, 15)

                Text("\(visit.type)")
                    // ADD: add font and size
                
                Spacer()
                
                // ADD: add dropdown button
                
                Button(action: {
                    self.droppedDown.toggle()
                    if !droppedDown {
                        note = ""
                        targetVisit = visit.date
                        addNote(date: visit.date)
                    }
                }) {
                    Image(vm.arrow_img)
                        .resizable()
                        .rotationEffect(self.droppedDown ? Angle(degrees: 180.0) : Angle(degrees: 0.0))
                        .frame(width: 17.5, height: 10)
                        .padding(.horizontal, 5)
                }
                
                Button(action: {
                    self.droppedDown.toggle()
                    if !droppedDown {
                        note = ""
                        targetVisit = visit.date
                        addNote(date: visit.date)
                    }
                }) {
                    Image("_new-visit-icon-wh")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .background(Color.white)
                        .cornerRadius(3)
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
                            Text("Tap to edit")
                        }
                    } else {
                        Text("Add a note")
                    }
                    Spacer()
                }
                .padding(.horizontal, 3)
                
                if visit.note == "" {
                    TextEditor(text: self.$note)
                        .font(self.note.isEmpty ? ._fieldCopyItalic : ._fieldCopyRegular)
                        //.focused($focused)
                        .font(._fieldCopyRegular)
                        .padding(.leading, 5)
                        .frame(height: 100)
                } else {
                    HStack {
                        Text(visit.note)
                            .font(._fieldCopyRegular)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding(.leading, 5)
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
    }
    
    func addNote(date: Date) {
        var index = 0
        for visit in visits.visits {
            if visit.date == targetVisit {
                visits.visits[index].note = note
            }
            index += 1
        }
        index = 0
        for visit in visits.visits {
            if visit.date == targetVisit {
                print(visits.visits[index].note)
            }
            index += 1
        }
    }
}
