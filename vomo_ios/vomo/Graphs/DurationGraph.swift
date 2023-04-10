//
//  DurationGraph.swift
//  VoMo
//
//  Created by Neil McGrogan on 3/7/23.
//

import SwiftUI

class DurationNodeModel: Identifiable, Codable {
    var data: Double
    var dataDate: Date
    var hasTreatment: Bool
    var afterDate: Bool
    var treatmentDate: Date
    var treatmentType: String
    
    init(data: Double, dataDate: Date, hasTreatment: Bool, afterDate: Bool, treatmentDate: Date, treatmentType: String) {
        self.data = data
        self.dataDate = dataDate
        self.hasTreatment = hasTreatment
        self.afterDate = afterDate
        self.treatmentDate = treatmentDate
        self.treatmentType = treatmentType
    }
}

struct DurationGraph: View {
    @EnvironmentObject var audioRecorder: AudioRecorder
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var entries: Entries
    
    @Binding var tappedRecording: Date
    @Binding var showBaseline: Bool
    @Binding var deletionTarget: (Date, String)
    
    @State private var showMoreTreatmentInfo = false
    @State private var points: [DurationNodeModel] = []
    @State private var firstPoint: DurationNodeModel = DurationNodeModel(data: 0.0, dataDate: .now, hasTreatment: false, afterDate: false, treatmentDate: .now, treatmentType: "")
    @State private var currTreatment: Date = .now
    
    @State private var height = 30.0
    @State private var bottom = 0.0
    
    let svm = SharedViewModel()
    
    var body: some View {
        
        ZStack {
            
            
            /// This hstack will contain three things
            /// Y axis with labels
            /// Body of the graph
            HStack(spacing: 0) {
                
                /// Contains the label for the y axis and the y axis
                /// Will have a fixed range height of 300 hz
                /// Will have a fixed range bottom of 0 hz
                yAxis
                
                
                ZStack {
                    targetBar
                    
                    HStack(spacing: 0) {
                        if firstPoint.dataDate != .now {
                            baseline
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            ZStack {
                                //targetBar
                                
                                HStack(spacing: 0) {
                                    
                                    
                                    graphNodes
                                }
                            }
                        }
                    }
                }
                
                
                Spacer()
            }
            .onAppear() {
                findPoints()
            }
            
            if showMoreTreatmentInfo && currTreatment != .now {
                Button(action: {
                    self.showMoreTreatmentInfo = false
                }) {
                    VStack {
                        Spacer()
                        Text(currTreatment.toDOB())
                            .font(._bodyCopyBold)
                        Text(findType())
                            .font(._bodyCopy)
                        
                        Spacer()
                        
                        DeleteButton(deletionTarget: $deletionTarget, type: "treatment", date: currTreatment)
                    }
                    .foregroundColor(Color.black)
                    .padding(20)
                    .background(Color.BRIGHT_PURPLE)
                    .cornerRadius(5)
                    .shadow(radius: 5)
                    .padding(.vertical, 50)
                }
            }
            
        }
        .foregroundColor(Color.white)
        .onChange(of: deletionTarget.0) { _ in
            findPoints()
        }
        .onChange(of: entries.treatments.count) { _ in
            findPoints()
            showMoreTreatmentInfo = false
        }
        .onChange(of: audioRecorder.recordings.count) { _ in
            findPoints()
        }
        .onAppear() {
            height = settings.durationRange().1
            bottom = 0.0
        }
    }
    
    func findType() -> String {
        for treatment in entries.treatments {
            if treatment.date == currTreatment {
                return treatment.type
            }
        }
        return ""
    }
    
    // `
    func findPoints() {
        points = []
        
        for data in audioRecorder.processedData {
            for record in audioRecorder.recordings {
                if record.taskNum == 2 && record.createdAt == data.createdAt {
                    points.append(DurationNodeModel(data: data.duration, dataDate: data.createdAt, hasTreatment: false, afterDate: false, treatmentDate: .now, treatmentType: "error"))
                }
            }
        }
        
        if points.count > 0 {
            firstPoint = points[0]
            points.remove(at: 0)
        }
        
        // numbers assigned to spots
        // first number is the index of the treatments
        // second is the amount on that day
        //var spots: [(Int, Int)] = []
        
        //
        var distance: (Double, Int) = (10000000000.0, -1)
        
        for treatment in entries.treatments {
            for index in 0..<points.count {
                if abs(treatment.date / points[index].dataDate) < distance.0 {
                    distance.0 = abs(treatment.date / points[index].dataDate)
                    distance.1 = index
                }
            }
            
            if distance.1 < points.count && distance.1 != -1 {
                if treatment.date > points[distance.1].dataDate {
                    points[distance.1].afterDate = true
                    
                    points[distance.1].hasTreatment = true
                    points[distance.1].treatmentDate = treatment.date
                    points[distance.1].treatmentType = treatment.type
                } else {
                    points[distance.1].afterDate = false
                    
                    points[distance.1].hasTreatment = true
                    points[distance.1].treatmentDate = treatment.date
                    points[distance.1].treatmentType = treatment.type
                }
            }
            
            distance = (10000000000.0, -1)
        }
    }
}

extension DurationGraph {
    private var yAxis: some View {
        Group {
            VStack(spacing: 0) {
                Text("\(height, specifier: "%.0f")")
                
                Spacer()
                
                Text("Seconds")
                    .rotationEffect(Angle(degrees: -90))
                    .frame(width: 130, height: 130)
                
                Spacer()
                
                Text("\(bottom, specifier: "%.0f")")
                
                Color.clear.frame(width: 1, height: 17)
            }
            .font(._fieldCopyRegular)
            .frame(width: 25)
            
            Color.white.frame(width: 2)
        }
    }
    
    private var baseline: some View {
        // Baseline shown here
        VStack(spacing: 0) {
            ZStack {
                GeometryReader { geo in
                    VStack(spacing: 0) {
                        /// Spacing above, the circle and spacing bellow the axis
                        Color.clear.frame(height: geo.size.height * nodes(duration: firstPoint.data).3)
                        
                        Button(action: {
                            self.showBaseline.toggle()
                        }) {
                            ZStack {
                                Text("\(firstPoint.data, specifier: "%.1f")").font(._fieldCopyBold)
                                    .offset(y: -20)
                                
                                Text("B")
                                    .font(._fieldCopyBold).foregroundColor(Color.white)
                                    .padding(.horizontal, 3).background(nodes(duration: firstPoint.data).0)
                                    .cornerRadius(10).padding(1).background(Color.white).cornerRadius(10)
                                    .frame(width: geo.size.height * 0.10, height: geo.size.height * nodes(duration: firstPoint.data).2)
                            }
                        }

                        Color.clear.frame(height: geo.size.height * nodes(duration: firstPoint.data).1)
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
                .frame(width: 75, height: 15)
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
            
            Color.clear.frame(height: 17)
        }
    }
    
    private var graphNodes: some View {
        
        // Rest of nodes shown here
        ForEach(points) { point in
            ZStack {
                VStack(spacing: 0) {
                    Color.clear.frame(height: 25)
                    
                    if point.hasTreatment {
                        if point.afterDate {
                            dottedLine
                                .offset(x: 20)
                        } else {
                            dottedLine
                                .offset(x: -20)
                        }
                    }
                }
                
                VStack(spacing: 0) {
                    GeometryReader { geo in
                        VStack(spacing: 0) {
                            Color.clear.frame(height: 20)
                            ZStack {
                                /// Spacing above, the circle and spacing bellow the axis
                                Color.clear.frame(height: geo.size.height * nodes(duration: point.data).3)
                                
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
                                                    .frame(width: geo.size.height * 0.10, height: geo.size.height * nodes(duration: point.data).2)
                                                    .offset(x: 20)
                                                    .padding(2)
                                            } else {
                                                Image(svm.rx_sign)
                                                    .resizable()
                                                    .frame(width: geo.size.height * 0.10, height: geo.size.height * nodes(duration: point.data).2)
                                                    .offset(x: -20)
                                                    .padding(2)
                                            }
                                        }
                                        
                                    }
                                    
                                    Spacer()
                                }
                                .frame(height: geo.size.height * nodes(duration: point.data).3)
                            }
                            .frame(height: geo.size.height * nodes(duration: point.data).3)
                            
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
                                        .background(Circle().fill(nodes(duration: point.data).0))
                                        .frame(width: geo.size.height * 0.10, height: geo.size.height * nodes(duration: point.data).2)
                                    Text("\(point.data, specifier: "%.1f")").font(._fieldCopyBold)
                                        .offset(y: -20)
                                }
                            }
                            
                            Color.clear.frame(height: geo.size.height * nodes(duration: point.data).1)
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
    
    private var targetBar: some View {
        ZStack {
            VStack(spacing: 0) {
                GeometryReader { geo in
                    VStack(spacing: 0) {
                        Color.indigo.opacity(0.5)
                            .frame(height: geo.size.height / 2)

                        Color.clear
                            .frame(height: geo.size.height / 2)
                    }
                    .frame(height: geo.size.height)
                }
                
                Color.clear.frame(height: 17)
            }
            
            VStack(spacing: 0) {
                GeometryReader { geo in
                    VStack(spacing: 0) {
                        Color.clear.opacity(0.5).frame(height: geo.size.height * spaceAroundTarget.1)

                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                Text(" \(settings.durationRange().0, specifier: "%.0f")")
                                    .font(._fieldCopyBold)
                                    .padding(.leading, 2.5)
                                Spacer()
                            }
                            Spacer()
                        }.frame(height: geo.size.height * spaceAroundTarget.0)

                    }
                    .frame(height: geo.size.height)
                }
                
                Color.clear.frame(height: 17)
            }
            .foregroundColor(Color.white.opacity(0.5))
            
        }
    }
    
    /// Will output nodes to be graphed on the duration graph
    /// They are as follows
    /// .3 is the spot above the node
    /// .2 is the spot of the node
    /// .1 is the spot bellow the node
    /// . 0 is color
    func nodes(duration: Double) -> (Color, Double, Double, Double) {
        var values: (Color, Double, Double, Double) = (Color.brown, 0.45, 0.1, 0.45)

        let difference = height - bottom
        
        values.3 = 0.9 * ((height - duration) / difference)
        values.2 = 0.10 // Locked to %10 of the view
        values.1 = 0.9 * ((duration - bottom) / difference)

        if duration > settings.durationRange().0 {
            values.0 = .green
        } else {
             values.0 = .red
        }
        
        return values
    }
    
    /// This is the area (in percentage bellow, in and on top of the target range
    var spaceAroundTarget: (Double, Double) {
        let difference = height - bottom
        
        return (difference/2, difference/2)
    }
}

struct DurationGraph_Previews: PreviewProvider {
    static var previews: some View {
        DurationGraph(tappedRecording: .constant(Date.now), showBaseline: .constant(false), deletionTarget: .constant((Date.now, String("string"))))
    }
}
