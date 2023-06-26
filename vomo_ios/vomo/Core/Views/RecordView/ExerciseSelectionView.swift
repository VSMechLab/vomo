//
//  ExerciseSelectionView.swift
//  VoMo
//
//  Created by Sam Burkhard on 6/26/23.
//

import SwiftUI

struct ExerciseSelectionView: View {
    
    @State var isShowingRecordingView = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Exercise Selection")
                    .font(._title)
                Spacer()
            }
            .padding(.vertical)
            
            Button {
                isShowingRecordingView = true
            } label: {
                Text("Start Recording")
            }
            
            Spacer()
        }
        .padding()
        
        .fullScreenCover(isPresented: $isShowingRecordingView, content: {
            FeedbackRecordView()
        })
    }
}

struct ExerciseSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseSelectionView()
    }
}
