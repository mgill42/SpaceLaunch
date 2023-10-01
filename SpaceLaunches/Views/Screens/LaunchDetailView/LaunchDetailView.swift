//
//  LaunchDetailView.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 01/10/2023.
//

import SwiftUI
import Kingfisher

struct LaunchDetailView: View {
    
    let launch: Launch
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                KFImage(URL(string: launch.image ?? ""))
                    .resizable()
                    .scaledToFill()
                    .frame(height: 500)
                    .overlay(alignment: .bottom) {
                        
                        CountdownTimerView(launchTime: launch.net)
                            .frame(alignment: .center)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.ultraThinMaterial)

                            }
                            .padding()
                    }
                
                
            }
                
                Divider()
                    .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    Text(launch.name)
                        .font(.title)
                        .bold()
                    Text(launch.launchServiceProvider.name)
                        .font(.title2)
          
                }
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .padding(.horizontal)
          


                
          
                
            
        }
        .ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LaunchDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LaunchDetailView(launch: Launch.example())
        }
    }
}
