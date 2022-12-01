//
//  AnyTransition.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/29/22.
//

import SwiftUI

extension AnyTransition {
    static var slideUp: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .bottom),
            removal: .opacity)}
    static var slideDown: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .top),
            removal: .opacity)}
}
//removal: .move(edge: .bottom))}
