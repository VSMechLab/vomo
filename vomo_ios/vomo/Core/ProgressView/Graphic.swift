//
//  Graphic.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/29/22.
//

import SwiftUI

struct Graphic: View {
    
    @Binding var thresholdPopUps: (Bool, Bool, Bool)
    
    let title = ["Summary", "Pitch", "Duration", "Quality", "Survey"]
    let backColor = [Color.BLUE, Color.TEAL, Color.BRIGHT_PURPLE, Color.DARK_PURPLE, Color.DARK_BLUE]
    let foreColor = [Color.TEAL, Color.DARK_BLUE, Color.DARK_PURPLE, Color.BRIGHT_PURPLE, Color.TEAL]
    let svm = SharedViewModel()
    
    var body: some View {
        TabView {
            ForEach(0..<backColor.count, id: \.self) { index in
                ZStack {
                    VStack {
                        GraphicTitle(index: index, title: title[index])
                        
                        HStack {
                            Text(title[index])
                                .font(Font._title1)
                                .foregroundColor(foreColor[index])
                            
                            if index == 0 {
                                Spacer()
                                Text("Weekly Goal")
                                    .foregroundColor(Color.white)
                                    .font(._bodyCopyMedium)
                            } else if index == 1 || index == 2 || index == 3 {
                                Spacer()
                                Button("Set Threshold") {
                                    self.thresholdPopUps.0.toggle()
                                }
                                .foregroundColor(Color.white)
                                .font(._bodyCopyMedium)
                            } else if index == 4 {
                                Spacer()
                                HStack(spacing: 0) {
                                    VStack(alignment: .trailing) {
                                        Text("VHI ").font(._bodyCopy).foregroundColor(Color.BRIGHT_PURPLE)
                                        Text("Vocal Effort ").font(._bodyCopy).foregroundColor(Color.TEAL)
                                    }
                                }
                            }
                        }
                        
                        GraphView(index: index)
                        
                        Spacer()
                    }
                    .frame(width: svm.content_width)
                }
                .transition(.opacity)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35)
                .background(backColor[index])
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .interactive))
        .edgesIgnoringSafeArea(.top)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35)
    }
}

struct Graphic_Previews: PreviewProvider {
    static var previews: some View {
        Graphic(thresholdPopUps: .constant((false, false, false)))
    }
}
