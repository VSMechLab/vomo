//
//  FeedbackRecordView.swift
//  VoMo
//
//  Created by Sam Burkhard on 6/13/23.
//

import Foundation
import SwiftUI

class WaveformPointsDummyStream {
    
    static let shared = WaveformPointsDummyStream()
    
    private var continuation: AsyncStream<Int?>.Continuation?
    
    public func push(_ item: Int?) {
        continuation?.yield(item)
    }
    
    lazy var stream: AsyncStream<Int?> = {
        AsyncStream(Int?.self, bufferingPolicy: .bufferingNewest(1)) { cont in
            continuation = cont
                
            cont.onTermination = { @Sendable status in
                print("Task terminated with status: \(status)")
            }
        }
    }()
    
    
}

class WaveformPointsManager: ObservableObject {
    
    static let shared = WaveformPointsManager(count: 130)
        
    struct Points {
        
        let count: Int
        private let buffer: UnsafeMutableBufferPointer<Int?>
        
        init(count: Int) {
            self.count = count
            
            buffer = UnsafeMutableBufferPointer.allocate(capacity: count)
            buffer.initialize(repeating: nil)
        }
        
        func add(_ point: Int?) {
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
        
        subscript(index: Int) -> Int? {
            return buffer[index]
        }
        
    }
    
    @Published var points: Points
    
    public init(count: Int) {
        self.points = Points(count: count)
        
        // consume streams
        Task {
            for await point in WaveformPointsDummyStream.shared.stream {
                points.add(point)
            }
        }
    }
    
    func update(date: Date) { }
    
    // memory-safety
    deinit {
        points.deallocate()
    }
    
}

struct FeedbackWaveform: View {
    
    @ObservedObject private var waveform: WaveformPointsManager = .shared
    
    // config visual elements here
    private let pointSpacing: CGFloat = 3.0
    private let pointSize: CGSize = .init(width: 4, height: 4)
    
    var body: some View {
        HStack {
            TimelineView(.animation) { timeline in
                                
                Canvas { context, size in
                    
                    waveform.update(date: timeline.date)
                        
                    // waveform
                    for index in stride(from: 0, to: waveform.points.count, by: 1) {
                        
                        if let y = waveform.points[index] {
                            let x = CGFloat(index) * pointSpacing
                            let rect = CGRect(origin: CGPoint(x: x, y: CGFloat(y)), size: pointSize)
                            let path = Circle().path(in: rect)
                            context.fill(path, with: .color(.MEDIUM_PURPLE))
                        }
                    }
                }
            }
        }
    }
    
}

struct FeedbackRecordView: View {
    
    // MARK: Delete later
    @State private var dummyInput: Float = 770 / 2
    
    var body: some View {
        
        VStack {
            
            FeedbackWaveform()
            
            Slider(value: $dummyInput, in: 0...770)
                .padding()
                .onAppear(perform: {
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                        WaveformPointsDummyStream.shared.push(Int(dummyInput))
                    }
                })
                .tint(.MEDIUM_PURPLE)
        }
    }
}

struct FeedbackRecordView_Preview: PreviewProvider {
    static var previews: some View {
        FeedbackRecordView()
    }
}
