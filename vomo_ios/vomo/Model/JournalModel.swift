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
    var favorite: Bool
    
    init(createdAt: Date, noteName: String, note: String, favorite: Bool) {
        self.createdAt = createdAt
        self.noteName = noteName
        self.note = note
        self.favorite = favorite
    }
}
