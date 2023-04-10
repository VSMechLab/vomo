//
//  SurveyGraphViews.swift
//  VoMo
//
//  Created by Neil McGrogan on 3/27/23.
//

import Foundation
import SwiftUI

extension SurveyGraph {
    
    var graphNodes: some View {
        
        // Rest of nodes shown here
        ForEach(points) { point in
            ZStack {
                if point.hasTreatment {
                    VStack(spacing: 0) {
                        Color.clear.frame(height: 25)
                        if point.afterDate {
                            DottedLine()
                                .offset(x: 20)
                        } else {
                            DottedLine()
                                .offset(x: -20)
                        }
                    }
                }
                
                VStack(spacing: 0) {
                    GeometryReader { geo in
                        
                        // This will contain the union of two points if on survey selection 1
                        if surveySelection == 1 {
                          
                            ZStack {
                                
                                
                                // Point one
                                VStack(spacing: 0) {
                                    //Color.clear.frame(height: 20)
                                    ZStack {
                                        /// Spacing above, the circle and spacing bellow the axis
                                        Color.clear.frame(height: geo.size.height * nodes(value: point.data).3)
                                        
                                        VStack {
                                            if point.hasTreatment {
                                                Button(action: {
                                                    if showMoreTreatmentInfo == false {
                                                        currTreatment = point.treatmentDate
                                                    }
                                                    if point.hasTreatment {
                                                        showMoreTreatmentInfo.toggle()
                                                    }
                                                    
                                                    if self.tappedRecording == point.dataDate {
                                                        self.tappedRecording = .now
                                                    } else {
                                                        self.tappedRecording = point.dataDate
                                                    }
                                                }) {
                                                    if point.afterDate {
                                                        Image(svm.rx_sign)
                                                            .resizable()
                                                            .frame(width: geo.size.height * 0.10, height: geo.size.height * nodes(value: point.data).2)
                                                            .offset(x: 20)
                                                            .padding(2)
                                                    } else {
                                                        Image(svm.rx_sign)
                                                            .resizable()
                                                            .frame(width: geo.size.height * 0.10, height: geo.size.height * nodes(value: point.data).2)
                                                            .offset(x: -20)
                                                            .padding(2)
                                                    }
                                                }
                                                
                                            }
                                            
                                            Spacer()
                                        }
                                        .frame(height: geo.size.height * nodes(value: point.data).3)
                                    }
                                    .frame(height: geo.size.height * nodes(value: point.data).3)
                                    
                                    Button(action: {
                                        if showMoreTreatmentInfo == false {
                                            currTreatment = point.treatmentDate
                                        }
                                        if self.tappedRecording == point.dataDate {
                                            self.tappedRecording = .now
                                        } else {
                                            self.tappedRecording = point.dataDate
                                        }
                                    }) {
                                        ZStack {
                                            Circle()
                                                .strokeBorder(.white, lineWidth: 2)
                                                .background(Circle().fill(Color.TEAL))
                                                .frame(width: geo.size.height * 0.10, height: geo.size.height * nodes(value: point.data).2)
                                                .offset(x: point.data == point.secondPoint ? -5 : 0)
                                            
                                            if point.data > point.secondPoint {
                                                Text("\(point.data, specifier: "%.0f")").font(._fieldCopyBold)
                                                    .offset(y: -20)
                                            } else if point.data < point.secondPoint {
                                                Text("\(point.data, specifier: "%.0f")").font(._fieldCopyBold)
                                                    .offset(y: 20)
                                            } else if point.data == point.secondPoint {
                                                Text("\(point.data, specifier: "%.0f")").font(._fieldCopyBold)
                                                    .offset(y: -20)
                                            }
                                        }
                                    }
                                    
                                    Color.clear.frame(height: geo.size.height * nodes(value: point.data).1)
                                }
                                
                                // Second Point
                                VStack(spacing: 0) {
                                    ZStack {
                                        /// Spacing above, the circle and spacing bellow the axis
                                        Color.clear.frame(height: geo.size.height * nodes(value: point.secondPoint).3)
                                        
                                        VStack {
                                            
                                            Spacer()
                                        }
                                        .frame(height: geo.size.height * nodes(value: point.secondPoint).3)
                                    }
                                    .frame(height: geo.size.height * nodes(value: point.secondPoint).3)
                                    
                                    Button(action: {
                                        if showMoreTreatmentInfo == false {
                                            currTreatment = point.treatmentDate
                                        }
                                        if self.tappedRecording == point.dataDate {
                                            self.tappedRecording = .now
                                        } else {
                                            self.tappedRecording = point.dataDate
                                        }
                                    }) {
                                        ZStack {
                                            Circle()
                                                .strokeBorder(.white, lineWidth: 2)
                                                .background(Circle().fill(Color.DARK_PURPLE))
                                                .frame(width: geo.size.height * 0.10, height: geo.size.height * nodes(value: point.secondPoint).2)
                                                .offset(x: point.data == point.secondPoint ? 5 : 0)
                                            
                                            if point.secondPoint > point.data {
                                                Text("\(point.secondPoint, specifier: "%.0f")").font(._fieldCopyBold)
                                                    .offset(y: -20)
                                            } else if point.secondPoint < point.data {
                                                Text("\(point.secondPoint, specifier: "%.0f")").font(._fieldCopyBold)
                                                    .offset(y: 20)
                                            }
                                        }
                                    }
                                    
                                    Color.clear.frame(height: geo.size.height * nodes(value: point.secondPoint).1)
                                }
                            }
                            
                        } else {
                            VStack(spacing: 0) {
                                //Color.clear.frame(height: 20)
                                ZStack {
                                    /// Spacing above, the circle and spacing bellow the axis
                                    Color.clear.frame(height: geo.size.height * nodes(value: point.data).3)
                                    
                                    VStack {
                                        if point.hasTreatment {
                                            Button(action: {
                                                if showMoreTreatmentInfo == false {
                                                    currTreatment = point.treatmentDate
                                                }
                                                if point.hasTreatment {
                                                    showMoreTreatmentInfo.toggle()
                                                }
                                                
                                                if self.tappedRecording == point.dataDate {
                                                    self.tappedRecording = .now
                                                } else {
                                                    self.tappedRecording = point.dataDate
                                                }
                                            }) {
                                                if point.afterDate {
                                                    Image(svm.rx_sign)
                                                        .resizable()
                                                        .frame(width: geo.size.height * 0.10, height: geo.size.height * nodes(value: point.data).2)
                                                        .offset(x: 20)
                                                        .padding(2)
                                                } else {
                                                    Image(svm.rx_sign)
                                                        .resizable()
                                                        .frame(width: geo.size.height * 0.10, height: geo.size.height * nodes(value: point.data).2)
                                                        .offset(x: -20)
                                                        .padding(2)
                                                }
                                            }
                                            
                                        }
                                        
                                        Spacer()
                                    }
                                    .frame(height: geo.size.height * nodes(value: point.data).3)
                                }
                                .frame(height: geo.size.height * nodes(value: point.data).3)
                                
                                Button(action: {
                                    if showMoreTreatmentInfo == false {
                                        currTreatment = point.treatmentDate
                                    }
                                    if self.tappedRecording == point.dataDate {
                                        self.tappedRecording = .now
                                    } else {
                                        self.tappedRecording = point.dataDate
                                    }
                                }) {
                                    ZStack {
                                        Circle()
                                            .strokeBorder(.white, lineWidth: 2)
                                            .background(Circle().fill(nodes(value: point.data).0))
                                            .frame(width: geo.size.height * 0.10, height: geo.size.height * nodes(value: point.data).2)
                                        Text("\(point.data, specifier: "%.0f")").font(._fieldCopyBold)
                                            .offset(y: -20)
                                    }
                                }
                                
                                Color.clear.frame(height: geo.size.height * nodes(value: point.data).1)
                            }
                        }
                        
                        
                    }
                    
                    /// bottom of axis & date
                    Color.white.frame(height: 2)
                    Text("\(point.dataDate.shortDay())")
                        .font(._fieldCopyRegular)
                        .frame(width: point.hasTreatment ? 100 : 50, height: 15)
                }
            }.frame(width: point.hasTreatment ? 100 : 50)
        }
    }
    
    var baseline: some View {
        // Baseline shown here
        VStack(spacing: 0) {
            ZStack {
                GeometryReader { geo in
                    
                    if surveySelection == 1 {
                        
                        ZStack {
                            // First Point
                            VStack(spacing: 0) {
                                /// Spacing above, the circle and spacing bellow the axis
                                Color.clear.frame(height: geo.size.height * nodes(value: firstPoint.data).3)
                                
                                Button(action: {
                                    if self.tappedRecording == firstPoint.dataDate {
                                        self.tappedRecording = .now
                                    } else {
                                        self.tappedRecording = firstPoint.dataDate
                                    }
                                }) {
                                    ZStack {
                                        if firstPoint.data > firstPoint.secondPoint {
                                            Text("\(firstPoint.data, specifier: "%.0f")").font(._fieldCopyBold)
                                                .offset(y: -20)
                                        } else if firstPoint.data < firstPoint.secondPoint {
                                            Text("\(firstPoint.data, specifier: "%.0f")").font(._fieldCopyBold)
                                                .offset(y: 20)
                                        } else if firstPoint.data == firstPoint.secondPoint {
                                            Text("\(firstPoint.data, specifier: "%.0f")").font(._fieldCopyBold)
                                                .offset(y: -20)
                                        }
                                        
                                        Text("P")
                                            .font(._fieldCopyBold).foregroundColor(Color.white)
                                            .padding(.horizontal, 3).background(Color.TEAL)
                                            .cornerRadius(10).padding(1).background(Color.white).cornerRadius(10)
                                            .frame(width: geo.size.height * 0.10, height: geo.size.height * nodes(value: firstPoint.data).2)
                                    }
                                }

                                Color.clear.frame(height: geo.size.height * nodes(value: firstPoint.data).1)
                            }
                            
                            // Second Point
                            
                            VStack(spacing: 0) {
                                /// Spacing above, the circle and spacing bellow the axis
                                Color.clear.frame(height: geo.size.height * nodes(value: firstPoint.secondPoint).3)
                                
                                Button(action: {
                                    if self.tappedRecording == firstPoint.dataDate {
                                        self.tappedRecording = .now
                                    } else {
                                        self.tappedRecording = firstPoint.dataDate
                                    }
                                }) {
                                    ZStack {
                                        if firstPoint.secondPoint > firstPoint.data {
                                            Text("\(firstPoint.secondPoint, specifier: "%.0f")").font(._fieldCopyBold)
                                                .offset(y: -20)
                                        } else if firstPoint.secondPoint < firstPoint.data {
                                            Text("\(firstPoint.secondPoint, specifier: "%.0f")").font(._fieldCopyBold)
                                                .offset(y: 20)
                                        }
                                        
                                        Text("M")
                                            .font(._fieldCopyBold).foregroundColor(Color.white)
                                            .padding(.horizontal, 3).background(nodes(value: firstPoint.secondPoint).0)
                                            .cornerRadius(10).padding(1).background(Color.white).cornerRadius(10)
                                            .frame(width: geo.size.height * 0.10, height: geo.size.height * nodes(value: firstPoint.secondPoint).2)
                                    }
                                }

                                Color.clear.frame(height: geo.size.height * nodes(value: firstPoint.secondPoint).1)
                            }
                        }
                        
                    } else {
                        
                        VStack(spacing: 0) {
                            /// Spacing above, the circle and spacing bellow the axis
                            Color.clear.frame(height: geo.size.height * nodes(value: firstPoint.data).3)
                            
                            Button(action: {
                                if self.tappedRecording == firstPoint.dataDate {
                                    self.tappedRecording = .now
                                } else {
                                    self.tappedRecording = firstPoint.dataDate
                                }
                            }) {
                                ZStack {
                                    Text("\(firstPoint.data, specifier: "%.0f")").font(._fieldCopyBold)
                                        .offset(y: -20)
                                    
                                    Text("B")
                                        .font(._fieldCopyBold).foregroundColor(Color.white)
                                        .padding(.horizontal, 3).background(nodes(value: firstPoint.data).0)
                                        .cornerRadius(10).padding(1).background(Color.white).cornerRadius(10)
                                        .frame(width: geo.size.height * 0.10, height: geo.size.height * nodes(value: firstPoint.data).2)
                                }
                            }

                            Color.clear.frame(height: geo.size.height * nodes(value: firstPoint.data).1)
                        }
                    }
                }
                
                VStack(spacing: 0) {
                    Spacer()
                    Text("BASELINE")
                        .font(._fieldCopyRegular)
                }
            }
            
            /// bottom of axis & date
            Color.white.frame(height: 2)
            Text("\(points.first?.dataDate.toDay() ?? (Date.now).toDay())")
                .font(._fieldCopyRegular)
                .frame(width: 58.5, height: 15)
        }
        .frame(width: 58.5)
    }
    
    var voiceQualitySection: some View {
        VStack {
            if surveySelection == 0 {
                Text("Worse\nVoice")
                Spacer()
                Text("Better\nVoice")
            } else if surveySelection == 3 {
                Text("Normal\nFunction")
                Spacer()
                Text("No\nFunction")
            }
        }
        .font(._bodyCopy)
        .frame(width: surveySelection == 3 ? 60.0 : 50.0)
    }
    
    var yLabel: some View {
        VStack(alignment: .trailing, spacing: 0) {
            Text("\(height, specifier: "%.0f") ")
            Spacer()
            if surveySelection == 0 {
                Text("VHI-10")
                    .padding(.horizontal, -10)
                    .rotationEffect(Angle(degrees: -90))
                    .frame(width: 40)
            } else if surveySelection == 1 {
                Text("% physical effort")
                    .frame(width: 120)
                    .padding(.horizontal, -10)
                    .rotationEffect(Angle(degrees: -90))
                    .frame(width: 40)
            } else if surveySelection == 2 {
                Text("% mental effort")
                    .frame(width: 120)
                    .padding(.horizontal, -10)
                    .rotationEffect(Angle(degrees: -90))
                    .frame(width: 40)
            } else {
                Text("Percentage")
                    .frame(width: 130)
                    .padding(.horizontal, -10)
                    .rotationEffect(Angle(degrees: -90))
                    .frame(width: 40)
            }
            Spacer()
            Text("0 ")
        }
        .font(._bodyCopy)
        .frame(width: 40)
    }
    
    
    var targetLine: some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                VStack(spacing: 0) {
                    Color.clear.frame(height: geo.size.height * ((maxHeight() - 12) / maxHeight()))
                    
                    HStack(spacing: 0) {
                        ForEach(1...20, id: \.self) { num in
                            if num % 2 == 0 {
                                Color.white.frame(height: 2)
                            } else {
                                Color.clear.frame(height: 2)
                            }
                        }
                    }.frame(width: geo.size.width)
                    
                    Color.clear.frame(height: geo.size.height * ((12) / maxHeight()))
                }
                .frame(height: geo.size.height)
            }
            
            Color.clear.frame(height: 17)
        }
    }
    
    var abnormalKey: some View {
        ZStack {
            VStack(spacing: 0) {
                GeometryReader { geo in
                    VStack(alignment: .leading, spacing: 0) {
                        ZStack {
                            HStack {
                                Color.clear
                                Spacer()
                            }
                            
                            VStack {
                                Spacer()
                                HStack {
                                    Text("Abnormal")
                                        .padding(2.5)
                                    Spacer()
                                }
                            }
                        }
                        .frame(height: geo.size.height * ((maxHeight() - 12) / maxHeight()))
                        
                        ZStack {
                            Color.clear
                            
                            VStack {
                                HStack {
                                    Text("Normal")
                                        .padding(2.5)
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                        .frame(height: geo.size.height * ((12) / maxHeight()))
                        .background(Color.white.opacity(0.2))
                    }
                    .font(._bodyCopy)
                    .frame(width: geo.size.width, height: geo.size.height)
                }
                
                Color.clear.frame(height: 17)
            }
            
            targetLine
        }
    }
}
