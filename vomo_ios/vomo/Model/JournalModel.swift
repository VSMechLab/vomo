//
//  JournalModel.swift
//  VoMo
//
//  Created by Neil McGrogan on 8/31/22.
//

import Foundation

class JournalModel: Identifiable, Codable {
    var createdAt: Date
    var note: String
    var favorite: Bool
    
    init(createdAt: Date, note: String, favorite: Bool) {
        self.createdAt = createdAt
        self.note = note
        self.favorite = favorite
    }
}
