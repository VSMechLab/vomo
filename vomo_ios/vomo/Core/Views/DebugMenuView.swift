//
//  DebugMenuView.swift
//  VoMo
//
//  Created by Sam Burkhard on 5/29/23.
//

import SwiftUI

struct DebugMenuView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            
            List {
                
                Section {
                    
                    Button {
                        NotificationService.printScheduledNotifications()
                    } label: {
                        Text("Print scheduled notifications")
                    }
                    
                } header: {
                    Text("Notifications")
                }
            }
            
                .navigationTitle("Debug Menu")
                .navigationBarTitleDisplayMode(.inline)
            
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            self.dismiss()
                        } label: {
                            Text("Done")
                        }

                    }
                }
        }
    }
}

struct DebugMenuView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            
        }
        .sheet(isPresented: .constant(true)) {
            DebugMenuView()
        }
    }
}
