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
            
            tappedRecording = .now
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
            
            var usableDates: [Date] = []
            
            for str in usedDates {
                usableDates.append(str.toDateFromDOB() ?? .now)
            }
            
            usableDates = usableDates.sorted(by: { $0.compare($1) == .orderedAscending })
            
            usedDates.removeAll()
            
            for dateFin in usableDates {
                usedDates.append(dateFin.toDay())
            }
            
            for day in usedDates {
                var date: Date = .now
                var strs: [String] = []
                var preciseDates: [Date] = []
                
                /// Stores date and string of each selected entry, uses it to identify the right string to match with precise date
                var selectedEntries: [(Date, String)] = []
                
                for audio in audioRecorder.recordings {
                    if day == audio.createdAt.toDay() {
                        if filters.isEmpty || filters.contains(audioRecorder.taskNum(file: audio.fileURL)) {
                            preciseDates.append(audio.createdAt)
                            date = audio.createdAt
                            selectedEntries.append((date, audioRecorder.viewableTask(file: audio.fileURL)))
                        }
                    }
                }
                for quest in entries.questionnaires {
                    if day == quest.createdAt.toDay() {
                        if filters.isEmpty || filters.contains("Survey") {
                            preciseDates.append(quest.createdAt)
                            date = quest.createdAt
                            selectedEntries.append((date, "Survey"))
                        }
                    }
                }
                for journ in entries.journals {
                    if day == journ.createdAt.toDay() {
                        if filters.isEmpty || filters.contains("Journal") {
                            preciseDates.append(journ.createdAt)
                            date = journ.createdAt
                            selectedEntries.append((date, "Journal"))
                        }
                    }
                }
                
                preciseDates = preciseDates.sorted(by: { $0.compare($1) == .orderedAscending })
                
                for sortedDate in preciseDates {
                    for matchedDate in selectedEntries {
                        if sortedDate == matchedDate.0 {
                            strs.append(matchedDate.1)
                        }
                    }
                }
                
                if strs.isNotEmpty {
                    filteredList.append(Element(date: date, preciseDate: preciseDates, str: strs, expandShowMore: false))
                }
            }
        } else {
            self.showRecordDetails = true
            
            filteredList = []
            var usedDates: [String] = []
            
            for index in 0..<audioRecorder.recordings.count {
                if filters.contains("Vowel") &&
                    audioRecorder.taskNum(selection: 1, file: audioRecorder.recordings[index].fileURL) {
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
            
            var usableDates: [Date] = []
            
            for str in usedDates {
                usableDates.append(str.toDateFromDOB() ?? .now)
            }
            
            usableDates = usableDates.sorted(by: { $0.compare($1) == .orderedAscending })
            
            usedDates.removeAll()
            
            for dateFin in usableDates {
                usedDates.append(dateFin.toDay())
            }
            
            for day in usedDates {
                var date: Date = .now
                var strs: [String] = []
                var preciseDates: [Date] = []
                
                var selectedEntries: [(Date, String)] = []
                
                for audio in audioRecorder.recordings {
                    if day == audio.createdAt.toDay() {
                        
                        if filters.contains(audioRecorder.taskNum(file: audio.fileURL)) {
                            preciseDates.append(audio.createdAt)
                            date = audio.createdAt
                            selectedEntries.append((date, audioRecorder.viewableTask(file: audio.fileURL)))
                        } else if filters.contains("Favorite") {
                            for process in audioRecorder.processedData {
                                if (process.createdAt == audio.createdAt) && process.favorite {
                                    preciseDates.append(audio.createdAt)
                                    date = audio.createdAt
                                    selectedEntries.append((date, audioRecorder.viewableTask(file: audio.fileURL)))
                               }
                            }
                        }
                    }
                }
                for quest in entries.questionnaires {
                    if day == quest.createdAt.toDay() {
                        if filters.contains("Survey") || (filters.contains("Favorite") && quest.favorite) {
                            preciseDates.append(quest.createdAt)
                            date = quest.createdAt
                            selectedEntries.append((date, "Survey"))
                        }
                    }
                }
                for journ in entries.journals {
                    if day == journ.createdAt.toDay() {
                        if (filters.contains("Journal") || journ.favorite ) || (filters.contains("Favorite") && journ.favorite) {
                            preciseDates.append(journ.createdAt)
                            date = journ.createdAt
                            selectedEntries.append((date, "Journal"))
                        }
                    }
                }
                
                preciseDates = preciseDates.sorted(by: { $0.compare($1) == .orderedAscending })
                
                for sortedDate in preciseDates {
                    for matchedDate in selectedEntries {
                        if sortedDate == matchedDate.0 {
                            strs.append(matchedDate.1)
                        }
                    }
                }
                
                if strs.count > 0 {
                    filteredList.append(Element(date: date, preciseDate: preciseDates, str: strs, expandShowMore: false))
                }
            }
        }
    }
    
    func targetItem() {
        filteredList.removeAll()
        for quest in entries.questionnaires {
            if tappedRecording == quest.createdAt {
                filteredList.append(Element(date: tappedRecording, preciseDate: [tappedRecording], str: ["Survey"], expandShowMore: true) )
                break
            }
        }
        for record in audioRecorder.recordings {
            if tappedRecording == record.createdAt {
                filteredList = []
                
                let num = audioRecorder.fileTask(file: record.fileURL)
                
                switch num {
                case "1":
                    filteredList.append(Element(date: tappedRecording, preciseDate: [tappedRecording], str: ["Vowel"], expandShowMore: true) )
                    break
                case "2":
                    
                    filteredList.append(Element(date: tappedRecording, preciseDate: [tappedRecording], str: ["Duration"], expandShowMore: true) )
                    break
                case "3":
                    
                    filteredList.append(Element(date: tappedRecording, preciseDate: [tappedRecording], str: ["Rainbow"], expandShowMore: true) )
                    break
                default:
                    break
                }
                
            }
        }
        if filteredList.isEmpty {
            refilter()
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
        
        Logging.defaultLog.notice("Starting sequence for deletion at \(deletionTarget.0), \(deletionTarget.1)")
        
        var type = ""
        var count = -1
        
        // checks that there is a match on audio recorder and processed data
        // looks for a match on both before otherwise canceling the process
        for index in 0..<audioRecorder.recordings.count {
            if createdAt == audioRecorder.recordings[index].createdAt {
                Logging.defaultLog.notice("found file to delete: \(audioRecorder.recordings[index].createdAt.toStringDay())")
                type = "record"
                count = index
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
        if type == "" && count == -1 {
            for index in 0..<entries.treatments.count {
                if createdAt == entries.treatments[index].date {
                    type = "treatment"
                    count = index
                }
            }
        }
        if count != -1 {
            if type == "record" {
                Logging.defaultLog.notice("able to delete recording")
                
                if audioRecorder.recordings.count == audioRecorder.processedData.count {
                    
                    audioRecorder.deleteRecording(urlToDelete: audioRecorder.recordings[count].fileURL)
                    audioRecorder.processedData.remove(at: count)
                    
                    audioRecorder.syncEntries(gender: settings.gender)
                    
                    Logging.defaultLog.notice("deleting record")
                    self.reset.toggle()
                } else {
                    audioRecorder.syncEntries(gender: settings.gender)
                }
            } else if type == "survey" {
                if entries.questionnaires[count].createdAt == createdAt {
                    
                    entries.questionnaires.remove(at: count)
                    
                    Logging.defaultLog.notice("deleting survey")
                    self.reset.toggle()
                }
            } else if type == "journal" {
                if entries.journals[count].createdAt == createdAt {
                    
                    entries.journals.remove(at: count)
                    
                    Logging.defaultLog.notice("deleting journal")
                    self.reset.toggle()
                }
            } else if type == "treatment" {
                if entries.treatments[count].date == createdAt {
                    
                    entries.treatments.remove(at: count)
                    
                    Logging.defaultLog.notice("deleting treatment")
                    self.reset.toggle()
                }
            } else {
                Logging.defaultLog.error("There was a mismatch in data. In order to prevent erroneous deletion of data we have disabled the functionality of deleting this specific entry.")
            }
        }
    }
}
