//
//  FeedbackRecordView.swift
//  VoMo
//
//  Created by Sam Burkhard on 6/13/23.
//

import Foundation
import SwiftUI

class WaveformPointsDummyStream {
        
    private var continuation: AsyncStream<Float?>.Continuation?
    
    public func cancel() {
        continuation?.finish()
//        stream = nil
    }
    
     init() {
        
        let amplitude: Float = 0.25  // Amplitude of the sine wave
        let frequency: Float = 10.0  // Frequency of the sine wave (in Hz)
        var time: Float = 0.0

        let _ = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            let value = amplitude * sin(2 * Float.pi * frequency * time) + 0.5
            time += 0.001
            self.continuation?.yield(value)
        }
    }
    
    lazy var stream: AsyncStream<Float?> = {
        AsyncStream(Float?.self, bufferingPolicy: .bufferingNewest(1)) { cont in
            continuation = cont
            
            cont.onTermination = { @Sendable status in
                print("Task terminated with status: \(status)")
            }
        }
    }()
    
}

fileprivate class DummyStream {
    
    let amplitude: Float = 0.5  // Amplitude of the sine wave
    let frequency: Float = 10.0  // Frequency of the sine wave (in Hz)
    var time: Float = 0.0
    
    var scheduledTimer: Timer?
        
    init() {
        
        self.scheduledTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            Task {
                let value = self.amplitude * sin(2 * Float.pi * self.frequency * self.time) + 0.5
                self.time += 0.001
                await WaveformPointsManager.shared.points.add(value)
            }
        }
    }
}

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
    
    static let shared = WaveformPointsManager(count: 130)
    
    @Published var points: Points
    @Published var isStreaming: Bool = false
    
//    public var consumer: Task<(), Never>?
//    public var stream: WaveformPointsDummyStream?
    private var stream: DummyStream?
    
    public init(count: Int) {
        self.points = Points(count: count)
    }
        
    public func startStream() {
        self.stream = DummyStream()
        self.isStreaming = true
    }
    
    public func stopStream() {
        self.stream?.scheduledTimer?.invalidate()
        self.stream = nil
        self.isStreaming = false
    }
    
    func update(date: Date) {}
    
//    public func observeStreams() {
//        
//        stream = WaveformPointsDummyStream()
//        
//        if stream != nil {
//            consumer = Task {
//                
//                do {
//                    for await point in self.stream!.stream {
//                        try Task.checkCancellation()
//                        self.points.add(point)
//                    }
//                } catch {
//                    print("Cancelled")
//                }
//                
//            }
//        }
//    }
    
//    public func cancelStreamObservation() {
//        consumer?.cancel()
//        stream = nil
//    }
    
    // memory-safety
//    deinit {
//        points.deallocate()
//        print("Deallocated WaveformPointsManager buffer")
//    }
    
}

struct FeedbackWaveform: View {
    
    var waveform: WaveformPointsManager
    
    public let size: CGSize
    
    // config visual elements here
    private let pointSpacing: CGFloat = 3.0
    private let pointSize: CGSize = .init(width: 4, height: 4)
    
    @ViewBuilder
    private func lineLabel(_ label: String) -> some View {
        HStack {
            Text("\(label) Hz")
                .font(.system(size: 14, weight: .semibold))
                .padding(.leading, 4)
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
            
//            .onAppear {
//                waveform.startStream()
//            }
            
//            .onDisappear {
//                waveform.stopStream()
//            }
        }
    }
    
}

struct FeedbackSyllables: View {
    
    var sentence: [String] = "Come back right away".split(separator: " ").map({ String($0) })
        
    @State var index = 0
    
    var body: some View {
        
        HStack(spacing: 5) {
            Spacer()
            
            ForEach(sentence, id: \.self) { word in
                Text(word)
                    .font(.system(size: 25))
                    .fontWeight((word == sentence[index]) ? .bold : .regular)
            }
            
            Spacer()
        }
        .padding(.top)
        
//        Button {
//            if index < sentence.count - 1 {
//                index += 1
//            }
//        } label: {
//            Image(systemName: "arrow.right.circle.fill")
//                .font(.largeTitle)
//        }
//        .tint(.MEDIUM_PURPLE)
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
    
    @ObservedObject var audioRecorder = AudioRecorder()
    
    @StateObject var waveform: WaveformPointsManager = .shared
    
    @State var targetPitch: Int
    @State var isShowingCloseConfirmationAlert: Bool = false
    
    var body: some View {
        
        VStack {
            
            GeometryReader { proxy in
                
                VStack {
                    
                    FeedbackSyllables()
                    
                    FeedbackWaveform(waveform: waveform, size: proxy.size)
                                        
                }
                
                FeedbackPitchTarget(size: proxy.size, targetPitch: CGFloat(targetPitch))
                            
            }
            
//            Text("\(audioRecorder.recording ? "Recording..." + String(audioRecorder.nyqFreq) : "Not recording")")
            
            recordingControls()
                .padding(.horizontal)
            
        }
        
        .alert("Are you sure you want to end this exercise?", isPresented: $isShowingCloseConfirmationAlert) {
            Button(role: .destructive) {
                self.dismiss()
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
                    .font(.system(size: 35))
            }
            
            Spacer()
            
            Button {
//                audioRecorder.startRecording(taskNum: 3)
                
                if (waveform.isStreaming) {
                    waveform.stopStream()
                } else {
                    waveform.startStream()
                }
                
            } label: {
                Image(systemName: (waveform.isStreaming) ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 55))
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "ellipsis.circle.fill")
                    .font(.system(size: 35))
            }
            
        }
        .foregroundColor(.MEDIUM_PURPLE)
    }
}

struct FeedbackRecordView_Preview: PreviewProvider {
    static var previews: some View {
        FeedbackRecordView(targetPitch: 400)
    }
}
