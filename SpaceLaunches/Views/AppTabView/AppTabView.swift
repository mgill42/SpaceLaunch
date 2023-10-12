//
//  AppTabView.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 12/08/2023.
//

import SwiftUI

struct AppTabView: View {
    var body: some View {
        TabView {
            
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }
            
            LaunchView()
                .tabItem { Label("Launches", systemImage: "flame") }
            
            EventsView()
                .tabItem { Label("Events", systemImage: "calendar") }
            
            Text("Settings")
                .tabItem { Label("Settings", systemImage: "gearshape") }

        }
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
