//
//  Filter.swift
//  VoMo
//
//  Created by Neil McGrogan on 10/27/22.
//

import SwiftUI

struct Filter: View {
    @EnvironmentObject var entries: Entries
    @EnvironmentObject var audioRecorder: AudioRecorder
    @Binding var filters: [String]
    @Binding var showFilter: Bool
    let svm = SharedViewModel()
    
    //@State private var countOfSelected: Int = 0
    
    var body: some View {
        VStack {
            header
            
            Group {
                Group {
                    Color.INPUT_FIELDS.frame(height: 1)
                    
                    Button(action: {
                        if filters.contains("Vowel") {
                            delete(element: "Vowel")
                        } else {
                            self.filters.append("Vowel")
                        }
                    }) {
                        HStack {
                            Text("Vowel")
                            Spacer()
                            Text("\(numOfRecords().0) Entries")
                        }
                        .font(filters.contains("Vowel") ? ._bodyCopyBold : ._bodyCopy)
                        .foregroundColor(filters.contains("Vowel") ? Color.DARK_BLUE : Color.BODY_COPY)
                    }.frame(width: svm.content_width)
                    
                    Color.INPUT_FIELDS.frame(height: 1)
                }
                
                Button(action: {
                    if filters.contains("Duration") {
                        delete(element: "Duration")
                    } else {
                        self.filters.append("Duration")
                    }
                }) {
                    HStack {
                        Text("Duration")
                        Spacer()
                        Text("\(numOfRecords().1) Entries")
                    }
                    .font(filters.contains("Duration") ? ._bodyCopyBold : ._bodyCopy)
                    .foregroundColor(filters.contains("Duration") ? Color.DARK_BLUE : Color.BODY_COPY)
                }.frame(width: svm.content_width)
                
                Color.INPUT_FIELDS.frame(height: 1)
                
                Button(action: {
                    if filters.contains("Rainbow") {
                        delete(element: "Rainbow")
                    } else {
                        self.filters.append("Rainbow")
                    }
                }) {
                    HStack {
                        Text("Rainbow")
                        Spacer()
                        Text("\(numOfRecords().2) Entries")
                    }
                    .font(filters.contains("Rainbow") ? ._bodyCopyBold : ._bodyCopy)
                    .foregroundColor(filters.contains("Rainbow") ? Color.DARK_BLUE : Color.BODY_COPY)
                }.frame(width: svm.content_width)
                
                Color.INPUT_FIELDS.frame(height: 1)
                
                Button(action: {
                    if filters.contains("Survey") {
                        delete(element: "Survey")
                    } else {
                        self.filters.append("Survey")
                    }
                }) {
                    HStack {
                        Text("Surveys")
                        Spacer()
                        Text("\(numOfSurveys()) Entries")
                    }
                    .font(filters.contains("Survey") ? ._bodyCopyBold : ._bodyCopy)
                    .foregroundColor(filters.contains("Survey") ? Color.DARK_BLUE : Color.BODY_COPY)
                }.frame(width: svm.content_width)
                
                Color.INPUT_FIELDS.frame(height: 1)
                
                Button(action: {
                    if filters.contains("Journal") {
                        delete(element: "Journal")
                    } else {
                        self.filters.append("Journal")
                    }
                }) {
                    HStack {
                        Text("Journals")
                        Spacer()
                        Text("\(numOfJournals()) Entries")
                    }
                    .font(filters.contains("Journal") ? ._bodyCopyBold : ._bodyCopy)
                    .foregroundColor(filters.contains("Journal") ? Color.DARK_BLUE : Color.BODY_COPY)
                }.frame(width: svm.content_width)
                
                Color.INPUT_FIELDS.frame(height: 1)
                
                Button(action: {
                    if filters.contains("Favorite") {
                        delete(element: "Favorite")
                    } else {
                        self.filters.append("Favorite")
                    }
                }) {
                    HStack {
                        Text("Favorite")
                        Spacer()
                        Text("\(numOfFavorites()) Entries")
                    }
                    .font(filters.contains("Favorite") ? ._bodyCopyBold : ._bodyCopy)
                    .foregroundColor(filters.contains("Favorite") ? Color.DARK_BLUE : Color.BODY_COPY)
                }.frame(width: svm.content_width)
            }
            
            VStack(spacing: 0) {
                Color.BODY_COPY.frame(height: 1)
                
                HStack {
                    Button(action: {
                        self.filters.removeAll()
                    }) {
                        ZStack {
                            Image(svm.empty_img)
                                .resizable()
                                .frame(width: 150, height: 35)
                            Text("CLEAR")
                                .foregroundColor(Color.DARK_PURPLE)
                        }
                    }
                    Spacer()
                    Button(action: {
                        self.showFilter.toggle()
                    }) {
                        ZStack {
                            Image(svm.filled_img)
                                .resizable()
                                .frame(width: 150, height: 35)
                            Text("DONE")
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding()
                .background(Color.INPUT_FIELDS)
                
                Color.BODY_COPY.frame(height: 1)
            }
        }
        .padding()
        .background(Color.white)
    }
}

/// Additional views
extension Filter {
    private var header: some View {
        VStack {
            Text("Filter")
                .foregroundColor(Color.BODY_COPY)
                .font(._BTNCopy)
                .padding(.top, 5)
            Text("\(totalEntries()) entries")
                .foregroundColor(Color.BODY_COPY)
                .font(._bodyCopy)
        }
    }
}

/// Functions
extension Filter {
    func totalEntries() -> Int {
        var count = 0
        for _ in audioRecorder.recordings { count += 1 }
        for _ in entries.journals { count += 1 }
        for _ in entries.questionnaires { count += 1 }
        return count
    }
    
    func delete(element: String) {
        filters = filters.filter({ $0 != element })
    }
    func numOfRecords() -> (Int, Int, Int) {
        var count = (0, 0, 0)
        for record in audioRecorder.recordings {
            print(record.fileURL)
            if record.taskNum == 1 {
                count.0 += 1
            }
            if record.taskNum == 2 {
                count.1 += 1
            }
            if record.taskNum == 3 {
                count.2 += 1
            }
        }
        print("Count is: \(count)")
        return count
    }
    func numOfSurveys() -> Int {
        var count = 0
        for _ in entries.questionnaires { count += 1 }
        return count
    }
    func numOfJournals() -> Int {
        var count = 0
        for _ in entries.journals { count += 1 }
        return count
    }
    /*func countSelected() {
        countOfSelected = 0
        
        if filters.contains("Vowel") {
            countOfSelected += 1
        }
    }*/
    func numOfFavorites() -> Int {
        var count = 0
        for record in audioRecorder.processedData {
            if record.favorite {
                count += 1
            }
        }
        for journal in entries.journals {
            if journal.favorite {
                count += 1
            }
        }
        for survey in entries.questionnaires {
            if survey.favorite {
                count += 1
            }
        }
        return count
    }
}

