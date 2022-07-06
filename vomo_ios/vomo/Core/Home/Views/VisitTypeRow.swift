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
            // CHANGED: add date to VStack to hold date and time
            VStack(alignment: .leading) {
                // CHANGED: from .toStringDay()
                Text("\(visit.date.toString(dateFormat: "MM/dd/yyyy"))")
                // ADD: add font and size
                
                Text("\(visit.date.toString(dateFormat: "HH:mm"))")
                // ADD: add font and size
            }
            .padding(.trailing, 15)

            Text("\(visit.visitType)")
                // ADD: add font and size
            
            Spacer()
            
            // ADD: add dropdown button
            
            Button(action: {}) {
                Image(systemName: img)
                    .background(Color.white)
                    .cornerRadius(3)
            }
            
            Spacer()
        }
        .padding(.horizontal, 3)
        .foregroundColor(Color.gray)
        .cornerRadius(5)
        
    }
}
