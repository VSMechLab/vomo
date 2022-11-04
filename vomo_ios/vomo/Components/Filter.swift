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
               //showFitler
    let svm = SharedViewModel()
    var body: some View {
        VStack {
            Text("Filter")
                .foregroundColor(Color.BODY_COPY)
                .font(._CTALink)
            Text("\(totalEntries()) entries")
                .foregroundColor(Color.BODY_COPY)
                .font(._CTALink)
            
            Group {
                Group {
                    Color.INPUT_FIELDS.frame(height: 1)
                    
                    Button(action: {
                        if filters.contains("vowel") {
                            delete(element: "vowel")
                        } else {
                            self.filters.append("vowel")
                        }
                    }) {
                        HStack {
                            Text("Vowel")
                            Spacer()
                            Text("XXX Entries")
                        }
                        .foregroundColor(filters.contains("vowel") ? Color.DARK_BLUE : Color.BODY_COPY)
                    }.frame(width: svm.content_width)
                    
                    Color.INPUT_FIELDS.frame(height: 1)
                }
                
                Button(action: {
                    if filters.contains("mpt") {
                        delete(element: "mpt")
                    } else {
                        self.filters.append("mpt")
                    }
                }) {
                    HStack {
                        Text("MPT")
                        Spacer()
                        Text("XXX Entries")
                    }
                    .foregroundColor(filters.contains("mpt") ? Color.DARK_BLUE : Color.BODY_COPY)
                }.frame(width: svm.content_width)
                
                Color.INPUT_FIELDS.frame(height: 1)
                
                Button(action: {
                    if filters.contains("rainbow") {
                        delete(element: "rainbow")
                    } else {
                        self.filters.append("rainbow")
                    }
                }) {
                    HStack {
                        Text("Rainbow")
                        Spacer()
                        Text("XXX Entries")
                    }
                    .foregroundColor(filters.contains("rainbow") ? Color.DARK_BLUE : Color.BODY_COPY)
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
                        Text("XXX Entries")
                    }
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
                        Text("XXX Entries")
                    }
                    .foregroundColor(filters.contains("Journal") ? Color.DARK_BLUE : Color.BODY_COPY)
                }.frame(width: svm.content_width)
                
                Color.INPUT_FIELDS.frame(height: 1)
                
                Button(action: {
                    if filters.contains("Star") {
                        delete(element: "Star")
                    } else {
                        self.filters.append("Star")
                    }
                }) {
                    HStack {
                        Text("Star")
                        Spacer()
                        Text("XXX Entries")
                    }
                    .foregroundColor(filters.contains("Star") ? Color.DARK_BLUE : Color.BODY_COPY)
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
            }
        }
        
        
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.45)
        .edgesIgnoringSafeArea(.top)
        .background(Color.white)
    }
    
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
}
