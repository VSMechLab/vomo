//
//  ExerciseManager.swift
//  VoMo
//
//  Created by Sam Burkhard on 8/9/23.
//

import Foundation

fileprivate var library: [ExerciseModel] = [
    .init(syllableCount: 2, phrase: "Time flies"),
    .init(syllableCount: 3, phrase: "Bring it back"),
    .init(syllableCount: 4, phrase: "Cold and snowy"),
    .init(syllableCount: 5, phrase: "Come back right away")
]

/// Class for accessing pre-loaded and other voice exercises
class ExerciseManager {
    
    /// Returns exercise with this syllable count
    static func fetch(for syllableCount: Int) -> ExerciseModel? {
        return library.first(where: { $0.syllableCount == syllableCount }) // this is temporary. Replace letter with better loading system from json for local or remote fetch
    }
    
}
