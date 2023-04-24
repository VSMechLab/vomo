//
//  ExpandedJournal.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/29/22.
//

import SwiftUI

struct Journals: Hashable {
    var createdAt: Date
    var note: String
}

struct ExpandedJournal: View {
    @EnvironmentObject var entries: Entries
    let svm = SharedViewModel()
    let createdAt: Date
    @Binding var deletionTarget: (Date, String)
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(findJournal(createdAt: createdAt), id: \.self) { journal in
                Text("\(journal.note)")
                    .font(._bodyCopy)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 2)
            }
            
            HStack {
                StarButton(type: "journal", date: createdAt)
                Spacer()
                DeleteButton(deletionTarget: $deletionTarget, type: "Journal entry", date: createdAt)
            }
        }
        .padding(4)
        .foregroundColor(Color.white)
    }
}

extension ExpandedJournal {
    
    func findJournal(createdAt: Date) -> [Journals] {
        var ret: [Journals] = []
        for journal in entries.journals {
            // Check if survey time matches target time
            if journal.createdAt == createdAt {
                ret.append(Journals(createdAt: createdAt, note: journal.note))
            }
        }
        return ret
    }
}

struct ExpandedJournal_Previews: PreviewProvider {
    static var previews: some View {
        ExpandedJournal(createdAt: .now, deletionTarget: .constant((.now, "vowel")))
    }
}
