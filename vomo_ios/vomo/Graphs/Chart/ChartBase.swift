//
//  ChartBase.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/6/22.
//

import SwiftUI

/// Protocol for any type of chart, to get access to underlying data
public protocol ChartBase {
    var chartData: ChartData { get }
}
