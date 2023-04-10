//
//  GraphComponents.swift
//  VoMo
//
//  Created by Neil McGrogan on 3/27/23.
//

import Foundation
import SwiftUI

struct DottedLine: View {
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                VStack(spacing: 0) {
                    ForEach(0..<30, id: \.self) { num in
                        HStack {
                            Spacer()
                            if num % 2 == 0 {
                                Color.white.frame(width: 2, height: geo.size.height / 30)
                            } else {
                                Color.clear.frame(width: 2, height: geo.size.height / 30)
                            }
                            Spacer()
                        }
                    }
                }
            }
            
            Color.clear.frame(height: 17)
        }
    }
}
