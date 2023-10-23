//
//  SettingsView.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 23/10/2023.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    Label("About", systemImage: "info.circle")
                    Label("What's New", systemImage: "star")
                }
                
                Section {
                    Label("Notifications", systemImage: "square.stack")
                    Label("Preferences", systemImage: "list.bullet")
                    
                }
                
                Section {
                    Label("Leave a Review", systemImage: "heart.fill")
                    Label("Request a Feature", systemImage: "bubble.right.fill")
                    Label("Report a Problem", systemImage: "exclamationmark.triangle")
                }
            }
            .padding(.top)
            .navigationTitle("Settings")
            .bold()
        }
    }
}

#Preview {
    SettingsView()
}
