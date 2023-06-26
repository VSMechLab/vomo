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
    
    public var consumer: Task<(), Never>?
    public var stream: WaveformPointsDummyStream?
    
    public init(count: Int) {
        self.points = Points(count: count)
    }
    
    func update(date: Date) {}
    
    public func observeStreams() {
        
        stream = WaveformPointsDummyStream()
        
        if stream != nil {
            consumer = Task {
                
                do {
                    for await point in self.stream!.stream {
                        try Task.checkCancellation()
                        self.points.add(point)
                    }
                } catch {
                    print("Cancelled")
                }
                
            }
        }
    }
    
    public func cancelStreamObservation() {
        consumer?.cancel()
        stream = nil
    }
    
    // memory-safety
    deinit {
        points.deallocate()
        print("WaveformPointsManager Deinit")
    }
    
}

struct FeedbackWaveform: View {
    
    @StateObject var waveform: WaveformPointsManager = .shared
    
    public let size: CGSize
    
    // config visual elements here
    private let pointSpacing: CGFloat = 3.0
    private let pointSize: CGSize = .init(width: 4, height: 4)
    
    var body: some View {
        VStack {
            TimelineView(.animation) { timeline in
                                
                Canvas { context, size in
                    
                    waveform.update(date: timeline.date)
                        
                    // waveform
                    for index in stride(from: 0, to: waveform.points.count, by: 1) {
                        
                        if let point = waveform.points[index] {
                            let x = CGFloat(index) * pointSpacing
//                            let x = size.width
                            let y = (CGFloat(point) * size.height)
                            let rect = CGRect(origin: CGPoint(x: x, y: y), size: pointSize)
                            let path = Circle().path(in: rect)
                            context.fill(path, with: .color(.MEDIUM_PURPLE))
                        }
                    }
                }
            }
            
            .onAppear {
                waveform.observeStreams()
            }
            
            .onDisappear {
                waveform.cancelStreamObservation()
            }
        }
    }
    
}

struct FeedbackSyllables: View {
    
    var sentence: [String] = "The quick brown fox jumps over the lazy dog".split(separator: " ").map({ String($0) })
    
    public let size: CGSize
    
    @State var index = 0
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                HStack() {
                    ForEach(sentence, id: \.self) { word in
                        Text(word)
                            .font(._large_title)
                            .id(word)
                            .frame(width: size.width)
                    }
                }
            }
            .disabled(true)
            
            Button {
                withAnimation {
                    proxy.scrollTo(sentence[index])
                }
                
                if index < sentence.count - 1 {
                    index += 1
                }
                
            } label: {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.largeTitle)
            }
            .tint(.MEDIUM_PURPLE)
        }
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

struct FeedbackRecordView: View {
    
    // MARK: Delete later
//    @State private var dummyInput: Float = 0.5
    
    var body: some View {
                        
        GeometryReader { proxy in
                            
            FeedbackWaveform(size: proxy.size)
            
            FeedbackSyllables(size: proxy.size)
            
            FeedbackVolume()

        }
    }
}

struct FeedbackRecordView_Preview: PreviewProvider {
    static var previews: some View {
        FeedbackRecordView()
    }
}
