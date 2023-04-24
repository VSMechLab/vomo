//
//  TreatmentModel.swift
//  VoMo
//
//  Created by Neil McGrogan on 8/31/22.
//

import SwiftUI
import Foundation

class TreatmentModel: Identifiable, Codable  {
    
    var date: Date
    var type: String
    var note: String
    
    init(date: Date, type: String, note: String) {
        self.date = date
        self.type = type
        self.note = note
    }
}
