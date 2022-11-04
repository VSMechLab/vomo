//
//  InterventionView.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/2/22.
//

import SwiftUI

// to do fix view

struct InterventionView: View {
    @EnvironmentObject var entries: Entries
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State private var date = Date()
    @State private var type = ""
    
    @State private var newVisit = false
    @State private var selected = "Upcoming"
    @State private var showCalendar = false
    @State private var showPicker = false
    
    @State private var note: String = ""
    
    @State private var showDate = false
    @State private var showTime = false
    
    @State private var submitAnimation = false
    
    @State private var targetVisit = Date()
    
    let visitTypes = ["Vocal cord injection", "Botulinum injection", "Office laser treatment", "Surgery", "Other"]
    
    let toggleHeight: CGFloat = 37 * 0.95
    
    let button_img = "VM_Gradient-Btn"
    let time_img = "_time-icon"
    let date_img = "_date-icon"
    let type_img = "_visit-type-icon"
    let arrow_img = "VM_Dropdown-Btn"
    
    let svm = SharedViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                header
                
                if self.newVisit {
                    newVisitForm
                } else {
                    visitLogs
                }
            }
            .frame(width: svm.content_width)
            .onAppear() {
                self.entries.getItems()
                for entry in entries.interventions {
                    print("Note: \(entry.note)")
                }
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
    
    private var newVisitForm: some View {
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
                    Image(date_img)
                        .resizable()
                        .scaledToFit()
                        .frame(height: toggleHeight * 0.8)
                        .padding(.leading)
                    Text(date == .now ? "Enter appointment date" : date.toString(dateFormat: "MM/dd/yyyy"))
                        .font(._fieldCopyRegular)
                    Spacer()
                }
                .padding(.vertical).frame(height: toggleHeight)
                .background(Color.white).cornerRadius(10)
            }
            
            ZStack {
                if showDate {
                    DatePicker("", selection: $date, in: Date.now..., displayedComponents: .date)
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
                    Image(time_img)
                        .resizable()
                        .scaledToFit()
                        .frame(height: toggleHeight * 0.8)
                        .padding(.leading)
                    Text(self.date.toStringHour())
                        .font(._fieldCopyRegular)
                    Spacer()
                }
                .padding(.vertical).frame(height: toggleHeight)
                .background(Color.white).cornerRadius(10)
            }
            
            ZStack {
                if showTime {
                    DatePicker("", selection: $date, displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                        .frame(maxWidth: 260, maxHeight: 175)
                        .clipped()
                }
            }
            .transition(.slide)
            
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
                    Image(type_img)
                        .resizable()
                        .scaledToFit()
                        .frame(height: toggleHeight * 0.8)
                        .padding(.leading)
                    Menu {
                        Picker("Choose One", selection: $type) {
                            ForEach(visitTypes, id: \.self) { visit in
                                Text("\(visit)")
                                    .font(._fieldCopyRegular)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(InlinePickerStyle())

                    } label: {
                        Text("\(type == "" ? "Choose Type" : type)")
                            .font(._fieldCopyRegular)
                    }
                    Spacer()
                }
                .padding(.vertical).frame(height: toggleHeight)
                .background(Color.white).cornerRadius(10)
            }
            
            Spacer()
            
            if !showDate && !showTime && self.type != "" {
                Button(action: {
                    submitAnimation = true
                    self.entries.interventions.append(InterventionModel(date: self.date, type: self.type, note: ""))
                    self.newVisit.toggle()
                    print(entries.interventions)
                }) {
                    ZStack {
                        Image(button_img)
                            .resizable()
                            .scaledToFit()
                        
                        Text("Save")
                            .font(._BTNCopy)
                            .foregroundColor(Color.white)
                    }
                    .padding(.horizontal)
                }
            } else if !showDate && !showTime && self.type == "" {
                ZStack {
                    Image(button_img)
                        .resizable()
                        .scaledToFit()
                    
                    Text("Save")
                        .font(._BTNCopy)
                        .foregroundColor(Color.INPUT_FIELDS)
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var visitLogs: some View {
        VStack {
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
                        self.selected = svm.upcoming
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
                        self.selected = svm.past
                    }
                }
            }
            .font(._fieldLabel)
            
            
            Group {
                if selected == svm.upcoming {
                    ScrollView(showsIndicators: false) {
                        ForEach(entries.interventions.reversed()) { visit in
                            if visit.date > .now {
                                VisitTypeRow(note: self.$note, targetVisit: self.$targetVisit, visit: visit, img: ""/*svm.plus_button*/)
                            }
                        }
                    }
                    .font((._fieldLabel))
                    .frame(maxHeight: 250)
                } else {
                    ScrollView(showsIndicators: false) {
                        ForEach(entries.interventions.reversed()) { visit in
                            if visit.date < .now {
                                VisitTypeRow(note: self.$note, targetVisit: self.$targetVisit, visit: visit, img: ""/*svm.plus_button*/)
                            }
                        }
                    }
                    .font((._fieldLabel))
                    .frame(maxHeight: 250)
                }
            }
            
            Spacer()
            
            Button("+ NEW VISIT") {
                withAnimation() { self.newVisit.toggle() }
            }.buttonStyle(SubmitButton())
            .padding(.top, 5)
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
            .environmentObject(ViewRouter())
    }
}

struct VisitTypeRow: View {
    @EnvironmentObject var entries: Entries
    @State private var droppedDown = false
    
    @FocusState private var focused: Bool
    
    @Binding var note: String
    @Binding var targetVisit: Date
    
    let visit: InterventionModel
    let img: String
    let svm = SharedViewModel()
    
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
                    withAnimation() {
                        self.droppedDown.toggle()
                    }
                    if !droppedDown {
                        note = ""
                        targetVisit = visit.date
                        //addNote(date: visit.date)
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
                
                /*
                if visit.note == "" {
                    
                } else {
                    HStack {
                        Text(visit.note)
                            .font(._fieldCopyRegular)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding(.leading, 5)
                }
                */
                
                
                
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

/*
 Button(action: {
     withAnimation() {
         self.droppedDown.toggle()
     }
     if !droppedDown {
         note = ""
         targetVisit = visit.date
     }
 }) {
     Image("_new-visit-icon-wh")
         .resizable()
         .frame(width: 20, height: 20)
         .background(Color.white)
         .cornerRadius(3)
 }
 */
