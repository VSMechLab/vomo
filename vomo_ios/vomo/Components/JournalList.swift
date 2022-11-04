//
//  JournalList.swift
//  VoMo
//
//  Created by Neil McGrogan on 10/27/22.
//

import SwiftUI

struct Journals: Hashable {
    var createdAt: Date
    var noteName: String
    var note: String
}

struct JournalList: View {
    @EnvironmentObject var entries: Entries
    let svm = SharedViewModel()
    let createdAt: Date
    @Binding var reset: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(findJournal(createdAt: createdAt), id: \.self) { journal in
                HStack {
                    Text(journal.noteName)
                        .font(._bodyCopyBold)
                    Spacer()
                }
                Text("\(journal.note)")
                    .font(._bodyCopy)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 2)
            }
            
            HStack(spacing: 0) {
                Spacer()
                StarButton(type: "journal", date: createdAt)
                    .padding(.trailing)
                DeleteEntry(date: createdAt, reset: $reset)
            }
        }
        .padding(4)
        .foregroundColor(Color.white)
    }
}

extension JournalList {
    
    func findJournal(createdAt: Date) -> [Journals] {
        var ret: [Journals] = []
        for journal in entries.journals {
            // Check if survey time matches target time
            if journal.createdAt == createdAt {
                ret.append(Journals(createdAt: createdAt, noteName: journal.noteName, note: journal.note))
            }
        }
        return ret
    }
}
