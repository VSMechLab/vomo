//
//  Graphic.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/29/22.
//

import SwiftUI

/// tabs
var tabs = ["Summary", "Pitch", "Duration", "Quality", "Survey"]

struct Graphic: View {
    @Binding var thresholdPopUps: (Bool, Bool, Bool)
    
    @State var selectedTab = "Summary"
    @State var edge = UIApplication.shared.windows.first?.safeAreaInsets
    // let backColor = [Color.BLUE, Color.TEAL, Color.BRIGHT_PURPLE, Color.DARK_PURPLE, Color.DARK_BLUE]
    
    @State private var showTitle = true
    
    @State private var time: Int = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            if selectedTab == "Summary" {
                Color.BLUE.edgesIgnoringSafeArea(.top)
            } else if selectedTab == "Pitch" {
                Color.DARK_PURPLE.edgesIgnoringSafeArea(.top)
            } else if selectedTab == "Duration" {
                Color.BRIGHT_PURPLE.edgesIgnoringSafeArea(.top)
            } else if selectedTab == "Quality" {
                Color.DARK_PURPLE.edgesIgnoringSafeArea(.top)
            } else if selectedTab == "Survey" {
                Color.DARK_BLUE.edgesIgnoringSafeArea(.top)
            }
            
            // Flip through views
            // Using swipe gesture
            TabView(selection: $selectedTab) {
                SummaryTab(showTitle: $showTitle)
                    .tag("Summary")
                
                PitchTab(showTitle: $showTitle, thresholdPopUps: $thresholdPopUps)
                    .tag("Pitch")
                
                DurationTab(showTitle: $showTitle, thresholdPopUps: $thresholdPopUps)
                    .tag("Duration")
                
                QualityTab(showTitle: $showTitle, thresholdPopUps: $thresholdPopUps)
                    .tag("Quality")
                
                SurveyTab(showTitle: $showTitle)
                    .tag("Survey")
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea(.all, edges: .bottom)
            .edgesIgnoringSafeArea(.top)
            
            
            VStack(spacing: 0) {
                if showTitle {
                    // Flip through bars using a tap
                    HStack(spacing: 0) {
                        ForEach(tabs, id: \.self) { image in
                            Spacer()
                            TabButton(image: image, selectedTab: $selectedTab)
                            if image == tabs.last {
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal, 0.5)
                    .padding(.vertical, 5)
                    .background(.white)
                    .clipShape(Capsule())
                    .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.black.opacity(0.15), radius: 5, x: -5, y: -5)
                    .padding(5)
                    /// for smaller phones
                    .padding(.bottom, edge!.bottom == 0 ? 20 : 0)
                    .transition(.slideDown)
                } else {
                    Button(action: {
                        withAnimation() {
                            self.showTitle = true
                            self.time = 0
                        }
                    }) {
                        Color.INPUT_FIELDS
                            .frame(height: 10)
                            .cornerRadius(2)
                            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
                            .shadow(color: Color.black.opacity(0.15), radius: 5, x: -5, y: -5)
                            .padding(.horizontal)
                    }.transition(.slideUp)
                }
                
                Spacer()
            }
            
            HStack {
                ForEach(0...4, id: \.self) { step in
                    Circle()
                        .foregroundColor(tabs[step] == selectedTab ? Color.white : Color.INPUT_FIELDS)
                        .frame(width: tabs[step] == selectedTab ? 8.5 : 6, height: tabs[step] == selectedTab ? 8.5 : 6, alignment: .center)
                }
            }
            .padding(.bottom, 7.5)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35)
        .onReceive(timer) { _ in
            time += 1
            if time >= 4 {
                withAnimation() {
                    self.showTitle = false
                }
            }
        }
        // Reset the title if dragged at all
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    withAnimation() {
                        self.showTitle = true
                        self.time = 0
                    }
                }
                .onEnded { _ in
                    withAnimation() {
                        self.showTitle = true
                        self.time = 0
                    }
                }
        )
    }
}

struct SummaryTab: View {
    @Binding var showTitle: Bool
    var body: some View {
        VStack {
            HStack {
                Text("Summary")
                    .font(Font._title1)
                Spacer()
            }
            .padding(.top, showTitle ? 15 : 0)
            
            HStack {
                Spacer()
                Text("Weekly Goal")
                    .foregroundColor(Color.white)
                    .font(._bodyCopyMedium)
            }
            
            GraphView(showVHI: .constant(false), showVE: .constant(false), index: 0)
            
            Spacer()
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width, height: showTitle ? UIScreen.main.bounds.height * 0.325 : UIScreen.main.bounds.height * 0.335)
        .foregroundColor(.TEAL)
        .edgesIgnoringSafeArea(.all)
    }
}

struct PitchTab: View {
    @Binding var showTitle: Bool
    
    @Binding var thresholdPopUps: (Bool, Bool, Bool)
    
    var body: some View {
        VStack {
            HStack {
                Text("Pitch")
                    .font(Font._title1)
                Spacer()
            }
            .padding(.top, showTitle ? 15 : 0)
            
            HStack {
                Spacer()
                Button("Set Threshold") {
                    self.thresholdPopUps.0.toggle()
                }
            }
            .foregroundColor(Color.white)
            .font(._bodyCopyMedium)
            
            PitchGraph()
            
            Spacer()
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width, height: showTitle ? UIScreen.main.bounds.height * 0.325 : UIScreen.main.bounds.height * 0.335)
        .foregroundColor(.BRIGHT_PURPLE)
        .edgesIgnoringSafeArea(.all)
    }
}

struct DurationTab: View {
    @Binding var showTitle: Bool
    
    @Binding var thresholdPopUps: (Bool, Bool, Bool)
    
    var body: some View {
        VStack {
            HStack {
                Text("Duration")
                    .font(Font._title1)
                Spacer()
            }
            .padding(.top, showTitle ? 15 : 0)
            
            HStack {
                Spacer()
                Button("Set Threshold") {
                    self.thresholdPopUps.0.toggle()
                }
            }
            .foregroundColor(Color.white)
            .font(._bodyCopyMedium)
            
            GraphView(showVHI: .constant(false), showVE: .constant(false), index: 2)
            
            Spacer()
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width, height: showTitle ? UIScreen.main.bounds.height * 0.325 : UIScreen.main.bounds.height * 0.335)
        .foregroundColor(.DARK_PURPLE)
        .edgesIgnoringSafeArea(.all)
    }
}

struct QualityTab: View {
    @Binding var showTitle: Bool
    
    @Binding var thresholdPopUps: (Bool, Bool, Bool)
    
    var body: some View {
        VStack {
            HStack {
                Text("Quality")
                    .font(Font._title1)
                Spacer()
            }
            .padding(.top, showTitle ? 15 : 0)
            
            HStack {
                Spacer()
                Button("Set Threshold") {
                    self.thresholdPopUps.0.toggle()
                }
            }
            .foregroundColor(Color.white)
            .font(._bodyCopyMedium)
            
            GraphView(showVHI: .constant(false), showVE: .constant(false), index: 3)
            
            Spacer()
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width, height: showTitle ? UIScreen.main.bounds.height * 0.325 : UIScreen.main.bounds.height * 0.335)
        .foregroundColor(.BRIGHT_PURPLE)
        .edgesIgnoringSafeArea(.all)
    }
}

struct SurveyTab: View {
    @Binding var showTitle: Bool
    var body: some View {
        VStack {
            HStack {
                Text("Survey")
                    .font(Font._title1)
                Spacer()
            }
            .padding(.top, showTitle ? 15 : 0)
            
            Spacer()
            
            SurveyGraph()
            
            Spacer()
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width, height: showTitle ? UIScreen.main.bounds.height * 0.325 : UIScreen.main.bounds.height * 0.335)
        .foregroundColor(.TEAL)
        .edgesIgnoringSafeArea(.all)
    }
}

struct TabButton: View {
    
    var image: String
    @Binding var selectedTab: String
    
    var body: some View {
        Button(action: { selectedTab = image }) {
            Text(image)
                .font(selectedTab == image ? Font._tabTitleBold : Font._tabTitle)
                .foregroundColor(selectedTab == image ? .black : .gray.opacity(0.7))
        }
    }
}

struct Graphic_Previews: PreviewProvider {
    static var previews: some View {
        Graphic(thresholdPopUps: .constant((false, false, false)))
    }
}
