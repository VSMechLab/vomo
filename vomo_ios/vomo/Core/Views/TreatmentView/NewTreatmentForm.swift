//
//  NewTreatmentForm.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/29/22.
//

import SwiftUI

/// Form that when filled out will persistently save a new intervention/visit
struct NewTreatmentForm: View {
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var entries: Entries
    @FocusState private var focused: Bool
    
    @State private var treatment: TreatmentModel = TreatmentModel(date: Date(), type: "", note: "")
    
    @State private var showDate = false
    @State private var showTime = false
    @State private var type = ""
    
    @Binding var submitAnimation: Bool
    @Binding var newTreatment: Bool
    
    let toggleHeight: CGFloat = 39
    let svm = SharedViewModel()
    let treatmentTypes = ["Botulinum toxin injection", "Office laser treatment", "Surgery", "Vocal cord injection", "Voice therapy session", "Other"]
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
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
                            Text(treatment.date == .now ? "Enter appointment date" : treatment.date.toDOB())
                                .font(._fieldCopyRegular)
                            Spacer()
                        }
                        .padding(.vertical).frame(height: toggleHeight)
                        .background(Color.white).cornerRadius(10)
                    }
                    
                    ZStack {
                        if showDate {
                            DatePicker("", selection: $treatment.date, in: ...Date.now, displayedComponents: .date)
                                .datePickerStyle(.graphical)
                            //.datePickerStyle(Graphical())
                                .frame(maxWidth: 260, maxHeight: 500)
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
                            Text(self.treatment.date.toStringHour())
                                .font(._fieldCopyRegular)
                            Spacer()
                        }
                        .padding(.vertical).frame(height: toggleHeight)
                        .background(Color.white).cornerRadius(10)
                    }
                    
                    ZStack {
                        if showTime {
                            DatePicker("", selection: $treatment.date, displayedComponents: .hourAndMinute)
                                .datePickerStyle(WheelDatePickerStyle())
                                .frame(maxWidth: 260, maxHeight: 175)
                                .clipped()
                        }
                    }
                    .transition(.slide)
                    
                    chooseType
                    
                    Group {
                        HStack {
                            Text("Add a note")
                                .font(._subsubHeadline)
                            Spacer()
                        }
                        
                        TextEditor(text: self.$treatment.note)
                            .font(self.treatment.note.isEmpty ? ._fieldCopyItalic : ._fieldCopyRegular)
                            .focused($focused)
                            .font(._fieldCopyRegular)
                            .padding(.leading, 5)
                            .frame(height: 100)
                            .onChange(of: treatment.note) { change in
                                treatment.note = change
                            }
                            .onAppear() {
                                treatment.note = treatment.note
                            }
                        
                        Spacer()
                    }
                    
                    
                    if self.type != "" {
                        Button(action: {
                            submitAnimation = true
                            self.treatment.type = self.type
                            Logging.defaultLog.notice("Selection is: \(treatment.note, privacy: .private)")
                            self.entries.treatments.append(treatment)
                            self.newTreatment.toggle()
                            self.treatment.note = ""
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
                    } else if self.treatment.type == "" {
                        ZStack {
                            Image(svm.button_img)
                                .resizable()
                                .scaledToFit()
                            
                            Text("Save")
                                .font(._BTNCopy)
                                .foregroundColor(Color.INPUT_FIELDS)
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Button(action: {
                        self.newTreatment.toggle()
                        self.treatment.note = ""
                    }) {
                        ZStack {
                            Image(svm.blank_btn)
                                .resizable()
                                .scaledToFit()
                            
                            Text("Cancel")
                                .font(._BTNCopy)
                                .foregroundColor(Color.DARK_PURPLE)
                        }
                        .padding(.horizontal, 20)
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
        }
        .onChange(of: focused) { focus in
            settings.keyboardShown = focus
        }
    }
}

extension NewTreatmentForm {
    private var chooseType: some View {
        Group {
            HStack {
                Text("Type")
                    .font(._subsubHeadline)
                Spacer()
            }
            
            Menu {
                Picker("choose", selection: $type) {
                    ForEach(treatmentTypes, id: \.self) { type in
                        Text("\(type)")
                            .font(._fieldCopyRegular)
                            .frame(width: 250)
                    }
                }
                .labelsHidden()
                .pickerStyle(InlinePickerStyle())
                .onChange(of: type) { _ in
                    self.treatment.type = type
                }

            } label: {
                ZStack {
                    HStack {
                        Image(svm.type_img)
                            .resizable()
                            .scaledToFit()
                            .frame(height: toggleHeight * 0.8)
                            .padding(.leading)
                        Menu {
                            Picker("Choose One", selection: $treatment.type) {
                                ForEach(treatmentTypes, id: \.self) { treatments in
                                    Text("\(treatments)\n")
                                        .font(._fieldCopyRegular)
                                }
                            }
                            .labelsHidden()
                            .pickerStyle(InlinePickerStyle())
                        } label: {
                            HStack {
                                Text("\(type == "" ? "Choose Type" : type)")
                                    .font(._fieldCopyRegular)
                                Spacer()
                            }
                            .frame(width: 250)
                            .padding(.leading, type == "" ? 0 : -10)
                        }
                        Spacer()
                    }
                    .padding(.vertical).frame(height: toggleHeight)
                    .background(Color.white).cornerRadius(10)
                }
                .transition(.slide)
            }
        }
    }
}

struct NewTreatmentForm_Previews: PreviewProvider {
    static var previews: some View {
        NewTreatmentForm(submitAnimation: .constant(false), newTreatment: .constant(true))
            .environmentObject(Entries())
            .environmentObject(Settings())
    }
}
