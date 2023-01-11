//
//  ProgressViewFunctions.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/29/22.
//

import SwiftUI
import Foundation

/// Functions served exclusively for the ProgressView
extension ProgressView {
    func refilter() {
        entries.getItems()
        if filters.isEmpty {
            filteredList = []
            var usedDates: [String] = []
            for index in 0..<audioRecorder.recordings.count {
                usedDates.append(audioRecorder.recordings[index].createdAt.toDay())
            }
            for index in 0..<entries.questionnaires.count {
                usedDates.append(entries.questionnaires[index].createdAt.toDay())
            }
            for index in 0..<entries.journals.count {
                usedDates.append(entries.journals[index].createdAt.toDay())
            }
            usedDates = usedDates.uniqued()
            
            for day in usedDates {
                var date: Date = .now
                var strs: [String] = []
                var preciseDates: [Date] = []
                
                for audio in audioRecorder.recordings {
                    if day == audio.createdAt.toDay() {
                        if filters.isEmpty || filters.contains(audioRecorder.taskNum(file: audio.fileURL)) {
                            strs.append(audioRecorder.viewableTask(file: audio.fileURL))
                            preciseDates.append(audio.createdAt)
                            date = audio.createdAt
                        }
                    }
                }
                for quest in entries.questionnaires {
                    if day == quest.createdAt.toDay() {
                        if filters.isEmpty || filters.contains("Survey") {
                            strs.append("Survey")
                            preciseDates.append(quest.createdAt)
                            date = quest.createdAt
                        }
                    }
                }
                for journ in entries.journals {
                    if day == journ.createdAt.toDay() {
                        if filters.isEmpty || filters.contains("Journal") {
                            strs.append("Journal")
                            preciseDates.append(journ.createdAt)
                            date = journ.createdAt
                        }
                    }
                }
                
                if strs.count > 0 {
                    filteredList.append(Element(date: date, preciseDate: preciseDates, str: strs))
                }
                date = .now
                strs.removeAll()
            }
        } else {
            filteredList = []
            var usedDates: [String] = []
            for index in 0..<audioRecorder.recordings.count {
                
                if filters.contains("Vowel") &&
                    audioRecorder.taskNum(selection: 1, file: audioRecorder.recordings[index].fileURL)
                {
                    
                    
                    
                    usedDates.append(audioRecorder.recordings[index].createdAt.toDay())
                }
                if filters.contains("Duration") && audioRecorder.taskNum(selection: 2, file: audioRecorder.recordings[index].fileURL) {
                    usedDates.append(audioRecorder.recordings[index].createdAt.toDay())
                }
                if filters.contains("Rainbow") && audioRecorder.taskNum(selection: 3, file: audioRecorder.recordings[index].fileURL) {
                    usedDates.append(audioRecorder.recordings[index].createdAt.toDay())
                }
                if filters.contains("Favorite") {
                    usedDates.append(audioRecorder.recordings[index].createdAt.toDay())
                }
            }
            for index in 0..<entries.questionnaires.count {
                usedDates.append(entries.questionnaires[index].createdAt.toDay())
            }
            for index in 0..<entries.journals.count {
                usedDates.append(entries.journals[index].createdAt.toDay())
            }
            usedDates = usedDates.uniqued()
            
            for day in usedDates {
                var date: Date = .now
                var strs: [String] = []
                var preciseDates: [Date] = []
                
                for audio in audioRecorder.recordings {
                    if day == audio.createdAt.toDay() {
                        if filters.contains(audioRecorder.taskNum(file: audio.fileURL)) {
                            strs.append(audioRecorder.viewableTask(file: audio.fileURL))
                            preciseDates.append(audio.createdAt)
                            date = audio.createdAt
                        } else if filters.contains("Favorite") {
                            print("level 1")
                            
                            for process in audioRecorder.processedData {
                                print("level 2")
                                if (process.createdAt == audio.createdAt) && process.favorite {
                                    
                                    print("level 3")
                                    
                                    strs.append(audioRecorder.viewableTask(file: audio.fileURL))
                                    preciseDates.append(audio.createdAt)
                                    date = audio.createdAt
                               }
                            }
                        }
                    }
                }
                for quest in entries.questionnaires {
                    if day == quest.createdAt.toDay() {
                        if filters.contains("Survey") || (filters.contains("Favorite") && quest.favorite) {
                            print(quest.createdAt)
                            strs.append("Survey")
                            preciseDates.append(quest.createdAt)
                            date = quest.createdAt
                        }
                    }
                }
                for journ in entries.journals {
                    if day == journ.createdAt.toDay() {
                        if (filters.contains("Journal") || journ.favorite ) || (filters.contains("Favorite") && journ.favorite) {
                            print(journ.favorite)
                            strs.append("Journal")
                            preciseDates.append(journ.createdAt)
                            date = journ.createdAt
                        }
                    }
                }
                
                if strs.count > 0 {
                    filteredList.append(Element(date: date, preciseDate: preciseDates, str: strs))
                }
                date = .now
                strs.removeAll()
            }
        }
    }
    
    func delete(element: String) {
        filters = filters.filter({ $0 != element })
    }
    
    func initializeThresholds() {
        if settings.pitchThreshold.count == 0 {
            settings.pitchThreshold = [0, 0, 0, 0]
        }
        if settings.durationThreshold.count == 0 {
            settings.durationThreshold = [0, 0, 0, 0]
        }
        if settings.qualityThreshold.count == 0 {
            settings.qualityThreshold = [0, 0, 0, 0]
        }
    }
    
    /// Sensitive delete function, once performed cannot be recovered
    /// Seaches through recordings, processings, surveys, and journals for a match with a target date within for loops
    /// If theres a match a target called deleteIndex gets assigned and type is assigned
    /// deleteIndex, if set will delete at that index of the proper type
    func deleteAtDate(createdAt: Date) {
        print("delete at \(deletionTarget.0), \(deletionTarget.1)")
        
        var type = ""
        var count = -1
        
        // checks that there is a match on audio recorder and processed data
        // looks for a match on both before otherwise canceling the process
        for index in 0..<audioRecorder.recordings.count {
            if createdAt == audioRecorder.recordings[index].createdAt {
                type = "record"
                count = index
            }
        }
        for index in 0..<audioRecorder.processedData.count {
            if createdAt == audioRecorder.recordings[index].createdAt {
                if type == "record" && count == index {
                    print("success")
                } else {
                    type = ""
                    count = -1
                }
            }
        }
        
        if type == "" && count == -1 {
            for index in 0..<entries.questionnaires.count {
                if createdAt == entries.questionnaires[index].createdAt {
                    type = "survey"
                    count = index
                }
            }
        }
        if type == "" && count == -1 {
            for index in 0..<entries.journals.count {
                if createdAt == entries.journals[index].createdAt {
                    type = "journal"
                    count = index
                }
            }
        }
        
        if count != -1 {
            if type == "record" {
                print("From recording lvl: \(audioRecorder.recordings[count].createdAt)\nFrom processings lvl: \(audioRecorder.processedData[count].createdAt)")
                //print(audioRecorder.recordings)
                //print(audioRecorder.processedData)
                if audioRecorder.recordings[count].createdAt == createdAt && audioRecorder.processedData[count].createdAt == createdAt {
                    
                    audioRecorder.deleteRecording(urlToDelete: audioRecorder.recordings[count].fileURL)
                    audioRecorder.processedData.remove(at: count)
                    
                    print("deleting record")
                    self.reset.toggle()
                }
            } else if type == "survey" {
                if entries.questionnaires[count].createdAt == createdAt {
                    
                    entries.questionnaires.remove(at: count)
                    
                    print("deleting survey")
                    self.reset.toggle()
                }
            } else if type == "journal" {
                if entries.journals[count].createdAt == createdAt {
                    
                    entries.journals.remove(at: count)
                    
                    print("deleting journal")
                    self.reset.toggle()
                }
            } else {
                print("There was a mismatch in data. In order to prevent erroneous deletion of data we have disabled the functionality of deleting this specific entry.")
            }
        }
    }
}
