//
//  Entries.swift
//  VoMo
//
//  Created by Neil McGrogan on 4/18/22.
//

import Foundation
import Combine
import AVFoundation
import SwiftUI

class Entries: ObservableObject {
    @Published var recordings: [RecordingModel] = [] {
        didSet { saveRecordingItems() }
    }
    @Published var questionnaires: [QuestionnaireModel] = [] {
        didSet { saveQuestionnaireItems() }
    }
    @Published var questionnairesEffort: [QuestionnaireEffortModel] = [] {
        didSet { saveQuestionnaireItems() }
    }
    @Published var journals: [JournalModel] = [] {
        didSet { saveJournalItems() }
    }
    
    let recordingsItemsKey: String = "saved_recordings", questionnairesItemsKey: String = "saved_questionnaires", questionnairesEffortItemsKey: String = "saved_questionnaires_effort", journalsItemsKey: String = "saved_journals"
    
    func getItems() {
        self.getRecordings()
        self.getQuestionnaires()
        self.getQuestionnairesEffort()
        self.getJournals()
    }
    
    func getRecordings() {
        guard
            let data = UserDefaults.standard.data(forKey: recordingsItemsKey),
            let savedItems = try? JSONDecoder().decode([RecordingModel].self, from: data)
        else { return }
        
        self.recordings = savedItems
    }
    
    func getQuestionnaires() {
        guard
            let data = UserDefaults.standard.data(forKey: questionnairesItemsKey),
            let savedItems = try? JSONDecoder().decode([QuestionnaireModel].self, from: data)
        else { return }
        
        self.questionnaires = savedItems
    }
    
    func getQuestionnairesEffort() {
        guard
            let data = UserDefaults.standard.data(forKey: questionnairesEffortItemsKey),
            let savedItems = try? JSONDecoder().decode([QuestionnaireEffortModel].self, from: data)
        else { return }
        
        self.questionnairesEffort = savedItems
    }
    
    func getJournals() {
        guard
            let data = UserDefaults.standard.data(forKey: journalsItemsKey),
            let savedItems = try? JSONDecoder().decode([JournalModel].self, from: data)
        else { return }
        
        self.journals = savedItems
    }
    
    func saveRecordingItems() {
        if let encodedData = try? JSONEncoder().encode(recordings) {
            UserDefaults.standard.set(encodedData, forKey: recordingsItemsKey)
        }
    }
    
    func saveQuestionnaireItems() {
        if let encodedData = try? JSONEncoder().encode(questionnaires) {
            UserDefaults.standard.set(encodedData, forKey: questionnairesItemsKey)
        }
    }
    
    func saveQuestionnaireEffortItems() {
        if let encodedData = try? JSONEncoder().encode(questionnairesEffort) {
            UserDefaults.standard.set(encodedData, forKey: questionnairesEffortItemsKey)
        }
    }
    
    func saveJournalItems() {
        if let encodedData = try? JSONEncoder().encode(journals) {
            UserDefaults.standard.set(encodedData, forKey: journalsItemsKey)
        }
    }
    
    func saveItems() {
        self.saveJournalItems()
        self.saveQuestionnaireItems()
        self.saveQuestionnaireEffortItems()
        self.saveRecordingItems()
    }
    
    // Reusable Functions
    func uniqueDays() -> [Date] {
        var arr1: [Date] = []
        
        for item in self.recordings {
            arr1.append(item.createdAt.removeTimeStamp!)
        }
        
        for item in self.questionnaires {
            arr1.append(item.createdAt.removeTimeStamp!)
        }
        
        for item in self.questionnairesEffort {
            arr1.append(item.createdAt.removeTimeStamp!)
        }
        
        
        for item in self.journals {
            arr1.append(item.createdAt.removeTimeStamp!)
        }
        
        return arr1.uniqued()
    }
}

extension Entries {
    func eraseRecording(index: Int) {
        if index <= recordings.count - 1 {
            recordings.remove(at: index)
        }
    }
    
    func firstRecordingFromSpecifiedDay(day: Date, filterTask: Int) -> Date {
        var target: Date = .now
        
        if filterTask == 0 {
            for record in recordings {
                if day.toStringDay() == record.createdAt.toStringDay() {
                    target = record.createdAt
                    return target
                }
                //if day
            }
        } else {
            for record in recordings {
                if day.toStringDay() == record.createdAt.toStringDay() && record.taskNum == filterTask {
                    target = record.createdAt
                    return target
                }
            }
        }
        return target
    }
    
    func tasksPresent(day: Date) -> [String] {
        var target: [String] = []
        
        for record in recordings {
            if day.toStringDay() == record.createdAt.toStringDay() {
                if record.taskNum == 1 {
                    target.append("One")
                } else if record.taskNum == 2 {
                    target.append("Two")
                } else if record.taskNum == 3 {
                    target.append("Three")
                }
            }
        }
        
        return target
    }
    
    var recordingsPresent: Bool {
        return self.recordings.isEmpty
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
    }
}

class Keyboard: ObservableObject {
    @Published var present: Bool = false
}

class RecordState: ObservableObject {
    /*
     
     state:
     0 not recording
     1 recording
     2 recorded
     
     */
    @Published var state = 0
    @Published var task = 0
    @Published var selectedEntry: Date = .now
    func status() -> String {
        switch state {
        case 0:
            return "Tap the mic to record"
        case 1:
            return "Recording..."
        case 2:
            return "Stopped..."
        default:
            return "Error"
        }
    }
}

class Retrieve: ObservableObject {
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
}


