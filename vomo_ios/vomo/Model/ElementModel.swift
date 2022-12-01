//
//  ElementModel.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/29/22.
//

import SwiftUI

/// type of item served in ProgressView that represents an entry
struct Element: Hashable {
    var date: Date
    var preciseDate: [Date]
    var str: [String]
}
