//
//  ActivityView.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/7/22.
//

import SwiftUI

struct Activityiew: View {
    @State private var page = 0
    @State private var goalOneSelect = false
    @State private var goalTwoSelect = false
    
    let entry_img = "VM_12-entry-field"
    let entry_height: CGFloat = 37 * 0.95
    let next_img = "VM_next-nav-btn"
    let navArrowWidth = CGFloat(20)
    let navArrowHeight = CGFloat(25)
    let content_width: CGFloat = 317.5
    let dropdown_img = "VM_Dropdown-Btn"
    let select_img = "VM_Select-Btn"
    let unselect_img = "VM_Unselect-Btn"
    
    var body: some View {
        HStack(spacing: 0) {
            if self.page > 0 {
                Button(action: {
                    self.page -= 1
                }) {
                    Image(next_img)
                        .resizable()
                        .rotationEffect(Angle(degrees: 180))
                        .frame(width: navArrowWidth, height: navArrowHeight)
                }
            } else {
                Spacer().frame(width: navArrowWidth)
            }
            
            Spacer()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 10) {
                    ProfileButton()
                    
                    Group {
                        Text("Activity")
                            .font(._headline)
                        
                        Text("View activity over XXXXX lorem ipsomes")
                            .font(._bodyCopy)
                            .foregroundColor(Color.BODY_COPY)
                    }
                    
                    ActivityGraph()
                    
                    Group {
                        Text("Goals")
                            .font(._headline)
                        
                        Text("Define your activity and use goals here")
                            .font(._bodyCopy)
                            .foregroundColor(Color.BODY_COPY)
                        
                        Text("Goal 1: Number of entries per week")
                            .font(._fieldCopyRegular)
                    }
                    ZStack {
                        Image(entry_img)
                            .resizable()
                            .frame(height: entry_height)
                            .cornerRadius(7)
                        
                        HStack {
                            Button(action: {
                                self.goalOneSelect.toggle()
                            }) {
                                Image(goalOneSelect ? select_img : unselect_img)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                            Text("2x week")
                                .font(._bodyCopy)
                            Spacer()
                            Button(action: {
                                
                            }) {
                                Image(dropdown_img)
                                    .resizable()
                                    .frame(width: 22.5, height: 10)
                            }
                        }.padding(.horizontal, 5)
                    }.frame(height: entry_height)
                    
                    Text("Goal 2: Number of weeks to achieve goal")
                        .font(._fieldCopyRegular)
                    
                    ZStack {
                        Image(entry_img)
                            .resizable()
                            .frame(height: entry_height)
                            .cornerRadius(7)
                        
                        HStack {
                            Button(action: {
                                self.goalTwoSelect.toggle()
                            }) {
                                Image(goalTwoSelect ? select_img : unselect_img)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                            Text("8 weeks")
                                .font(._bodyCopy)
                            Spacer()
                            Button(action: {
                                
                            }) {
                                Image(dropdown_img)
                                    .resizable()
                                    .frame(width: 22.5, height: 10)
                            }
                        }.padding(.horizontal, 5)
                    }
                    .frame(height: entry_height)
                    .padding(.bottom, 100)
                    
                    /*
                    Group {
                        switch page {
                        case 0..<1:
                            Text("page 0")
                        case 1:
                            Text("page 1")
                        default:
                            Text("ERROR")
                        }
                    }
                    */
                    
                    Spacer()
                }
                .frame(width: content_width)
            }
            
            Spacer()
            
            if self.page < 2 {
                Button(action: {
                    self.page += 1
                }) {
                    Image(next_img)
                        .resizable()
                        .frame(width: navArrowWidth, height: navArrowHeight)
                }
            } else {
                Spacer().frame(width: navArrowWidth)
            }
        }.padding()
    }
}
