//
//  Array.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/18/22.
//

import Foundation

public extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter{ seen.insert($0).inserted }
    }
}
