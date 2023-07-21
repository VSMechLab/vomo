//
//  ExerciseSelectionView.swift
//  VoMo
//
//  Created by Sam Burkhard on 6/26/23.
//

import SwiftUI

struct ExerciseSelectionView: View {
    
    @EnvironmentObject var settings: Settings
    
    @State var isShowingRecordingView = false
    @State var targetFrequency = 250 // in Hz
    
    @FocusState private var focused: Bool
    
    var body: some View {
        
        VStack(spacing: 15) {
            
            HStack {
                Text("Exercise")
                    .font(._title)
                Spacer()
            }
            .padding(.vertical)
            
            Divider()
                
            HStack {
                Text("Target Frequency")
                    .font(._BTNCopy)
                
                Spacer()
                
                TextField("", value: $targetFrequency, format: .number)
                    .fixedSize()
                    .padding([.vertical],5)
                    .padding([.horizontal], 10)
                
                    .focused($focused)
                    .background(Color.INPUT_FIELDS, in: RoundedRectangle(cornerRadius: 5))
                    
                    .keyboardType(.numberPad)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                   focused.toggle()
                            }
                        }
                    }
                
                    .onChange(of: focused) { focus in
                        settings.keyboardShown = focus
                    }
                Text("Hz")
            }
            
            Spacer()
            
            Button {
                isShowingRecordingView = true
            } label: {
                Label("Start Recording", systemImage: "mic.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
                    .padding([.vertical], 10)
                    .padding([.horizontal], 20)
                    .background(Color.MEDIUM_PURPLE, in: Capsule())
            }
            
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
