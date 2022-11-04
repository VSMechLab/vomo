//
//  Image.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/1/22.
//

import Foundation
import SwiftUI

extension Image {
    func tabImage() -> some View {
        self
            .resizable()
            .frame(width: 27.5, height: 27.5)
    }
    
    func thresholdImg() -> some View {
        self
            .resizable()
            .frame(width: 40, height: 40)
    }
}
