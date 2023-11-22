//
//  SettingsView.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 23/10/2023.
//

import SwiftUI
import StoreKit
import EmailComposer

struct SettingsView: View {
    
    @Environment(\.requestReview) private var requestReview
    @State var showEmailComposer = false
    
    let featureRequestEmailTemplate = EmailData(subject: "Feature Request", recipients: ["test@test.com"], body: "", isBodyHTML: true)
    let reportProblemEmailTemplate = EmailData(subject: "Report a Problem", recipients: ["test@test.com"], body: "", isBodyHTML: true)

    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: AboutView()) {
                        Label("About", systemImage: "info.circle")
                    }
                    NavigationLink(destination: UpdatesView()) {
                        Label("What's New", systemImage: "star")
                    }
                }
                
                Section {
                    
                    Button {
                        if let url = URL(string: UIApplication.openNotificationSettingsURLString) {
                            Task {
                                await UIApplication.shared.open(url)
                            }
                        }
                    } label: {
                        Label(
                            title: { Text("Notifications").foregroundColor(.white) },
                            icon: { Image(systemName: "square.stack") }
                        )
                    }
                }
                
                Section {
                    Button {
                        requestReview()
                    } label: {
                        Label(
                            title: { Text("Leave a Review").foregroundColor(.white) },
                            icon: { Image(systemName: "heart.fill") }
                        )
                    }
                    
                    Button {
                        showEmailComposer = true
                    } label: {
                        Label(
                            title: { Text("Request a Feature").foregroundColor(.white) },
                            icon: { Image(systemName: "bubble.right.fill") }
                        )
                    }
                    .emailComposer(isPresented: $showEmailComposer, emailData: featureRequestEmailTemplate)
                    
                    Button {
                        showEmailComposer = true
                    } label: {
                        Label(
                            title: { Text("Report a Problem").foregroundColor(.white) },
                            icon: { Image(systemName: "exclamationmark.triangle") }
                        )
                    }
                    .emailComposer(isPresented: $showEmailComposer, emailData: reportProblemEmailTemplate)
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
