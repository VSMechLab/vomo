//
//  Wave.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/7/22.
//

import SwiftUI

struct Wave: View {
    let color: Color
    let offset: Float
    @Binding var recording: Bool
    
    let startTime = CFAbsoluteTimeGetCurrent()
    @State var elapsed = CFAbsoluteTimeGetCurrent() - CFAbsoluteTimeGetCurrent()
    
    private func wave(path: Path) -> Path {
        var path = path
        let viewBoundsHeight: CGFloat = UIScreen.main.bounds.width
        let centerY = viewBoundsHeight / 2
        let amplitude = CGFloat(3) - abs(fmod(CGFloat(elapsed), 3) - 1.5) * 2
        
        func f(_ x: Int) -> CGFloat {
            return sin(((CGFloat(Float(x) * offset) / viewBoundsHeight) + CGFloat(Float(elapsed))) * 4 * .pi) * amplitude + centerY
        }
        
        path.move(to: CGPoint(x: 0, y: f(0)))
        for x in stride(from: 0, to: Int(viewBoundsHeight + 9), by: 5) {
            path.addLine(to: CGPoint(x: CGFloat(x), y: f(x)))
        }
        
        return path
    }
    
    var body: some View {
        return Path { path in
            path = wave(path: path)
        }
        .stroke(color, lineWidth: 2.5)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { _ in
                if recording {
                    self.elapsed = CFAbsoluteTimeGetCurrent() - self.startTime
                } else {
                    self.elapsed = CFAbsoluteTimeGetCurrent() - (self.startTime / 10)
                }
            }
        }
    }
}

struct Wave_Previews: PreviewProvider {
    static var previews: some View {
        Wave(color: Color.DARK_BLUE, offset: 1, recording: .constant(true))
    }
}
