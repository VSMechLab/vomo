//
//  RecordBackground.swift
//  VoMo
//
//  Created by Neil McGrogan on 4/12/22.
//

import SwiftUI

struct RecordBackground: View {
    @EnvironmentObject var recordingState: RecordState
    
    @Binding var timerCount: Int
    
    let recording_background_img = "VM_Waves-Gfx"
    let demi_circle_img = "VM_record-bg-combined-gfx"
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(recording_background_img)
                .resizable()
                .padding(.horizontal, -10)
                .frame(width: UIScreen.main.bounds.width + 10, height: 50)
                .padding(.bottom, 20)
            
            ZStack {
                Image(demi_circle_img)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width + 10, height: 210, alignment: .center)
                    .edgesIgnoringSafeArea(.all)
                    .shadow(color: Color.gray.opacity(0.8), radius: 0.75)
                
                Text(timerCount == 0 ? "" : "\(timerCount)s")
                    .font(._recordStateStatus)
                    .foregroundColor(Color.BODY_COPY)
                    .onReceive(timer) { _ in
                        if recordingState.state == 1 {//playing {
                            timerCount += 1
                        }
                    }
            }
        }
    }
}
