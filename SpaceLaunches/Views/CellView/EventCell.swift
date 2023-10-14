//
//  EventCell.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 12/10/2023.
//

import SwiftUI
import Kingfisher

struct EventCell: View {
    
    let event: Event
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            if let imageUrl = event.featureImage {
                KFImage(URL(string: imageUrl))
                    .placeholder {
                        ProgressView()
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(height: 150)
                    .clipped()
            }
            Text(event.name)
                .font(.headline)
                .bold()
                .minimumScaleFactor(0.7)
                .lineLimit(2)
                .padding(.horizontal, 7)
            if let description = event.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 7)
            }
              
            Divider()
            
            Text(event.date?.timeAgoDisplay() ?? "")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.bottom, 8)
                .padding(.horizontal, 8)

        }
        .background {
            Color(uiColor: .secondarySystemFill)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    HStack(spacing: 20) {
        EventCell(event: Event.example())
    }
    .padding()
}
