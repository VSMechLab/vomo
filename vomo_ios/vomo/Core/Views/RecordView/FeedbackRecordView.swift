//
//  FeedbackRecordView.swift
//  VoMo
//
//  Created by Sam Burkhard on 6/13/23.
//

import Foundation
import SwiftUI

@MainActor
fileprivate class WaveformPointsManager: ObservableObject {
                    
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

    fileprivate var waveform: WaveformPointsManager = .shared
    
    public let size: CGSize
    public let targetPitch: Int // in Hz
    
    // config visual elements here
    private let pointSpacing: CGFloat = 3.0
    private let pointSize: CGSize = .init(width: 4, height: 4)
    
    private let tolerance: Float = 0.025
    
    init(size: CGSize, targetPitch: Int) {
        self.size = size
        self.targetPitch = targetPitch
        
        // observe for outAverage changes
        _ = audioRecorder.$outAverage.sink { freq in
//            WaveformPointsManager.shared.points.add((freq*50)/3400)
            WaveformPointsManager.shared.points.add((100-freq)/100)

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
                            
                            var color: Color
                            let percentageTargetPitch = Float(100-targetPitch) / 100
                            
                            // check tolerance
                            if point <= percentageTargetPitch + tolerance && point >= percentageTargetPitch - tolerance {
                                color = .green
                            } else {
                                // red = too low, blue = too high
                                color = (point < percentageTargetPitch) ? Color.blue : Color.red // MARK: Take out magic numbers. These are for db, not hz
                            }
                            
                            context.fill(path, with: .color(color))
                        }
                    }
                }
            }
            
            lineLabel("300")
            
        }
    }
    
}

struct FeedbackRecordView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var audioRecorder = AudioRecorder.shared
        
    var targetPitch: Int
    var syllableCount: Int
    
    @State var currentSyllable: Int = 0
    
    @State var isShowingCloseConfirmationAlert: Bool = false
    
    var body: some View {
        
        VStack {
            
            syllables()
            
            GeometryReader { proxy in
                
                FeedbackWaveform(size: proxy.size, targetPitch: targetPitch)
                
                targetPitchIndicator(size: proxy.size)

            }
            
            recordingControls()
            
        }
        
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
    private func targetPitchIndicator(size: CGSize) -> some View {
        VStack {
            Rectangle()
                .frame(width: size.width, height: 2)
                .foregroundColor(.green)
                .position(x: size.width / 2, y: size.height * (CGFloat(100-targetPitch) / 100))
        }
    }
    
    private func syllables() -> some View {
        
        var sentenceArray: [String] = []
            
        if let sentence = ExerciseManager.fetch(for: syllableCount) {
            sentenceArray = sentence.words.map({ $0.word })
        }
        
        return HStack(spacing: 5) {
            Spacer()
            
            ForEach(sentenceArray, id: \.self) { word in
                Text(word)
                    .font(Font.custom("Roboto-Medium", size: 35))
            }
            
            Spacer()
        }
        .frame(height: 70)
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
                        
            Button {
                if (audioRecorder.recording) {
                    audioRecorder.stopRecording()
                } else {
                    audioRecorder.startRecording(taskNum: 1)
                }
            } label: {
                Image((audioRecorder.recording) ? "VM_stop-nav-ds-icon" : "VM_record-nav-ds-icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120)
            }
            
        }
        .foregroundColor(.MEDIUM_PURPLE)
    }
}

struct FeedbackRecordView_Preview: PreviewProvider {
    static var previews: some View {
        FeedbackRecordView(targetPitch: 50, syllableCount: 2)
    }
}
