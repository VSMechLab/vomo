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
    
    // Read/Get Array of Strings
    //var thresholds: [Double] = userDefaults.array(forKey: "myKey") ?? [0.0]
    
    // Append String to Array of Strings
    //thresholds.append(10)
    
    // Write/Set Array of Strings
    //userDefaults.set(strings, forKey: "myKey")
}
