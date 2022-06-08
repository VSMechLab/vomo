//
//  VisitTypeRow.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/31/22.
//

import SwiftUI


struct VisitTypeRow: View {
    let visit: VisitModel
    let img: String
    
    var body: some View {
        HStack(spacing: 0) {
            Text("\(visit.date.toStringDay())")
            
            Spacer()
            
            Text("\(visit.visitType)")
            
            Button(action: {}) {
                Image(systemName: img)
                    .background(Color.white)
                    .cornerRadius(3)
            }
        }
        .padding(.horizontal, 3)
        .foregroundColor(Color.gray)
        .cornerRadius(5)
        
    }
}
