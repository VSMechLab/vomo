//
//  SurveyGraph.swift
//  VoMo
//
//  Created by Neil McGrogan on 12/28/22.
//

import SwiftUI

class SurveyNodeModel: Identifiable, Codable {
    var data: Double
    var secondPoint: Double
    var dataDate: Date
    var hasTreatment: Bool
    var afterDate: Bool
    var treatmentDate: Date
    var treatmentType: String
    
    init(data: Double, secondPoint: Double, dataDate: Date, hasTreatment: Bool, afterDate: Bool, treatmentDate: Date, treatmentType: String) {
        self.data = data
        self.secondPoint = secondPoint
        self.dataDate = dataDate
        self.hasTreatment = hasTreatment
        self.afterDate = afterDate
        self.treatmentDate = treatmentDate
        self.treatmentType = treatmentType
    }
}

struct SurveyGraph: View {
    @EnvironmentObject var entries: Entries
    @EnvironmentObject var settings: Settings
    @Binding var surveySelection: Int
    @Binding var tappedRecording: Date
    @Binding var deletionTarget: (Date, String)
    
    let svm = SharedViewModel()
    
    @State var showMoreTreatmentInfo = false
    @State var firstPoint: SurveyNodeModel = SurveyNodeModel(data: -1.0, secondPoint: -1.0, dataDate: .now, hasTreatment: false, afterDate: false, treatmentDate: .now, treatmentType: "")
    @State var points: [SurveyNodeModel] = []
    @State var currTreatment: Date = .now
    
    @State var height = 100.0
    @State var bottom = 0.0
    
    var body: some View {
        ZStack {
            /// This hstack will contain three things
            /// Y axis with labels
            /// Body of the graph
            HStack(spacing: 0) {
                if surveySelection == 0 || surveySelection == 3 {
                    voiceQualitySection
                }
                
                yLabel
                Color.white.frame(width: 2)
                
                ZStack {
                    if surveySelection == 0 {
                        abnormalKey
                    }
                    
                    HStack(spacing: 0 ) {
                        if firstPoint.data != -1 || firstPoint.secondPoint != -1 {
                            baseline
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack (spacing: 0 ) {
                                graphNodes
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .onAppear() {
                findPoints()
                if surveySelection == 0 {
                    height = 40
                }
            }
            .onChange(of: surveySelection) { _ in
                findPoints()
                if surveySelection == 0 {
                    height = 40
                } else {
                    height = 100
                }
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
            
            // Graph pyhsical/mental label
            if surveySelection == 1 {
                
                HStack(spacing: 0) {
                    Spacer()
                    
                    VStack(spacing: 0) {
                        Text("Physical")
                            .font(._fieldCopyBold).foregroundColor(Color.white)
                            .padding(.horizontal, 3).background(Color.TEAL.frame(width: 100))
                            .cornerRadius(10).padding(1).background(Color.white).cornerRadius(10)
                            .padding(0.5)
                        
                        Text(" Mental ")
                            .font(._fieldCopyBold).foregroundColor(Color.white)
                            .padding(.horizontal, 3).background(Color.DARK_PURPLE.frame(width: 100))
                            .cornerRadius(10).padding(1).background(Color.white).cornerRadius(10)
                            .padding(0.5)
                        
                        Spacer()
                    }
                }
                
            }
            
        }
        .foregroundColor(.white)
        .onChange(of: deletionTarget.0) { _ in
            findPoints()
        }
        .onChange(of: entries.treatments.count) { _ in
            findPoints()
            showMoreTreatmentInfo = false
        }
        .onChange(of: entries.questionnaires.count) { _ in
            findPoints()
        }
    }
}


struct SurveyGraph_Previews: PreviewProvider {
    static var previews: some View {
        SurveyGraph(surveySelection: .constant(1), tappedRecording: .constant(.now), deletionTarget: .constant((Date.now, "")))
    }
}
