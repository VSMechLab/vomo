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
    var type: String
    var note: String
    
    init(date: Date, type: String, note: String) {
        self.date = date
        self.type = type
        self.note = note
    }
}
