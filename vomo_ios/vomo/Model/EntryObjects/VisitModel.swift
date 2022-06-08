//
//  VisitModel.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/31/22.
//

import SwiftUI
import Foundation

class VisitModel: Identifiable, Codable {
    var date: Date
    var visitType: String
    
    init(date: Date, visitType: String) {
        self.date = date
        self.visitType = visitType
    }
}
