//
//  FeedbackRecordView.swift
//  VoMo
//
//  Created by Sam Burkhard on 6/13/23.
//

import Foundation
import SwiftUI

@MainActor
class WaveformPointsManager: ObservableObject {
                    
    struct Points {
        
        let count: Int
        private let buffer: UnsafeMutableBufferPointer<Float?>
        
        init(count: Int) {
            self.count = count
            
            buffer = UnsafeMutableBufferPointer.allocate(capacity: count)
            buffer.initialize(repeating: nil)
        }
        
        func add(_ point: Float?) {
                        
            if buffer.baseAddress != nil {
                // shift up to last item
                for address in 0..<(count - 1) {
                    buffer.baseAddress?.advanced(by: address).initialize(to: buffer[address + 1])
                }
                
                buffer.baseAddress?.advanced(by: count - 1).initialize(to: point)
            }
        }
        
        func deallocate() {
            buffer.deallocate()
        }
        
        subscript(index: Int) -> Float? {
            return buffer[index]
        }
        
    }
    
    static let shared = WaveformPointsManager(count: 130) // TODO: Replace this magic number. Represents number of points across screen at one time
    
    @Published var points: Points
    
    public init(count: Int) {
        self.points = Points(count: count)
    }
    
    func update(date: Date) {}

}

@MainActor
struct FeedbackWaveform: View {
    
    @ObservedObject var audioRecorder = AudioRecorder.shared

    var waveform: WaveformPointsManager = .shared
    
    public let size: CGSize
    
    // config visual elements here
    private let pointSpacing: CGFloat = 3.0
    private let pointSize: CGSize = .init(width: 4, height: 4)
    
    init(size: CGSize) {
        self.size = size
        
        // observe for nyqFreq changes
        _ = audioRecorder.$nyqFreq.sink { freq in
            WaveformPointsManager.shared.points.add((freq*50)/3400)
        }
    }
    
    @ViewBuilder
    private func lineLabel(_ label: String) -> some View {
        HStack {
            Text("\(label) Hz")
                .font(.system(size: 14, weight: .semibold))
                .padding(.leading, 7)
            Rectangle()
                .frame(height: 1)
        }
        .foregroundColor(Color(uiColor: .systemGray2))
    }
    
    var body: some View {
        
        VStack {
            
            lineLabel("3400")
            
            TimelineView(.animation) { timeline in
                                
                Canvas { context, size in
                    
                    waveform.update(date: timeline.date)
                        
                    // waveform
                    for index in stride(from: 0, to: waveform.points.count, by: 1) {
                        
                        if let point = waveform.points[index] {
                            let x = CGFloat(index) * pointSpacing
                            let y = (CGFloat(point) * size.height)
                            let rect = CGRect(origin: CGPoint(x: x, y: y), size: pointSize)
                            let path = Circle().path(in: rect)
                            context.fill(path, with: .color(.MEDIUM_PURPLE))
                        }
                    }
                }
            }
            
            lineLabel("300")
            
        }
    }
    
}

struct FeedbackSyllables: View {
    
    var sentenceArray: [String] = []
    var syllableCount: Int
        
    @State var index = 0
    
    init(syllableCount: Int) {
        self.syllableCount = syllableCount
        
        if let sentence = ExerciseManager.fetch(for: syllableCount) {
            sentenceArray = sentence.phrase.split(separator: " ").map({ String($0) })
        } 
    }
    
    var body: some View {
        
        HStack(spacing: 5) {
            Spacer()
            
            ForEach(sentenceArray, id: \.self) { word in
                Text(word)
                    .font(.system(size: 25))
                    .fontWeight((word == sentenceArray[index]) ? .bold : .regular)
            }
            
            Spacer()
        }
        .padding(.top)
    }
}

struct FeedbackVolume: View {
    var body: some View {
        VStack {
            Spacer()
            
            ZStack(alignment: .leading) {
                
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.black, lineWidth: 1)
                    .foregroundColor(.white)
                
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.MEDIUM_PURPLE)
                    .frame(width: 100)
                
                Rectangle()
                    .frame(width: 3)
                    .foregroundColor(.green)
                    .offset(x: 200, y: 0)
                
            }
            .frame(height: 35)
            .padding()
        }
    }
}

struct FeedbackPitchTarget: View {
    
    var size: CGSize
    var targetPitch: CGFloat
    
    var body: some View {
        VStack {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.green)
                .position(x: size.width / 2, y: size.height - (size.height * CGFloat(targetPitch / 3400)))
        }
    }
}

struct FeedbackRecordView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var audioRecorder = AudioRecorder.shared
        
    var targetPitch: Int
    var syllableCount: Int
    
    @State var isShowingCloseConfirmationAlert: Bool = false
    
    var body: some View {
        
        VStack {
            
            GeometryReader { proxy in
                
                VStack {
                                        
                    FeedbackSyllables(syllableCount: syllableCount)
                    
                    FeedbackWaveform(size: proxy.size)
                                        
                }
                
                FeedbackPitchTarget(size: proxy.size, targetPitch: CGFloat(targetPitch))
                
            }
                        
            recordingControls()
                .padding(.horizontal)
            
        }
        
        #if targetEnvironment(simulator)
        
        .overlay {
            VStack(spacing: 15) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 50))
                Text("Microphone not available in simulator")
                    .font(.headline)
            }
        }

        #endif
        
        .alert("Are you sure you want to end this exercise?", isPresented: $isShowingCloseConfirmationAlert) {
            Button(role: .destructive) {
                self.dismiss()
                audioRecorder.stopRecording()
            } label: {
                Text("End")
            }

        }
    }
    
    @ViewBuilder
    private func recordingControls() -> some View {
        HStack(alignment: .center) {
            
            Button {
                self.isShowingCloseConfirmationAlert = true
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 40))
            }
            
            Spacer()
            
            Button {
                
                if (audioRecorder.grantedPermission()) {
                    
                    if (audioRecorder.recording) {
                        audioRecorder.stopRecording()
                    } else {
                        audioRecorder.startRecording(taskNum: 1)
                    }
                }
                
            } label: {
                Image(systemName: (audioRecorder.recording) ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 65))
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "ellipsis.circle.fill")
                    .font(.system(size: 40))
            }
            
        }
        .foregroundColor(.MEDIUM_PURPLE)
    }
}

struct FeedbackRecordView_Preview: PreviewProvider {
    static var previews: some View {
        FeedbackRecordView(targetPitch: 400, syllableCount: 2)
    }
}
