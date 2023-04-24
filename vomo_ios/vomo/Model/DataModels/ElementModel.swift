//
//  ElementModel.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/29/22.
//

import SwiftUI

/// Types of entries viewable within progressview
struct Element: Hashable {
    var date: Date
    var preciseDate: [Date]
    var str: [String]
    var expandShowMore: Bool
}
