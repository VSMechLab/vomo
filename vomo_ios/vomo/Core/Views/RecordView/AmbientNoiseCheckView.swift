//
//  AmbientNoiseCheckView.swift
//  VoMo
//
//  Created by Sam Burkhard on 8/18/23.
//

import SwiftUI

struct AmbientNoiseCheckView: View {
    
    var loudnessThreshold: Float = 40
    
    @ObservedObject var audioRecorder = AudioRecorder.shared
        
    @State var countdown = 3
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var isShowingRecordingView: Bool

    var body: some View {
        ZStack {
                
            Color.BLUE.ignoresSafeArea()
            
            VStack(spacing: 15) {
                
                Spacer()
                
                Text("\(countdown)")
                    .font(._large_title)
                
                Text("\(audioRecorder.outAverage): \((audioRecorder.outAverage < loudnessThreshold) ? "Ok loudness" : "Too loud")")
                
                Text("Make sure you're in a quiet space")
                    .font(._title)
                    .multilineTextAlignment(.center)
                
                Button {
                    self.dismiss()
                    self.isShowingRecordingView = true
                } label: {
                    Text("Continue")
                }
                
                Spacer()
            }
            .foregroundStyle(.white)
            
            // MARK: TEMP
            .onAppear() {
                audioRecorder.startRecording(taskNum: 1)
            }
            
        }
    }
}

struct AmbientNoiseCheckView_Preview: PreviewProvider {
    static var previews: some View {
        AmbientNoiseCheckView(isShowingRecordingView: .constant(false))
    }
}
