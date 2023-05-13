//
//  Entries.swift
//  VoMo
//
//  Created by Neil McGrogan on 8/31/22.
//

import Foundation
import Combine
import AVFoundation
import SwiftUI

/// Entries - stores journals, surveys and treatments
class Entries: ObservableObject {
    @Published var treatments: [TreatmentModel] = [] {
        didSet { saveTreatments() }
    }
    
    @Published var questionnaires: [SurveyModel] = [] {
        didSet { saveQuestionnaireItems() }
    }
    
    @Published var journals: [JournalModel] = [] {
        didSet { saveJournalItems() }
    }
    
    @Published var selectedEntry: Date = .now
    @Published var focusDay: Date = .now
    @Published var focusDayExercise: Int = 0
    @Published var preciseRecord: Date = .now
    
    var journalsThisWeek: Int {
        var ret = 0
        
        let startOfWeek = Date.now.startOfWeek ?? .now
        
        for journal in journals {
            if journal.createdAt < startOfWeek {
                ret += 1
            }
        }
        return ret
    }
    
    var surveysThisWeek: Int {
        var ret = 0
        
        let startOfWeek = Date.now.startOfWeek ?? .now
        
        for survey in questionnaires {
            if survey.createdAt < startOfWeek {
                ret += 1
            }
        }
        return ret
    }
    
    func totalDays(recordings: [Recording], journals: [JournalModel], questionnaires: [SurveyModel]) -> [Date] {
        
        var returnable: [Date] = []
        for record in recordings {
            returnable.append(record.createdAt)
        }
        for journal in journals {
            returnable.append(journal.createdAt)
        }
        for questionnaire in questionnaires {
            returnable.append(questionnaire.createdAt)
        }
        
        return returnable
    }
    
    let questionnairesItemsKey: String = "saved_questionnaires", questionnairesEffortItemsKey: String = "saved_questionnaires_effort", journalsItemsKey: String = "saved_journals", treatmentsItemsKey: String = "saved_treatments"
    
    func getItems() {
        self.getQuestionnaires()
        self.getJournals()
        self.getTreatments()
    }
    
    
    func getQuestionnaires() {
        guard
            let data = UserDefaults.standard.data(forKey: questionnairesItemsKey),
            let savedItems = try? JSONDecoder().decode([SurveyModel].self, from: data)
        else { return }
        
        self.questionnaires = savedItems
    }
    
    func getJournals() {
        guard
            let data = UserDefaults.standard.data(forKey: journalsItemsKey),
            let savedItems = try? JSONDecoder().decode([JournalModel].self, from: data)
        else { return }
        
        self.journals = savedItems
    }
    
    func getTreatments() {
        guard
            let data = UserDefaults.standard.data(forKey: treatmentsItemsKey),
            let savedItems = try? JSONDecoder().decode([TreatmentModel].self, from: data)
        else { return }
        
        self.treatments = savedItems
    }
    
    func saveQuestionnaireItems() {
        if let encodedData = try? JSONEncoder().encode(questionnaires) {
            UserDefaults.standard.set(encodedData, forKey: questionnairesItemsKey)
        }
    }
    func saveJournalItems() {
        if let encodedData = try? JSONEncoder().encode(journals) {
            UserDefaults.standard.set(encodedData, forKey: journalsItemsKey)
        }
    }
    func saveTreatments() {
        if let encodedData = try? JSONEncoder().encode(treatments) {
            UserDefaults.standard.set(encodedData, forKey: treatmentsItemsKey)
        }
    }
    
    // Reusable Functions
    func uniqueDays() -> [Date] {
        var arr1: [Date] = []
        
        for item in self.questionnaires {
            arr1.append(item.createdAt.removeTimeStamp!)
        }
        
        for item in self.journals {
            arr1.append(item.createdAt.removeTimeStamp!)
        }
        
        return arr1.uniqued()
    }
    
    var weeklyRecordings: [(String, Double)] {
        /// String one will be the start of the week, Double will be the count of entries for that week
        var arr: [(String, Double)] = []
        
        var recordCount = 0
        var startDate = Date(timeInterval: -6048000, since: .now).startOfWeek ?? .now
        
        while startDate < .now {
            /*
             loop through all recordings
             count plus one if a recording is present within a time range
             Logic -> if (date > startDate) && (date < startDate.endDate)
             */
            /*
            for record in recordings {
                if (record.createdAt > startDate) && (record.createdAt < startDate.endOfWeek ?? .now) || (record.createdAt.toDay() == startDate.endOfWeek?.toDay()) {
                    recordCount += 1
                }
            }
            */
            if recordCount > 0 {
                arr.append((startDate.toDay(), Double(recordCount)))
            }
            
            recordCount = 0
            
            startDate = Date(timeInterval: 604800, since: startDate)
        }
        
        return arr
    }
}
