//
//  PitchGraph.swift
//  VoMo
//
//  Created by Neil McGrogan on 12/27/22.
//

import SwiftUI

struct PitchGraph: View {
    @EnvironmentObject var audioRecorder: AudioRecorder
    @EnvironmentObject var settings: Settings
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                VStack {
                    Text("Higher ")
                    Spacer()
                    Text("(Hertz) ").rotationEffect(Angle(degrees: -90))
                    Spacer()
                    Text("Lower ")
                }
                Color.white.frame(width: 2)
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            graphNodes
                        }
                        Color.white.frame(height: 2)
                    }
                }
                Text(settings.focusSelection == 4 ? "Target Range" : "Normal Range")
                    .rotationEffect(Angle(degrees: 90))
                    .padding(.trailing, -30)
            }
            
            HStack {
                Text("Less recent")
                Spacer()
                Text("More recent")
            }
        }
        .foregroundColor(.white)
    }
    
    /// Area one is green (above the threshold)
    /// Area two is yellow (low but in threshold)
    /// Area three is red (bellow threshold)
    func safeZoneArea(pitch: Float) -> Int {
        return 1
    }
    
    /// This is the maxomum value that the graph will display
    /// This has 15% added to it to add a buffer for displaying numbers correcty
    var maxHeight: Float {
        var max: Float = 0.0
        for index in 0..<audioRecorder.processedData.count {
            if max < audioRecorder.processedData[index].pitch_mean {
                max = audioRecorder.processedData[index].pitch_mean
            }
        }
        // Add 15%
        return max * 1.15
    }
    
    /// This returns the heights of the individual bars on the graph
    func heights(pitch: Float) -> (Float, Float) {
        // audioRecorder.processedData[index].pitch_mean is the pitch
        
        /*
         
         In this calculation,
         
         the top section is equal to the % difference between the maxHeight and the mean
         the middle section is equal to %10 no matter what
         the last section is equal to the % difference between the mean and zero
         
         to find the top...
         take the max-current
         
         */
        
        let top: Float = (1 - (pitch / maxHeight)) * 0.80
        let bot: Float = (pitch / maxHeight) * 0.80
        
        print("the values calculated are as follows: \(top), \(bot)")
        
        
        return (top, bot)
    }
}

extension PitchGraph {
    private var graphNodes: some View {
        ForEach(0..<audioRecorder.processedData.count, id: \.self) { index in
            // fill should be proportional to the height / max height for a given point
            GeometryReader { geo in
                // The height here is equal to the maximum height of the view
                VStack(spacing: 0) {
                    // Minimum will always be zero
                    // max pitch value will always be such
                    // max that the graph will display will be %10 higher than the max pitch
                    ZStack {
                        Color.clear
                        VStack(spacing: 0) {
                            Spacer()
                            Text("\(audioRecorder.processedData[index].pitch_mean, specifier: "%.0f")")
                        }
                    }
                    .frame(height: geo.size.height * CGFloat(heights(pitch: audioRecorder.processedData[index].pitch_mean).0))
                    
                    VStack(spacing: 0) {
                        Color.white
                            .frame(width: 2, height: geo.size.height * 0.12)
                        
                        switch safeZoneArea(pitch: audioRecorder.processedData[index].pitch_mean) {
                        case 1:
                            Circle()
                                .strokeBorder(.white, lineWidth: 2)
                                .background(Circle().fill(.green))
                                .frame(width: geo.size.height * 0.16, height: geo.size.height * 0.16)
                        case 2:
                            Circle()
                                .strokeBorder(.white, lineWidth: 2)
                                .background(Circle().fill(.yellow))
                                .frame(width: geo.size.height * 0.16, height: geo.size.height * 0.16)
                        case 3:
                            Circle()
                                .strokeBorder(.white, lineWidth: 2)
                                .background(Circle().fill(.red))
                                .frame(width: geo.size.height * 0.16, height: geo.size.height * 0.16)
                        default:
                            Color.white
                                .frame(width: geo.size.height * 0.16, height: geo.size.height * 0.16)
                                .cornerRadius(12)
                        }
                        
                        Color.white
                            .frame(width: 2, height: geo.size.height * 0.12)
                    }
                    .frame(height: geo.size.height * 0.40)
                    
                    VStack {
                        Color.clear
                    }
                    .frame(height: geo.size.height * CGFloat(heights(pitch: audioRecorder.processedData[index].pitch_mean).1))
                }
            }
            .frame(width: 50)
        }
    }
}

struct PitchGraph_Previews: PreviewProvider {
    static var previews: some View {
        PitchGraph()
    }
}
