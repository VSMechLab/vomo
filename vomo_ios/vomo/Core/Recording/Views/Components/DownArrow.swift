//
//  DownArrow.swift
//  VoMo
//
//  Created by Neil McGrogan on 8/25/22.
//

import Foundation
import SwiftUI

struct DownArrow: View {
    let arrow_img = "VM_Dropdown-Btn"
    
    var body: some View {
        Image(arrow_img)
            .resizable()
            .frame(width: 20, height: 10)
    }
}
