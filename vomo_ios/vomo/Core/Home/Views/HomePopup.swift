//
//  HomePopup.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/31/22.
//

import SwiftUI

struct HomePopup: View {
    @EnvironmentObject var visits: Visits
    
    @Binding var visitPopup: Bool
    @State private var newVisit = false
    
    let exit_button = "VoMo-App-Assets_2_popup-close-btn"
    let plus_button = "VoMo-App-Assets_2_8-plus-btn"
    let button_img = "VM_Gradient-Btn"
    let upcoming = "Upcoming"
    let past = "past"
    let arrow_img = "VM_Dropdown-Btn"
    let entry_img = "VM_12-entry-field"
    
    @State private var selected = "Upcoming"
    @State private var date: Date = .now
    @State private var showCalendar = false
    @State private var showPicker = false
    var visitTypes = ["Office Visit", "Therapy Visit", "Office Procedure", "Surgery", "Other"]
    @State private var selectedVisit = ""
    
    var body: some View {
        VStack(spacing: 0) {
            verticalCancelSection
            HStack(spacing: 0) {
                horizontalCancelSection
                ZStack {
                    Color.white.frame(width: 325, height: 475)
                        .background(Color.white)
                        .shadow(color: Color.gray, radius: 0.9)
                    
                    VStack {
                        ZStack {
                            Color.INPUT_FIELDS.cornerRadius(10)
                            
                            VStack {
                                HStack {
                                    Text(newVisit ? "Add new visit" : "Visit Log")
                                        .font(._headline)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        withAnimation {
                                            self.visitPopup.toggle()
                                        }
                                    }) {
                                        Image(exit_button)
                                            .resizable()
                                            .frame(width: 17, height: 17)
                                    }
                                }.padding(5)
                                
                                VStack {
                                    if self.newVisit {
                                        newVisitSection
                                    } else {
                                        Button(action: {
                                            withAnimation() {
                                                self.newVisit.toggle()
                                            }
                                        }) {
                                            SubmissionButton(label: "+ NEW VISIT")
                                        }
                                        .padding(.top, 5)
                                        
                                        HStack(spacing: 0) {
                                            VStack(alignment: .leading) {
                                                Text("Upcoming")
                                                    .foregroundColor(selected == upcoming ? Color.black : Color.gray)
                                                if selected == upcoming {
                                                    Color.TEAL.frame(height: 7)
                                                } else {
                                                    Color.gray.frame(height: 7)
                                                }
                                            }
                                            .onTapGesture {
                                                if selected != upcoming {
                                                    self.selected = upcoming
                                                }
                                            }
                                            
                                            VStack(alignment: .leading) {
                                                Text("Past")
                                                    .foregroundColor(selected == past ? Color.black : Color.gray)
                                                if selected == past {
                                                    Color.TEAL.frame(height: 7)
                                                } else {
                                                    Color.gray.frame(height: 7)
                                                }
                                            }
                                            .onTapGesture {
                                                if selected != past {
                                                    self.selected = past
                                                }
                                            }
                                        }
                                        .font(._fieldLabel)
                                        .frame(width: 300)
                                        
                                        visitLog
                                    }
                                }
                                .transition(.slide)
                                
                            }.padding(.horizontal, 3)
                        }
                    }
                    .padding()
                    .frame(width: 325, height: 450)
                }
                horizontalCancelSection
            }
            verticalCancelSection
        }
        .onAppear() {
            visits.getItems()
        }
        .padding()
    }
}

extension HomePopup {
    private var newVisitSection: some View {
        VStack(alignment: .leading) {
            Text("Date of appointment")
                .font(._fieldLabel)
            
            Button(action: {
                withAnimation() {
                    self.showCalendar.toggle()
                }
            }) {
                HStack {
                    Text(date.toString(dateFormat: "MM/dd/yyyy"))
                        .font(._bodyCopy)
                    Spacer()
                    Image(arrow_img)
                        .resizable()
                        .frame(width: 20, height: 10)
                        .rotationEffect(Angle(degrees:  showCalendar ? 180 : 0))
                }.padding(.horizontal, 7)
            }
            .frame(height: 40)
            .background(Color.white)
            .cornerRadius(12)
            
            ZStack {
                if showCalendar {
                    DatePicker("", selection: $date, in: Date.now..., displayedComponents: .date)
                    // CHANGED: removed in: Date.now..., so dates can be selected before current date
                    DatePicker("", selection: $date, displayedComponents: .date)
                        .datePickerStyle(WheelDatePickerStyle())
                        .frame(maxWidth: 275, maxHeight: 200)
                        .frame(maxWidth: 275, maxHeight: 175) // CHANGED: adjusted height ot 175 from 200 to keep w/in bounds of pop up box
                        .clipped()
                }
            }
            .transition(.slide)
            
            Text("Appointment type")
                .font(._fieldLabel)
            
            HStack(spacing: 0) {
                Menu {
                    Picker("choose", selection: $selectedVisit) {
                        ForEach(visitTypes, id: \.self) { type in
                            Text(type)
                                .font(._fieldCopyRegular)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(InlinePickerStyle())
                } label: {
                    Text("\(selectedVisit == "" ? "Select appointment type" : selectedVisit)")
                        .font(._fieldCopyRegular)
                }
                .frame(maxHeight: 400)
                Spacer()
            }
            .padding(.horizontal, 5)
            .frame(height: 40)
            .background(Color.white)
            .cornerRadius(12)
            
            Spacer()
            
            HStack {
                Spacer()
                Button(action: {
                    withAnimation() {
                        self.newVisit.toggle()
                    }
                    visits.visits.append(VisitModel(date: date, visitType: selectedVisit))
                }) {
                    SubmissionButton(label: "SUBMIT")
                }
                Spacer()
            }
            .padding(.bottom)
        }
        .padding(.horizontal, 5)
        .padding(.top)
        .frame(width: 300)
    }
    
    private var visitLog: some View {
        Group {
            if selected == upcoming {
                ScrollView(showsIndicators: false) {
                    ForEach(visits.visits) { visit in
                        VisitTypeRow(visit: visit, img: plus_button)
                    }
                }
                .font((._fieldLabel))
            } else {
                ScrollView(showsIndicators: false) {
                    ForEach(visits.visits) { visit in
                        VisitTypeRow(visit: visit, img: plus_button)
                    }
                }
                .font((._fieldLabel))
            }
        }
    }
    
    private var verticalCancelSection: some View {
        Button(action: {
            self.visitPopup.toggle()
        }) {
            Color.white.opacity(0)
        }
    }
    
    private var horizontalCancelSection: some View {
        Button(action: {
            self.visitPopup.toggle()
        }) {
            Color.white.opacity(0).frame(height: 450)
        }
    }
}
