//
//  SurveyGraphFunctions.swift
//  VoMo
//
//  Created by Neil McGrogan on 3/27/23.
//

import Foundation
import SwiftUI

extension SurveyGraph {
    
    func findPoints() {
        points = []
        firstPoint = SurveyNodeModel(data: -1.0, secondPoint: -1.0, dataDate: .now, hasTreatment: false, afterDate: false, treatmentDate: .now, treatmentType: "")
        
        for data in entries.questionnaires {
            if data.score.0 != -1 && surveySelection == 0 {
                points.append(SurveyNodeModel(data: data.score.0, secondPoint: -1.0, dataDate: data.createdAt, hasTreatment: false, afterDate: false, treatmentDate: .now, treatmentType: "error"))
                
            } else if data.score.1 != -1 && surveySelection == 1 || data.score.2 != -1 && surveySelection == 1 {
                points.append(SurveyNodeModel(data: data.score.1, secondPoint: data.score.2, dataDate: data.createdAt, hasTreatment: false, afterDate: false, treatmentDate: .now, treatmentType: "error"))
            } else if data.score.3 != -1 && surveySelection == 2 {
                
                points.append(SurveyNodeModel(data: data.score.3, secondPoint: -1.0, dataDate: data.createdAt, hasTreatment: false, afterDate: false, treatmentDate: .now, treatmentType: "error"))
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
    }
    
    /// The max hieght the graph will be out of
    func maxHeight() -> CGFloat {
        if surveySelection == 0 {
            return 40
        } else if surveySelection == 1 {
            return 55
        } else {
            return 120
        }
    }
    
    /// First point, then second point
    func nodes(value: Double) -> (Color, Double, Double, Double) {
        var values: (Color, Double, Double, Double) = (Color.brown, 0.45, 0.1, 0.45)
        
        let difference = height - bottom
        values.3 = 0.9 * ((height - value) / difference)
        values.2 = 0.10 // Locked to %10 of the view
        values.1 = 0.9 * ((value - bottom) / difference)

        if surveySelection == 1 {
            values.0 = .DARK_PURPLE
        } else if surveySelection == 2 {
            values.0 = .BRIGHT_PURPLE
        } else if surveySelection == 0 {
            
            // if the right survey
            // if within threshold, make green, else make red
            // threshold is value > x red
            // threshold is value < x green
            
            if value <= 12 {
                values.0 = .green
            } else {
                values.0 = .red
            }
        } else {
            values.0 = .TEAL
        }
        
        return values
    }
    
    func findType() -> String {
        for treatment in entries.treatments {
            if treatment.date == currTreatment {
                return treatment.type
            }
        }
        return ""
    }
    
}
