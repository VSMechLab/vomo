//
//  ActivityView.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/7/22.
//

import SwiftUI

struct ActivityView: View {
    @ObservedObject var goal = GoalModel()
    
    @State private var page = 0
    @State private var goalOneSelect = false
    @State private var goalTwoSelect = false
    
    @State private var svm = SharedViewModel()
    
    let entry_img = "VM_12-entry-field"
    let entry_height: CGFloat = 37 * 0.95
    let next_img = "VM_next-nav-btn"
    let navArrowWidth = CGFloat(20)
    let navArrowHeight = CGFloat(25)
    let dropdown_img = "VM_Dropdown-Btn"
    let select_img = "VM_Select-Btn"
    let unselect_img = "VM_Unselect-Btn"
    
    let arrow_img = "VM_Dropdown-Btn"
    
    let perWeekOptions = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 10) {
                ProfileButton()
                
                Group {
                    Text("Activity")
                        .font(._headline)
                    
                    Text("View your weekly activity and make goals for yourself.")
                        .font(._bodyCopy)
                        .foregroundColor(Color.BODY_COPY)
                }
                
                ActivityGraph()
                
                Group {
                    Text("Goals")
                        .font(._headline)
                    
                    Text("Define your goals here.")
                        .font(._bodyCopy)
                        .foregroundColor(Color.BODY_COPY)
                    
                    perWeek
                    
                    numWeeks
                }
                
                Spacer()
            }
            .frame(width: svm.content_width)
        }
        .onAppear() {
            print(UIScreen.main.bounds.width)
        }.padding()
    }
}

extension ActivityView {
    private var perWeek: some View {
        Group {
            Text("Goal 1: Number of entries per week")
                .font(._fieldCopyRegular)
            ZStack {
                Image(entry_img)
                    .resizable()
                    .frame(height: entry_height)
                    .cornerRadius(7)
                
                HStack {
                    Menu {
                        Picker("2x week", selection: $goal.perWeek) {
                            ForEach(perWeekOptions, id: \.self) { option in
                                Text("\(option)")
                                    .font(._bodyCopy)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(InlinePickerStyle())

                    } label: {
                        HStack {
                            Text("\(goal.perWeek == 0 ? 0 : goal.perWeek)x per week")
                                .font(._bodyCopy)
                            Spacer()
                            Image(arrow_img)
                                .resizable()
                                .frame(width: 20, height: 10)
                                //.rotationEffect(Angle(degrees:   ? 180 : 0))
                        }
                    }
                    .frame(maxHeight: 400)
                }.padding(.horizontal, 5)
            }.frame(height: entry_height)
            
        }
    }
    
    private var numWeeks: some View {
        Group {
            Text("Goal 2: Number of weeks to achieve goal")
                .font(._fieldCopyRegular)
            
            ZStack {
                Image(entry_img)
                    .resizable()
                    .frame(height: entry_height)
                    .cornerRadius(7)
                
                HStack {
                    Menu {
                        Picker("2x week", selection: $goal.numWeeks) {
                            ForEach(perWeekOptions, id: \.self) { option in
                                HStack {
                                    Text("\(option)")
                                        .font(._bodyCopy)
                                }
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(InlinePickerStyle())

                    } label: {
                        HStack {
                            Text(goal.numWeeks == 1 ? "\(goal.numWeeks == 0 ? 0 : goal.numWeeks) week" : "\(goal.numWeeks == 0 ? 0 : goal.numWeeks) weeks")
                                .font(._bodyCopy)
                            Spacer()
                            Image(arrow_img)
                                .resizable()
                                .frame(width: 20, height: 10)
                                //.rotationEffect(Angle(degrees:   ? 180 : 0))
                        }
                    }
                    .frame(maxHeight: 400)
                }.padding(.horizontal, 5)
            }.frame(height: entry_height)
            
        }
    }
}

/*
 ZStack {
     Image(entry_img)
         .resizable()
         .frame(height: toggleHeight)
         .cornerRadius(7)

     HStack {
         Menu {
             Picker("choose", selection: $gender) {
                 ForEach(genders, id: \.self) { gender in
                     Text("\(gender)")
                         .font(._fieldCopyRegular)
                 }
             }
             .labelsHidden()
             .pickerStyle(InlinePickerStyle())

         } label: {
             // CHANGED: capitalize the g for consistency
             Text("\(gender == "" ? "Select Gender" : gender)")
                 .font(._fieldCopyRegular)
         }
         .frame(maxHeight: 400)
         Spacer()
     } // End HStack
     .padding(.horizontal, 5)
 } // End ZStack
 .frame(height: toggleHeight)
 .transition(.slide)
 */
