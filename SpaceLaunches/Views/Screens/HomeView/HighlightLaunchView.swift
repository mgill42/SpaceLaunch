//
//  HighlightLaunchView.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 25/09/2023.
//

import SwiftUI
import Kingfisher

struct HighlightLaunchView: View {
    
    let launch: Launch
        
    var body: some View {
        NavigationLink(destination: LaunchDetailView(launch: launch)) {
            if let imageURL = launch.image {
                
                KFImage(URL(string: imageURL))
                    .placeholder {
                        ProgressView()
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 330, height: 500)
                    .overlay(alignment: .top) {
                        CardOverlay(launch: launch)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 30))
            } else {
                Image("rocketPlaceholder")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 330, height: 500)
                    .overlay(alignment: .top) {
                        CardOverlay(launch: launch)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 30))
            }
        }
    }
}

struct HighlightLaunchView_Previews: PreviewProvider {
    static var previews: some View {
        HighlightLaunchView(launch: Launch.example())
    }
}


struct CardOverlay: View {
    
    let launch: Launch
    
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .top, endPoint: .bottom)
                    .opacity(0.8)
                VStack(alignment: .leading, spacing: 7) {
                    Text(launch.name)
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.leading)
                    Text(launch.launchServiceProvider.name)
                        .multilineTextAlignment(.leading)
                    
                    Group {
                        Text(launch.net.formattedDate(dateStyle: .medium, timeStyle: .none))
                        Text(launch.net.formattedDate(dateStyle: .none, timeStyle: .short))
                    }
                    .font(.footnote)
                    
                }
                .foregroundColor(.white)
                .padding()
            }
            .frame(height: 200)
            Spacer()
            CountdownTimerView(launchTime: launch.net)
        }
    }
}
