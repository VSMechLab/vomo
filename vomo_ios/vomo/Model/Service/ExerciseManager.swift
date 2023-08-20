//
//  ExerciseManager.swift
//  VoMo
//
//  Created by Sam Burkhard on 8/9/23.
//

import Foundation

/// Class for accessing pre-loaded and other voice exercises
class ExerciseManager {
    
    static var library: ExerciseLibrary? = Bundle.main.decode(ExerciseLibrary.self, from: "BundledExercises.json")
    
    /// Returns exercise with this syllable count
    static func fetch(for syllableCount: Int) -> ExerciseModel? {
        return library?.exercises.first(where: { $0.syllableCount == syllableCount }) // this is temporary. Replace letter with better loading system from json for local or remote fetch
    }
    
}
