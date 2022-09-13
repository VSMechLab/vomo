//
//  InterventionView.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/2/22.
//

import SwiftUI

struct InterventionView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    var body: some View {
        VStack {
            Text("Intervention")
                .bold()
            Button("Home") {
                viewRouter.currentPage = .home
            }
        }
    }
}

struct InterventionView_Previews: PreviewProvider {
    static var previews: some View {
        InterventionView()
    }
}
