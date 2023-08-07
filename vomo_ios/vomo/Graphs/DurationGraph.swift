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
    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var audioRecorder = AudioRecorder.shared
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var entries: Entries
    
    @Binding var tappedRecording: Date
    @Binding var showBaseline: (Bool, Int)
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
            
            if firstPoint.data != 0.0 {
                
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
                
                if showMoreTreatmentInfo && currTreatment != .now {
                    Button(action: {
                        self.showMoreTreatmentInfo = false
                    }) {
                        VStack {
                            Spacer()
                            Text("\(currTreatment.dayOfWeek()) \(currTreatment.toDay()) at \(currTreatment.toStringHour())")
                                .font(Font._bodyCopyBold)
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
                
            } else {
                Button(action: {
                    viewRouter.currentPage = .record
                    settings.hyperLinkedRecording = 1
                    // To do, hyperlink to propper task
                }) {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("Record at least one entry")
                                        .underline(true, color: .white)
                                        .underline(true, color: .clear)
                                        + Text(" to see data on this graph")
                            Spacer()
                        }
                        .padding(.vertical, 5)
                        Spacer()
                    }
                }
            }
            
        }
        .font(._fieldCopyBold)
        .foregroundColor(Color.white)
        .onAppear() {
            findPoints()
        }
        .onChange(of: audioRecorder.processedData.last?.duration) { _ in
            findPoints()
            print("Changed")
        }
        .onChange(of: deletionTarget.0) { _ in
            findPoints()
        }
        .onChange(of: entries.treatments.count) { _ in
            findPoints()
            showMoreTreatmentInfo = false
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
        
        if points.count > 0 {
            firstPoint = points[0]
            points.remove(at: 0)
        } else {
            firstPoint.data = 0.0
        }
        
        height = settings.durationRange().1
        
        if points.isNotEmpty {
            var bot: Double = 10000.0
            
            for point in points {
                if point.data < bot {
                    bot = point.data
                }
            }
            if firstPoint.data < bot {
                bot = firstPoint.data
            }
            bottom = 0.75 * bot
            
            // Assign height here as well
            var hei = 0.0
            
            for point in points {
                if point.data > hei {
                    hei = point.data
                }
            }
            if firstPoint.data > hei {
                hei = firstPoint.data
            }
            
            if hei > settings.durationRange().1 {
                height = 1.05 * hei
            } else {
                height = settings.durationRange().1
            }
        } else {
            var bot: Double = 10000.0
            if firstPoint.data < bot {
                bot = firstPoint.data
                print("Assigning here: \(firstPoint.data)")
            }
            bottom = 0.75 * bot
            
            // Assign height here as well
            var hei = 0.0
            if firstPoint.data > hei {
                hei = firstPoint.data
            }
            if hei > settings.durationRange().1 {
                height = 1.05 * hei
            } else {
                height = settings.durationRange().1
            }
        }
    }
}

extension DurationGraph {
    private var yAxis: some View {
        Group {
            VStack(spacing: 0) {
                // Basic spacing
                Color.clear.frame(width: 1, height: 20)
                
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
            
            VStack(spacing: 0) {
                // Basic spacing
                Color.clear.frame(width: 1, height: 20)
                
                Color.white.frame(width: 2)
            }
        }
    }
    
    private var baseline: some View {
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
                    VStack(spacing: 0) {
                        Color.clear.frame(height: geo.size.height * nodes(duration: firstPoint.data).3)
                        
                        Button(action: {
                            if showBaseline.0 && showBaseline.1 != 2 {
                                self.showBaseline.1 = 2
                            } else {
                                self.showBaseline.0.toggle()
                                self.showBaseline.1 = 2
                            }
                        }) {
                            ZStack {
                                Text("\(firstPoint.data, specifier: "%.1f")")
                                    .offset(y: -20)
                                Text("B")
                                    .padding(.horizontal, 3).background(nodes(duration: firstPoint.data).0)
                                    .cornerRadius(10).padding(1).background(Color.white).cornerRadius(10)
                                    .frame(width: geo.size.height * 0.10, height: geo.size.height * 0.10)
                            }
                        }
                        
                        Color.clear.frame(height: geo.size.height * nodes(duration: firstPoint.data).1)
                    }
                }
                
                /// bottom of axis & date
                Color.white.frame(height: 2)
                Text("\(firstPoint.dataDate.baselineLabel())")
                    .font(._day)
                    .frame(width: 75, height: 15)
            }
        }
        .frame(width: 75)
    }
    
    private var rxSign: some View {
        Image(svm.rx_sign)
            .resizable()
            .frame(width: 20, height: 20)
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
                
                // Point shown here
                VStack(spacing: 0) {
                    // Basic spacing
                    Color.clear.frame(width: 1, height: 20)
                    
                    GeometryReader { geo in
                        VStack(spacing: 0) {
                            Color.clear.frame(height: geo.size.height * nodes(duration: point.data).3)
                            
                            Button(action: {
                                if self.tappedRecording == point.dataDate {
                                    self.tappedRecording = .now
                                } else {
                                    self.tappedRecording = point.dataDate
                                }
                            }) {
                                ZStack {
                                    Text("\(point.data, specifier: "%.1f")")
                                        .offset(y: -20)
                                    Text("B")
                                        .foregroundColor(.clear)
                                        .padding(.horizontal, 3).background(nodes(duration: point.data).0)
                                        .cornerRadius(10).padding(1).background(Color.white).cornerRadius(10)
                                        .frame(width: geo.size.height * 0.10, height: geo.size.height * 0.10)
                                }
                            }
                            
                            Color.clear.frame(height: geo.size.height * nodes(duration: point.data).1)
                        }
                    }
                    
                    /// bottom of axis & date
                    Color.white.frame(height: 2)
                    Text("\(point.dataDate.nodeLabel())")
                        .font(._day)
                        .frame(width: point.hasTreatment ? 100 : 50, height: 15)
                }
                
            }.frame(width: point.hasTreatment ? 100 : 50)
        }
    }
    
    private var targetBar: some View {
        VStack(spacing: 0) {
            // Basic spacing
            Color.clear.frame(width: 1, height: 20)
            
            if (nodes(duration: settings.durationRange().0).3 / 0.90) > 1 {
                GeometryReader { geo in
                    Color.indigo.opacity(0.5)
                        .frame(width: geo.size.width, height: geo.size.height)
                }
            } else {
                GeometryReader { geo in
                    VStack(spacing: 0) {
                        ZStack {
                            Color.indigo.opacity(0.5)
                                .frame(height: geo.size.height * nodes(duration: settings.durationRange().0).3 / 0.90)
                            VStack {
                                Spacer()
                                HStack {
                                    Text(" \(settings.durationRange().0, specifier: "%.0f")")
                                        .font(._fieldCopyBold)
                                        .padding(2.5)
                                    Spacer()
                                }
                            }
                        }
                        .frame(height: geo.size.height * nodes(duration: settings.durationRange().0).3 / 0.90)
                        Color.clear
                            .frame(height: geo.size.height * nodes(duration: settings.durationRange().0).1 / 0.90)
                    }
                }
            }
            Color.clear.frame(height: 17)
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

        if duration >= settings.durationRange().0 {
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
        DurationGraph(tappedRecording: .constant(Date.now), showBaseline: .constant((false, 2)), deletionTarget: .constant((Date.now, String("string"))))
    }
}
