//
//  LaunchCell.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 23/09/2023.
//

import SwiftUI
import Kingfisher

struct LaunchCell: View {
    
    let launch: Launch
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(launch.name)
                    .bold()
                    .font(.subheadline)
                
                Text(launch.launchServiceProvider.name)
                    .font(.caption)
                    .padding(.bottom, 8)
                    .foregroundColor(.secondary)

                VStack(alignment: .leading, spacing: 5) {
                    Label(launch.status.name.uppercased(), systemImage: launch.status.id == 3 || launch.status.id == 1 ? "checkmark.circle" : "exclamationmark.triangle")
                        .foregroundColor(launch.status.id == 3 || launch.status.id == 1 ? .accentColor : .primary)
                    Label(launch.net.formattedDate(dateStyle: .medium, timeStyle: .short), systemImage: "clock")
                    if let pad = launch.pad {
                        if pad.location.countryCode != "" {
                            Label(pad.location.countryCode, systemImage: "location")
                        }
                    }
                }
                .font(.caption)
                .foregroundColor(.primary)
            }
            
            Spacer()
            
            if let imageUrl = launch.launchServiceProvider.logoUrl {
                KFImage(URL(string: imageUrl))
                    .placeholder {
                        ProgressView()
                    }
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .padding(5)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.white)
                    }
            } else {
                Image("Placeholder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .padding(5)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.white)
                    }
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color(uiColor: .secondarySystemBackground))
        }
    }
}

struct LaunchCell_Previews: PreviewProvider {
    static var previews: some View {
        LaunchCell(launch: Launch.example())
    }
}
