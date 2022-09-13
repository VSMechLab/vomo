//
//  JournalModel.swift
//  VoMo
//
//  Created by Neil McGrogan on 8/31/22.
//

import Foundation

class JournalModel: Identifiable, Codable {
    var createdAt: Date
    var noteName: String
    var note: String
    
    init(createdAt: Date, noteName: String, note: String) {
        self.createdAt = createdAt
        self.noteName = noteName
        self.note = note
    }
}
