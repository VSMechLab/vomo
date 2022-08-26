//
//  ActivityView.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/7/22.
//

import SwiftUI

struct ActivityView: View {
    @ObservedObject var goal = Goal()
    
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
                
                GoalEntryView()
                
                Spacer()
            }
            .frame(width: svm.content_width)
        }
        .onAppear() {
            print(UIScreen.main.bounds.width)
        }.padding()
    }
}
