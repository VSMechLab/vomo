//
//  SurveyGraph.swift
//  VoMo
//
//  Created by Neil McGrogan on 12/28/22.
//

import SwiftUI

struct SurveyGraph: View {
    @EnvironmentObject var entries: Entries
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                VStack {
                    Text("Worse\nVoice")
                    Spacer()
                    Text("Better\nVoice")
                }
                .frame(width: 50)
                Color.white.frame(width: 2)
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            graphNodes
                        }
                        .padding(.horizontal)
                        
                        Color.white.frame(height: 2)
                    }
                }
                Text("Normal Range")
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
        /*
        for index in 0..<entries.questionnaires.count {
            if max < entries.questionnaires[index].pitch_mean {
                max = entries.questionnaires[index].pitch_mean
            }
        }*/
        // Add 15%
        return max * 1.15 + 50
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

extension SurveyGraph {
    private var graphNodes: some View {
        ForEach(0..<entries.questionnaires.count, id: \.self) { index in
            VStack {
                Spacer()
                Rectangle()
                    .frame(width: 50)
                    .padding(.horizontal)
            }
        }
    }
}

struct SurveyGraph_Previews: PreviewProvider {
    static var previews: some View {
        SurveyGraph()
    }
}
