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
    @Binding var showVHI: Bool
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                voiceQualitySection
                
                yLabel
                
                Color.white.frame(width: 2)
                
                // split into two areas:
                // the graph (scrollable) to the left, abnormal key on the right
                // the line at the bottom of the graph
                VStack(spacing: 0) {
                    ZStack {
                        if showVHI {
                            targetLine
                        }
                        
                        HStack(spacing: 10) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    graphNodes
                                }
                            }
                            
                            if showVHI {
                                abnormalKey
                            }
                        }
                    }
                    
                    Color.white.frame(height: 2)
                }
            }
        }
        .foregroundColor(.white)
    }
}

extension SurveyGraph {
    private var voiceQualitySection: some View {
        VStack {
            Text("Better\nVoice")
            Spacer()
            Text("Worse\nVoice")
        }
        .font(._bodyCopy)
        .frame(width: 47.5)
    }
    
    private var yLabel: some View {
        VStack(alignment: .trailing, spacing: 0) {
            Text(showVHI ? "40" : "50")
            Spacer()
            Text(showVHI ? "VHI-10" : "Vocal-Effort")
                .padding(.horizontal, -10)
                .rotationEffect(Angle(degrees: -90))
            Spacer()
            Text("0")
        }
        .font(._bodyCopy)
        .frame(width: 30)
    }
    
    private var targetLine: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                Color.clear.frame(height: geo.size.height * ((maxHeight() - 12) / maxHeight()))
                
                Color.white.frame(height: 2)
                
                Color.clear.frame(height: geo.size.height * ((12) / maxHeight()))
            }
            .frame(height: geo.size.height)
        }
    }
    
    private var abnormalKey: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: 0) {
                VStack {
                    Spacer()
                    Text("Abnormal")
                        .padding(.bottom, 5)
                }
                .frame(height: geo.size.height * ((maxHeight() - 12) / maxHeight()))
                
                VStack {
                    Text("Normal")
                        .padding(.top, 5)
                    Spacer()
                }
                .frame(height: geo.size.height * ((12) / maxHeight()))
            }
            .font(._bodyCopy)
            //.padding(.trailing, -30)
            .frame(height: geo.size.height)
        }
        .padding(.trailing, 5.0)
        .frame(width: 70)
        .padding(.leading, 5.0)
    }
    
    private var graphNodes: some View {
        ForEach(0..<nodes().count, id: \.self) { index in
            GeometryReader { geo in
                VStack(spacing: 0) {
                    Color.clear.frame(height: geo.size.height * nodes()[index].1)
                    
                    Rectangle()
                        .foregroundColor(Color.TEAL)
                        .border(Color.white, width: 2.5)
                        .frame(width: 27.5, height: geo.size.height * nodes()[index].0)
                }
                .frame(height: geo.size.height)
            }
            .padding(.horizontal, 5)
        }
    }
    
    func nodes() -> [(CGFloat, CGFloat)] {
        var ret: [(CGFloat, CGFloat)] = []
        
        
        if showVHI {
            for index in 0..<entries.questionnaires.count {
                if entries.questionnaires[index].score.0 != -1 {
                    let topArea = ((maxHeight() -  CGFloat(entries.questionnaires[index].score.0)) / maxHeight())
                    let bottomArea = (CGFloat(entries.questionnaires[index].score.0) / maxHeight())
                    
                    ret.append( (bottomArea , topArea) )
                }
            }
        } else {
            for index in 0..<entries.questionnaires.count {
                if entries.questionnaires[index].score.1 != -1 {
                    let topArea = ((maxHeight() -  CGFloat(entries.questionnaires[index].score.1)) / maxHeight())
                    let bottomArea = (CGFloat(entries.questionnaires[index].score.1) / maxHeight())
                    
                    ret.append( (bottomArea , topArea) )
                }
            }
        }
        
        return ret
    }
    
    /// The max hieght the graph will be out of
    func maxHeight() -> CGFloat {
        if showVHI {
            return 45
        } else {
            return 55
        }
    }
}

struct SurveyGraph_Previews: PreviewProvider {
    static var previews: some View {
        SurveyGraph(showVHI: .constant(false))
    }
}
