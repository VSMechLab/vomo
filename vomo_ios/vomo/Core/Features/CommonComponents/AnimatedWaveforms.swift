//
//  Waveform.swift
//  VoMo
//
//  Created by Sam Burkhard on 5/27/23.
//

import SwiftUI

fileprivate struct Waveform: Shape {
    
    var strength: Double
    var frequency: Double
    
    var phase: Double
    
    var animatableData: Double {
        get { phase }
        set { self.phase = newValue }
    }
        
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath()

        let width = Double(rect.width)
        let height = Double(rect.height)
        let midWidth = width / 2
        let midHeight = height / 2
        let oneOverMidWidth = 1 / midWidth

        let wavelength = width / frequency

        path.move(to: CGPoint(x: 0, y: midHeight))

        for x in stride(from: 0, through: width, by: 1) {
            let relativeX = x / wavelength
            let distanceFromMidWidth = x - midWidth
            let normalDistance = oneOverMidWidth * distanceFromMidWidth
            let parabola = -(normalDistance * normalDistance) + 1
            let sine = sin(relativeX + phase)
            let y = parabola * strength * sine + midHeight
            path.addLine(to: CGPoint(x: x, y: y))
        }
        return Path(path.cgPath)
    }
}

struct AnimatedWaveforms: View {
    
    @State var phase: Double = 0.0
    @State var speed: Double = 8.0
    
    var body: some View {
        ZStack {
            Waveform(strength: 27, frequency: 10, phase: phase)
                .stroke(Color(.sRGB, red: 0.52, green: 0.5, blue: 0.85), lineWidth: 4)
            
            Waveform(strength: 18, frequency: 15, phase: phase)
                .stroke(Color(.sRGB, red: 0.59, green: 0.99, blue: 0.9), lineWidth: 4)
            
            Waveform(strength: 9, frequency: 20, phase: phase)
                    .stroke(Color(.sRGB, red: 0.21, green: 0.36, blue: 0.73), lineWidth: 4)
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 20).repeatForever(autoreverses: false)) {
                self.phase = .pi * 2
            }
        }
    }
}

struct AnimatedWaveforms_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedWaveforms()
    }
}
