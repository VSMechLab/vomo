//
//  NewVisitForm.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/29/22.
//

import SwiftUI

/// Form that when filled out will persistently save a new intervention/visit
struct NewVisitForm: View {
    @EnvironmentObject var entries: Entries
    @FocusState private var focused: Bool
    
    @State private var visit: InterventionModel = InterventionModel(date: Date(), type: "", note: "")
    
    @State private var showDate = false
    @State private var showTime = false
    
    @Binding var submitAnimation: Bool
    @Binding var newVisit: Bool
    
    let toggleHeight: CGFloat = 39
    let svm = SharedViewModel()
    let visitTypes = ["Vocal cord injection", "Botulinum injection", "Office laser treatment", "Surgery", "Other"]
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                HStack {
                    Text("Date")
                        .font(._subsubHeadline)
                    Spacer()
                }
                
                Button(action: {
                    withAnimation() {
                        self.showTime = false
                        self.showDate.toggle()
                    }
                }) {
                    HStack {
                        Image(svm.date_img)
                            .resizable()
                            .scaledToFit()
                            .frame(height: toggleHeight * 0.8)
                            .padding(.leading)
                        Text(visit.date == .now ? "Enter appointment date" : visit.date.toString(dateFormat: "MM/dd/yyyy"))
                            .font(._fieldCopyRegular)
                        Spacer()
                    }
                    .padding(.vertical).frame(height: toggleHeight)
                    .background(Color.white).cornerRadius(10)
                }
                
                ZStack {
                    if showDate {
                        DatePicker("", selection: $visit.date, in: Date.now..., displayedComponents: .date)
                            .datePickerStyle(WheelDatePickerStyle())
                            .frame(maxWidth: 260, maxHeight: 175)
                            .clipped()
                    }
                }
                .transition(.slide)
                
                HStack {
                    Text("Time")
                        .font(._subsubHeadline)
                    Spacer()
                }
                
                Button(action: {
                    withAnimation() {
                        self.showDate = false
                        self.showTime.toggle()
                    }
                }) {
                    HStack {
                        Image(svm.time_img)
                            .resizable()
                            .scaledToFit()
                            .frame(height: toggleHeight * 0.8)
                            .padding(.leading)
                        Text(self.visit.date.toStringHour())
                            .font(._fieldCopyRegular)
                        Spacer()
                    }
                    .padding(.vertical).frame(height: toggleHeight)
                    .background(Color.white).cornerRadius(10)
                }
                
                ZStack {
                    if showTime {
                        DatePicker("", selection: $visit.date, displayedComponents: .hourAndMinute)
                            .datePickerStyle(WheelDatePickerStyle())
                            .frame(maxWidth: 260, maxHeight: 175)
                            .clipped()
                    }
                }
                .transition(.slide)
                
                Group {
                    HStack {
                        Text("Type")
                            .font(._subsubHeadline)
                        Spacer()
                    }
                    
                    Button(action: {
                        withAnimation() {
                            self.showDate = false
                            self.showTime = false
                        }
                    }) {
                        HStack {
                            Image(svm.type_img)
                                .resizable()
                                .scaledToFit()
                                .frame(height: toggleHeight * 0.8)
                                .padding(.leading)
                            Menu {
                                Picker("Choose One", selection: $visit.type) {
                                    ForEach(visitTypes, id: \.self) { visits in
                                        Text("\(visits)\n")
                                            .font(._fieldCopyRegular)
                                    }
                                }
                                .labelsHidden()
                                .pickerStyle(InlinePickerStyle())

                            } label: {
                                Text("\(visit.type.isEmpty ? "Choose Type" : visit.type)")
                                    .font(._fieldCopyRegular)
                            }
                            Spacer()
                        }
                        .padding(.vertical).frame(height: toggleHeight)
                        .background(Color.white).cornerRadius(10)
                    }
                }
                
                Group {
                    HStack {
                        Text("Add a note")
                            .font(._subsubHeadline)
                        Spacer()
                    }
                    
                    TextEditor(text: self.$visit.note)
                        .font(self.visit.note.isEmpty ? ._fieldCopyItalic : ._fieldCopyRegular)
                        .focused($focused)
                        .font(._fieldCopyRegular)
                        .padding(.leading, 5)
                        .frame(height: 100)
                        .onChange(of: visit.note) { change in
                            visit.note = change
                        }
                        .onAppear() {
                            visit.note = visit.note
                        }
                }
                
                Spacer()
                
                if !showDate && !showTime && self.visit.type != "" {
                    Button(action: {
                        submitAnimation = true
                        print("Selection is: \(visit.note)")
                        self.entries.interventions.append(visit)
                        self.newVisit.toggle()
                        self.visit.note = ""
                        print(entries.interventions)
                    }) {
                        ZStack {
                            Image(svm.button_img)
                                .resizable()
                                .scaledToFit()
                            
                            Text("Save")
                                .font(._BTNCopy)
                                .foregroundColor(Color.white)
                        }
                        .padding(.horizontal)
                    }
                } else if !showDate && !showTime && self.visit.type == "" {
                    ZStack {
                        Image(svm.button_img)
                            .resizable()
                            .scaledToFit()
                        
                        Text("Save")
                            .font(._BTNCopy)
                            .foregroundColor(Color.INPUT_FIELDS)
                    }
                    .padding(.horizontal)
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
}

struct NewVisitForm_Previews: PreviewProvider {
    static var previews: some View {
        NewVisitForm(submitAnimation: .constant(false), newVisit: .constant(true))
            .environmentObject(Entries())
    }
}
