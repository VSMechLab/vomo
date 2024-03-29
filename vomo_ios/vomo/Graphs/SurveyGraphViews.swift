//
//  SurveyGraphViews.swift
//  VoMo
//
//  Created by Neil McGrogan on 3/27/23.
//

import Foundation
import SwiftUI

extension SurveyGraph {
    
    var baseline: some View {
        ZStack {
            // RX
            if firstPoint.hasTreatment {
                dottedLine
                    .offset(x: firstPoint.afterDate ? 20 : -20)
                
                VStack(spacing: 0) {
                    Button(action: {
                        if showMoreTreatmentInfo == false {
                            currTreatment = firstPoint.treatmentDate
                        }
                        if firstPoint.hasTreatment {
                            showMoreTreatmentInfo.toggle()
                        }
                    }) {
                        rxSign.offset(x: firstPoint.afterDate ? 20 : -20)
                    }
                    
                    Spacer()
                }
            }
            
            // Baseline shown here
            VStack(spacing: 0) {
                // Basic spacing
                Color.clear.frame(width: 1, height: 20)
                
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
                                            if firstPoint.data <= 5 {
                                                Text("\(firstPoint.data, specifier: "%.0f")").font(._fieldCopyBold)
                                                    .offset(x: 20)
                                            } else {
                                                Text("\(firstPoint.data, specifier: "%.0f")").font(._fieldCopyBold)
                                                    .offset(y: 20)
                                            }
                                        } else if firstPoint.data == firstPoint.secondPoint {
                                            Text("\(firstPoint.data, specifier: "%.0f")").font(._fieldCopyBold)
                                                .offset(y: -20)
                                        }
                                        
                                        if firstPoint.data == firstPoint.secondPoint {
                                            Text("B")
                                                .padding(.horizontal, 3).background(Color.TEAL)
                                                .cornerRadius(10).padding(1).background(Color.white).cornerRadius(10)
                                                .frame(width: geo.size.height * 0.10, height: geo.size.height * 0.10)
                                                .offset(x: -5)
                                        } else {
                                            Text("B")
                                                .padding(.horizontal, 3).background(Color.TEAL)
                                                .cornerRadius(10).padding(1).background(Color.white).cornerRadius(10)
                                                .frame(width: geo.size.height * 0.10, height: geo.size.height * 0.10)
                                        }
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
                                            if firstPoint.secondPoint <= 5 {
                                                Text("\(firstPoint.secondPoint, specifier: "%.0f")").font(._fieldCopyBold)
                                                    .offset(x: -20)
                                            } else {
                                                Text("\(firstPoint.secondPoint, specifier: "%.0f")").font(._fieldCopyBold)
                                                    .offset(y: 20)
                                            }
                                        }
                                        
                                        
                                        if firstPoint.data == firstPoint.secondPoint {
                                            Text("B")
                                                .padding(.horizontal, 3).background(nodes(value: firstPoint.secondPoint).0)
                                                .cornerRadius(10).padding(1).background(Color.white).cornerRadius(10)
                                                .frame(width: geo.size.height * 0.10, height: geo.size.height * 0.10)
                                                .offset(x: 5)
                                        } else {
                                            Text("B")
                                                .padding(.horizontal, 3).background(nodes(value: firstPoint.secondPoint).0)
                                                .cornerRadius(10).padding(1).background(Color.white).cornerRadius(10)
                                                .frame(width: geo.size.height * 0.10, height: geo.size.height * 0.10)
                                        }
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
                                        .padding(.horizontal, 3).background(nodes(value: firstPoint.data).0)
                                        .cornerRadius(10).padding(1).background(Color.white).cornerRadius(10)
                                        .frame(width: geo.size.height * 0.10, height: geo.size.height * 0.10)
                                }
                            }

                            Color.clear.frame(height: geo.size.height * nodes(value: firstPoint.data).1)
                        }
                    }
                }
                
                /// bottom of axis & date
                Color.white.frame(height: 2)
                VStack(spacing: 0) {
                    Text("\(points.first?.dataDate.nodeTitle() ?? "")")
                    Text("\(points.first?.dataDate.baselineLabelBody() ?? "")")
                        .foregroundColor(.YELLOW)
                }
                .font(._day)
                .frame(width: points.first?.hasTreatment ?? false ? 100 : 50, height: 23)
            }
        }
        .frame(width: 75)
    }
    
    private var dottedLine: some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                VStack(spacing: 0) {
                    ForEach(0..<30, id: \.self) { num in
                        HStack {
                            Spacer()
                            if num % 2 == 0 {
                                Color.white.frame(width: 2, height: geo.size.height / 30)
                            } else {
                                Color.clear.frame(width: 2, height: geo.size.height / 30)
                            }
                            Spacer()
                        }
                    }
                }
            }
            
            Color.clear.frame(height: 25)
        }
    }
    
    var graphNodes: some View {
        // Rest of nodes shown here
        ForEach(points) { point in
            ZStack {
                // RX
                if point.hasTreatment {
                    dottedLine
                        .offset(x: point.afterDate ? 20 : -20)
                    
                    VStack(spacing: 0) {
                        Button(action: {
                            if showMoreTreatmentInfo == false {
                                currTreatment = point.treatmentDate
                            }
                            if point.hasTreatment {
                                showMoreTreatmentInfo.toggle()
                            }
                        }) {
                            rxSign.offset(x: point.afterDate ? 20 : -20)
                        }
                        
                        Spacer()
                    }
                }
                
                // Baseline shown here
                VStack(spacing: 0) {
                    // Basic spacing
                    Color.clear.frame(width: 1, height: 20)
                    
                    
                    GeometryReader { geo in
                        if surveySelection == 1 {
                            
                            ZStack {
                                // First Point
                                VStack(spacing: 0) {
                                    /// Spacing above, the circle and spacing bellow the axis
                                    Color.clear.frame(height: geo.size.height * nodes(value: point.data).3)
                                    
                                    Button(action: {
                                        if self.tappedRecording == point.dataDate {
                                            self.tappedRecording = .now
                                        } else {
                                            self.tappedRecording = point.dataDate
                                        }
                                    }) {
                                        ZStack {
                                            if point.data > point.secondPoint {
                                                Text("\(point.data, specifier: "%.0f")").font(._fieldCopyBold)
                                                    .offset(y: -20)
                                            } else if point.data < point.secondPoint {
                                                if point.data <= 5 {
                                                    Text("\(point.data, specifier: "%.0f")").font(._fieldCopyBold)
                                                        .offset(x: 20)
                                                } else {
                                                    Text("\(point.data, specifier: "%.0f")").font(._fieldCopyBold)
                                                        .offset(y: 20)
                                                }
                                            } else if point.data == point.secondPoint {
                                                Text("\(point.data, specifier: "%.0f")").font(._fieldCopyBold)
                                                    .offset(y: -20)
                                            }
                                            
                                            if point.data == point.secondPoint {
                                                Text("B")
                                                    .foregroundColor(.clear)
                                                    .padding(.horizontal, 3).background(Color.TEAL)
                                                    .cornerRadius(10).padding(1).background(Color.white).cornerRadius(10)
                                                    .frame(width: geo.size.height * 0.10, height: geo.size.height * 0.10)
                                                    .offset(x: point.data == point.secondPoint ? -5 : 0)
                                                    .offset(x: -5)
                                            } else {
                                                Text("B")
                                                    .foregroundColor(.clear)
                                                    .padding(.horizontal, 3).background(Color.TEAL)
                                                    .cornerRadius(10).padding(1).background(Color.white).cornerRadius(10)
                                                    .frame(width: geo.size.height * 0.10, height: geo.size.height * 0.10)
                                                    .offset(x: point.data == point.secondPoint ? -5 : 0)
                                            }
                                        }
                                    }

                                    Color.clear.frame(height: geo.size.height * nodes(value: point.data).1)
                                }
                            }
                        } else {
                            VStack(spacing: 0) {
                                /// Spacing above, the circle and spacing bellow the axis
                                Color.clear.frame(height: geo.size.height * nodes(value: point.data).3)
                                
                                Button(action: {
                                    if self.tappedRecording == point.dataDate {
                                        self.tappedRecording = .now
                                    } else {
                                        self.tappedRecording = point.dataDate
                                    }
                                }) {
                                    ZStack {
                                        Text("B")
                                            .foregroundColor(.clear)
                                            .padding(.horizontal, 3).background(nodes(value: point.data).0)
                                            .cornerRadius(10).padding(1).background(Color.white).cornerRadius(10)
                                            .frame(width: geo.size.height * 0.10, height: geo.size.height * 0.10)
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
                    VStack(spacing: 0) {
                        Text("\(point.dataDate.nodeTitle())")
                        Text("\(point.dataDate.nodeHeader())")
                            .foregroundColor(.YELLOW)
                    }
                    .font(._day)
                    .frame(width: point.hasTreatment ? 100 : 50, height: 23)
                }
            }
            .frame(width: 75)
        }
    }
    
    var secondGraphNodes: some View {
        // Rest of nodes shown here
        ForEach(points) { point in
            ZStack {
                VStack(spacing: 0) {
                    // Basic spacing
                    Color.clear.frame(width: 1, height: 20)
                    
                    
                    GeometryReader { geo in
                        if surveySelection == 1 {
                            
                            ZStack {
                                // Second Point
                                VStack(spacing: 0) {
                                    /// Spacing above, the circle and spacing bellow the axis
                                    Color.clear.frame(height: geo.size.height * nodes(value: point.secondPoint).3)
                                    
                                    Button(action: {
                                        if self.tappedRecording == point.dataDate {
                                            self.tappedRecording = .now
                                        } else {
                                            self.tappedRecording = point.dataDate
                                        }
                                    }) {
                                        ZStack {
                                            if point.secondPoint > point.data {
                                                Text("\(point.secondPoint, specifier: "%.0f")").font(._fieldCopyBold)
                                                    .offset(y: -20)
                                            } else if point.secondPoint < point.data {
                                                if firstPoint.secondPoint <= 5 {
                                                    Text("\(point.secondPoint, specifier: "%.0f")").font(._fieldCopyBold)
                                                        .offset(x: -20)
                                                } else {
                                                    Text("\(point.secondPoint, specifier: "%.0f")").font(._fieldCopyBold)
                                                        .offset(y: 20)
                                                }
                                            } else if point.data == point.secondPoint {
                                                Text("\(point.data, specifier: "%.0f")").font(._fieldCopyBold)
                                                    .offset(y: -20)
                                            }
                                            
                                            if point.data == point.secondPoint {
                                                Text("B")
                                                    .foregroundColor(.clear)
                                                    .padding(.horizontal, 3).background(nodes(value: point.data).0)
                                                    .cornerRadius(10).padding(1).background(Color.white).cornerRadius(10)
                                                    .frame(width: geo.size.height * 0.10, height: geo.size.height * 0.10)
                                                    .offset(x: point.data == point.secondPoint ? -5 : 0)
                                                    .offset(x: 5)
                                            } else {
                                                Text("B")
                                                    .foregroundColor(.clear)
                                                    .padding(.horizontal, 3).background(nodes(value: point.data).0)
                                                    .cornerRadius(10).padding(1).background(Color.white).cornerRadius(10)
                                                    .frame(width: geo.size.height * 0.10, height: geo.size.height * 0.10)
                                                    .offset(x: point.data == point.secondPoint ? -5 : 0)
                                            }
                                        }
                                    }

                                    Color.clear.frame(height: geo.size.height * nodes(value: point.secondPoint).1)
                                }
                            }
                        }
                    }
                    
                    /// bottom of axis & date
                    Color.clear.frame(width: 75, height: 25)
                }
            }
            .frame(width: 75)
        }
    }
    
    
    private var rxSign: some View {
        Image(svm.rx_sign)
            .resizable()
            .frame(width: 20, height: 20)
    }
    
    var voiceQualitySection: some View {
        VStack {
            if surveySelection == 0 {
                Text("**Worse**\nVoice")
                Spacer()
                Text("**Better**\nVoice")
            } else if surveySelection == 3 {
                Text("**Normal**\nFunction")
                Spacer()
                Text("**No**\nFunction")
            }
        }
        .font(._bodyCopy)
        .frame(width: surveySelection == 3 ? 60.0 : 50.0)
    }
    
    var yLabel: some View {
        VStack(alignment: .trailing, spacing: 0) {
            // Basic spacing
            Color.clear.frame(width: 1, height: 20)
            
            Text("\(height, specifier: "%.0f") ")
            Spacer()
            if surveySelection == 0 {
                Text("VHI-10")
                    .padding(.horizontal, -10)
                    .rotationEffect(Angle(degrees: -90))
                    .frame(width: 40)
                    .offset(x: 12.5)
                    .offset(y: -10)
            } else if surveySelection == 1 {
                Text("% effort")
                    .frame(width: 120)
                    .padding(.horizontal, -10)
                    .rotationEffect(Angle(degrees: -90))
                    .frame(width: 40)
            } else {
                Text("% of normal function")
                    .frame(width: 130)
                    .padding(.horizontal, -10)
                    .rotationEffect(Angle(degrees: -90))
                    .frame(width: 40)
            }
            Spacer()
            Text("0 ")
        }
        .font(._bodyCopyBold)
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
            
            Color.clear.frame(height: 25)
        }
    }
    
    var abnormalKey: some View {
        ZStack {
            VStack(spacing: 0) {
                
                GeometryReader { geo in
                    HStack(spacing: 0) {
                        VStack(alignment: .center, spacing: 0) {
                            
                            Image(svm.vertical_arrow)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 11.5)
                        }
                        .frame(width: 50.0)

                        VStack(alignment: .leading, spacing: 0) {
                            
                            ZStack {
                                HStack {
                                    Color.clear
                                    Spacer()
                                }
                                
                                VStack(spacing: 0) {
                                    Spacer()
                                    HStack(spacing: 0) {
                                        Text("Abnormal")
                                            .font(._surveyNormalLabel)
                                            .rotationEffect(Angle(degrees: -90), anchor: .topLeading)
                                            .padding(1.5)
                                            .padding(.vertical)
                                            .offset(y: 50)
                                        Spacer()
                                    }
                                    Spacer()
                                }
                            }
                            .frame(height: geo.size.height * ((maxHeight() - 12) / maxHeight()))
                            
                            ZStack {
                                Color.clear
                                
                                VStack(spacing: 0) {
                                    Spacer()
                                    HStack(spacing: 0) {
                                        Text("Normal")
                                            .font(._surveyNormalLabel)
                                            .rotationEffect(Angle(degrees: -90), anchor: .topLeading)
                                            .padding(1.5)
                                            .padding(.vertical)
                                            .offset(y: 20)
                                        Spacer()
                                    }
                                    Spacer()
                                }
                            }
                            .frame(height: geo.size.height * ((12) / maxHeight()))
                            .background(Color.white.opacity(0.2))
                        }
                        .font(._fieldCopyRegular)
                        .frame(width: geo.size.width, height: geo.size.height)
                    }
                }
                
                Color.clear.frame(height: 25)
            }
            
            HStack(spacing: 0) {
                Color.clear.frame(width: 50)
                targetLine
            }
        }
    }
}
