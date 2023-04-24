//
//  EntryField.swift
//  VoMo
//
//  Created by Neil McGrogan on 8/10/22.
//

import SwiftUI

struct EntryField: View {
    let entry_img = "VM_12-entry-field"
    let toggleHeight: CGFloat = 37 * 0.95
    var body: some View {
        Image(entry_img)
            .resizable()
            .frame(height: toggleHeight)
            .cornerRadius(5)
    }
}
