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

class Entries: ObservableObject {
    @Published var interventions: [InterventionModel] = [] {
        didSet { saveInterventions() }
    }
    @Published var questionnaires: [QuestionnaireModel] = [] {
        didSet { saveQuestionnaireItems() }
    }
    @Published var journals: [JournalModel] = [] {
        didSet { saveJournalItems() }
    }
    @Published var selectedEntry: Date = .now
    @Published var focusDay: Date = .now
    @Published var focusDayExercise: Int = 0
    @Published var preciseRecord: Date = .now
    
    func totalDays(recordings: [Recording], journals: [JournalModel], questionnaires: [QuestionnaireModel]) -> [Date] {
        
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
    
    let questionnairesItemsKey: String = "saved_questionnaires", questionnairesEffortItemsKey: String = "saved_questionnaires_effort", journalsItemsKey: String = "saved_journals", interventionItemsKey: String = "saved_intervention"
    
    func getItems() {
        self.getQuestionnaires()
        self.getJournals()
        self.getInterventions()
    }
    
    
    func getQuestionnaires() {
        guard
            let data = UserDefaults.standard.data(forKey: questionnairesItemsKey),
            let savedItems = try? JSONDecoder().decode([QuestionnaireModel].self, from: data)
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
    
    func getInterventions() {
        guard
            let data = UserDefaults.standard.data(forKey: interventionItemsKey),
            let savedItems = try? JSONDecoder().decode([InterventionModel].self, from: data)
        else { return }
        
        self.interventions = savedItems
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
    func saveInterventions() {
        if let encodedData = try? JSONEncoder().encode(interventions) {
            UserDefaults.standard.set(encodedData, forKey: interventionItemsKey)
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

extension Entries {
    /*
    func removeAtCreated(createdAt: Date) {
        var index = 0
        for record in recordings {
            if createdAt == record.createdAt {
                recordings.remove(at: index)
            }
            index += 1
        }
    }
    
    func avgDuration(criteria: String) -> Float {
        var totalDur: Float = 0
        var index: Float = 0
        for record in recordings {
            if record.createdAt.toDay() == criteria {
                totalDur += record.duration
                index += 1
            }
        }
        return totalDur / index
    }
    
    func avgIntensity(criteria: String) -> Float {
        var totalInten: Float = 0
        var index: Float = 0
        for record in recordings {
            if record.createdAt.toDay() == criteria {
                totalInten += record.intensity
                index += 1
            }
        }
        return totalInten / index
    }
    
    func entrySearch(createdAt: Date) {
        /// Searches by createdAt date to return specific recording's duration
        for record in recordings {
            if createdAt == record.createdAt {
                print("Record found here: \(record.createdAt) matched")
            }
        }
    }
    
    func eraseRecord(createdAt: Date) {
        /// Searches by createdAt date to return specific recording's duration
        for record in recordings {
            if createdAt == record.createdAt {
                print("Should have removed here: \(record.createdAt) matched")
            }
        }
    }
    
    var recordingsPresent: Bool {
        // depricated, implement solution that looks at the AudioRecorder
        return false
        //return self.recordings.isEmpty
    }
    var journalsPresent: Bool {
        return self.journals.isEmpty
    }
    var questioinnairesPresent: Bool {
        return self.questionnaires.isEmpty
    }
    var questioinnairesEffortPresent: Bool {
        return self.questionnaires.isEmpty
    }
    
    // only show files from specific day and task
    func focused(createdAt: Date, task: Int) -> [RecordingModel] {
        let focused = self.recordings
        return focused
    }
    
    // Signal Processing Goes Here
    /*
     Return time of
     */
    
    func getAttribute(file: URL) -> Void {
        if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
           let customAttribute = attributes[FileAttributeKey.type] as? Date {
            
            print("Attribute: \(customAttribute)")
        } else {
            print("error")
        }
    }*/
}
