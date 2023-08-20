//
//  ExerciseModel.swift
//  VoMo
//
//  Created by Sam Burkhard on 8/9/23.
//

import Foundation

struct SyllableModel: Codable {

    var syllable: String // example: "Snowy" -> "Snow" + "y"
    var targetPitch: Int // Hz
    var length: Int // seconds
    
}

struct WordModel: Codable {
    
    var word: String
    var syllables: [SyllableModel]
    
}

struct ExerciseModel: Codable {
    
    var syllableCount: Int
    var length: Float
    
    var name: String
    
    var words: [WordModel]
    
}

struct ExerciseLibrary: Codable {
    
    var exercises: [ExerciseModel]
    
}
