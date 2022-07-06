//
//  ScoresViewModel.swift
//  VoMo
//
//  Created by Neil McGrogan on 6/2/22.
//

import SwiftUI
import Foundation

/*
 
 Storing objects that correspond to thresholds set to constrain the graphs
 Functions 1-6 determine the settings for their corresponding graph
 Functions 7-12 read the values of these arrays
 They are stored in an array of integers
 index 0 is a value of 0, 1, 2, 3 (zero by default) this integer determines wether none are selected, lower bound is selected, middle, or greater bound is selected
 index 1 is the value of the lower threshold, 0 by default
 index 2 is the value of the upper threshold, inf by default
 
 */

struct ScoresViewModel {
    // Access Shared Defaults Object
    let userDefaults = UserDefaults.standard
    
    // Keys
    let pitchKey = "pitchKey"
    let cppKey = "cppKey"
    
}

extension ScoresViewModel {
    func savePitch(one: Int, two: Int, three: Int) {
        let arrStr = [String(one), String(two), String(three)]
        
        // Write/Set Array of Integers
        userDefaults.set(arrStr, forKey: pitchKey)
    }
    
    func saveCPP(one: Int, two: Int, three: Int) {
        let arrStr = [String(one), String(two), String(three)]
        
        // Write/Set Array of Integers
        userDefaults.set(arrStr, forKey: cppKey)
    }
}

extension ScoresViewModel {
    func readPitch() -> [Int] {
        var arr: [Int] = []
        // Read/Get Array of Integers
        let strArr: [String] = userDefaults.stringArray(forKey: pitchKey) ?? []
        if strArr.count == 3 {
            arr = [Int(strArr[0]) ?? 0, Int(strArr[1]) ?? 0,Int(strArr[2]) ?? 0]
        }
        
        return arr
    }
    
    func readCPP() -> [Int] {
        var arr: [Int] = []
        // Read/Get Array of Integers
        let strArr: [String] = userDefaults.stringArray(forKey: cppKey) ?? []
        if strArr.count == 3 {
            arr = [Int(strArr[0]) ?? 0, Int(strArr[1]) ?? 0,Int(strArr[2]) ?? 0]
        }
        
        return arr
    }
}
