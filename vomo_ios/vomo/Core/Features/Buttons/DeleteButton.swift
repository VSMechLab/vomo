//
//  DeleteButton.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/29/22.
//

import SwiftUI

/// passes on information about which entry to delete along with a label about it that appears in a popup
struct DeleteButton: View {
    @EnvironmentObject var entries: Entries
    @ObservedObject var audioPlayer = AudioPlayer()
    
    @Binding var deletionTarget: (Date, String)
    let type: String
    var date: Date
    let svm = SharedViewModel()
    
    var body: some View {
        Button(action: {
            deletionTarget = (date, type)
        }) {
            Image(svm.trash_can)
                .resizable()
                .frame(width: 20, height: 20)
        }
    }
}

/// passes on information about which entry to delete along with a label about it that appears in a popup
struct AltDeleteButton: View {
    @EnvironmentObject var entries: Entries
    @ObservedObject var audioPlayer = AudioPlayer()
    
    @Binding var deletionTarget: (Date, String)
    let type: String
    var date: Date
    let svm = SharedViewModel()
    
    var body: some View {
        Button(action: {
            deletionTarget = (date, type)
        }) {
            Image(svm.alt_can)
                .resizable()
                .frame(width: 20, height: 20)
        }
    }
}

struct DeleteButton_Previews: PreviewProvider {
    static var previews: some View {
        DeleteButton(deletionTarget: .constant((.now, "")), type: "testing type", date: .now)
    }
}
