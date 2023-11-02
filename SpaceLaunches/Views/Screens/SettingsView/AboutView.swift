//
//  AboutView.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 26/10/2023.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        List {
            HStack {
                Spacer()
                VStack {
                    Image("Icon")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .frame(height: 200)
                        .padding(.bottom)
                    
                    Text("Launch View")
                        .bold()
                    Text("by Mahaveer Gill")
                    
                }
                Spacer()
            }
            .listRowBackground(Color.clear)
                
            Section("API") {
                if let url = URL(string: "https://thespacedevs.com/llapi") {
                    Link(destination: url) {
                        HStack {
                            Text("Launch Library 2")
                            Spacer()
                            Image(systemName: "safari")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            
            Section("PRIVACY POLICY") {
                if let url = URL(string: "https://thespacedevs.com/llapi") {
                    Link(destination: url) {
                        HStack {
                            Text("Open in browser")
                            Spacer()
                            Image(systemName: "safari")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .navigationTitle("About")
        .foregroundColor(.primary)
    }
}

#Preview {
    AboutView()
}
