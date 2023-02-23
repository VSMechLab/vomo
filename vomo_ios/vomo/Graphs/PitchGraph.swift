//
//  PitchGraph.swift
//  VoMo
//
//  Created by Neil McGrogan on 12/27/22.
//

import SwiftUI


/*
 Consider lowering the 2x the top of the target
 
 1.5 would safice
 
 */
struct PitchGraph: View {
    @EnvironmentObject var audioRecorder: AudioRecorder
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var entries: Entries
    
    @Binding var tappedRecording: Date
    
    let height = 300.0
    let bottom = 0.0
    
    var body: some View {
        
        /// This hstack will contain three things
        /// Y axis with labels
        /// Body of the graph
        HStack(spacing: 0) {
            
            /// Contains the label for the y axis and the y axis
            /// Will have a fixed range height of 300 hz
            /// Will have a fixed range bottom of 0 hz
            yAxis
            
            ScrollView(.horizontal, showsIndicators: false) {
                ZStack {
                    treatmentSection
                    
                    targetBar
                    
                    nodes
                }
            }
            
            Spacer()
        }
    }
}

extension PitchGraph {
    func treatments() -> [(Bool, Date)] {
        
        /// Loop through treatments and processedData
        /// For a given treatment find the closest entry or one on the same day
        /// return a loop with the same length as the processedData
        
        let ret: [(Bool, Date)] = []
        
        for record in audioRecorder.recordings {
            
            
            for treatment in entries.treatments {
                if record.taskNum == 10 && treatment.type == "" {
                    print("")//("\(record), \(treatment)")
                }
            }
        }
        
        return ret
    }
    
    private var treatmentSection: some View {
        HStack(spacing: 0) {
            ForEach(0..<treatments().count, id: \.self) { index in
                VStack(spacing: 0) {
                    
                    // if the intervention is close to a day
                    
                    if treatments()[index].0 {
                        
                        /// Overlay the interventions, should be tappable
                        Color.blue
                    }
                    
                    
                    // end loop
                    
                    /// bottom of axis & date=
                    Color.clear
                        .font(._fieldCopyRegular)
                        .frame(width: 50, height: 17)
                }
            }
        }
    }
    
    private var yAxis: some View {
        Group {
            VStack(spacing: 0) {
                Text("\(height, specifier: "%.0f")")
                
                Spacer()
                
                Text(settings.focusSelection == 4 ? "Target Range hz" : "Normal Range hz")
                    .rotationEffect(Angle(degrees: -90))
                    .frame(width: 100, height: 100)
                
                Spacer()
                
                Text("\(bottom, specifier: "%.0f")")
                
                Color.clear.frame(width: 1, height: 17)
            }
            .font(._fieldCopyRegular)
            .frame(width: 25)
            
            Color.white.frame(width: 2)
        }
    }
    
    private var nodes: some View {
        HStack(spacing: 0) {
            ForEach(0..<audioRecorder.processedData.count, id: \.self) { index in
                VStack(spacing: 0) {
                    GeometryReader { geo in
                        VStack(spacing: 0) {
                            /// Spacing above, the circle and spacing bellow the axis
                            Color.clear.frame(height: geo.size.height * nodes(pitch: audioRecorder.processedData[index]).3)
                            
                            Button(action: {
                                //print(audioRecorder.processedData[index])
                                self.tappedRecording = audioRecorder.processedData[index].createdAt
                            }) {
                                Circle()
                                    .strokeBorder(.white, lineWidth: 2)
                                    .background(Circle().fill(nodes(pitch: audioRecorder.processedData[index]).0))
                                    .frame(width: geo.size.height * 0.10, height: geo.size.height * nodes(pitch: audioRecorder.processedData[index]).2)
                            }

                            Color.clear.frame(height: geo.size.height * nodes(pitch: audioRecorder.processedData[index]).1)
                        }
                    }
                    
                    /// bottom of axis & date
                    Color.white.frame(height: 2)
                    Text("\(audioRecorder.processedData[index].createdAt.shortDay())")
                        .font(._fieldCopyRegular)
                        .frame(width: 50, height: 15)
                }
            }
        }
    }
    
    private var targetBar: some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                VStack(spacing: 0) {
                    Color.clear.frame(height: geo.size.height * spaceAroundTarget.2)
                    
                    Color.indigo.opacity(0.5).frame(height: geo.size.height * spaceAroundTarget.1)
                    
                    Color.clear.frame(height: geo.size.height * spaceAroundTarget.0)
                }
                .frame(height: geo.size.height)
            }
            
            Color.clear.frame(height: 17)
        }
    }
    
    /// Will output nodes to be graphed on the pitch graph
    /// They are as follows
    /// .3 is the spot above the node
    /// .2 is the spot of the node
    /// .1 is the spot bellow the node
    /// . 0 is color
    func nodes(pitch: ProcessedData) -> (Color, CGFloat, CGFloat, CGFloat) {
        var values: (Color, CGFloat, CGFloat, CGFloat) = (Color.brown, 0.45, 0.1, 0.45)

        // .3 top:     0.9 * ((height - CGFloat(pitch.pitch_mean)) / height)
        // .2 mid:     0.10 // Locked to %10 of the view
        // .1 bottom:  0.9 * ((CGFloat(pitch.pitch_min) - bottom) / height)
        
        values.3 = 0.9 * ((height - CGFloat(pitch.pitch_mean)) / height)
        values.2 = 0.10 // Locked to %10 of the view
        values.1 = 0.9 * ((CGFloat(pitch.pitch_mean) - bottom) / height)

        if CGFloat(pitch.pitch_mean) > settings.pitchRange().0 && CGFloat(pitch.pitch_mean) < settings.pitchRange().1 {
            values.0 = .green
        } else if CGFloat(pitch.pitch_mean) > (0.85 * settings.pitchRange().0) && CGFloat(pitch.pitch_mean) < (1.15 * settings.pitchRange().1)  {
             values.0 = .yellow
        } else {
             values.0 = .red
        }
        
        
        return values
    }
    
    /// This is the area (in percentage bellow, in and on top of the target range
    var spaceAroundTarget: (CGFloat, CGFloat, CGFloat) {
        let bottom = settings.pitchRange().0 / height
        let middle = (settings.pitchRange().1 - settings.pitchRange().0) / height
        let top = (height - settings.pitchRange().1) / height

        return (bottom, middle, top)
    }
}

struct PitchGraph_Previews: PreviewProvider {
    static var previews: some View {
        PitchGraph(tappedRecording: .constant(Date.now))
    }
}
