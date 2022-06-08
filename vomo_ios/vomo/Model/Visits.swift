//
//  Visits.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/31/22.
//

import Foundation
import Combine
import SwiftUI

class Visits: ObservableObject {
    @Published var visits: [VisitModel] = [] {
        didSet { save() }
    }
    
    let key: String = "visits"
    
    func getItems() {
        self.getVisits()
    }
    
    func getVisits() {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let savedItems = try? JSONDecoder().decode([VisitModel].self, from: data)
        else { return }
        
        self.visits = savedItems
    }
    
    
    func save() {
        if let encodedData = try? JSONEncoder().encode(visits) {
            UserDefaults.standard.set(encodedData, forKey: key)
        }
    }
    
    func saveVisits() {
        self.saveVisits()
    }
}
