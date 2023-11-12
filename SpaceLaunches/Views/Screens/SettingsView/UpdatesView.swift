//
//  UpdatesView.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 28/10/2023.
//

import SwiftUI

struct UpdatesView: View {
    var body: some View {
        List {
            UpdatesSectionView(updateType: .releaseNote, mainText: "Launch View has released to the App Store!", updateNumber: "1.0")

        }
    }
}




#Preview {
    UpdatesView()
}

struct UpdatesSectionView: View {
    
    enum UpdateType: String {
        case releaseNote = "Release Notes"
        case bugFix = "Bug Fixes"
        case newFeature = "New Feature"
    }
    
    let updateType: UpdateType
    let mainText: String
    let updateNumber: String
    
    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text(updateType.rawValue)
                    .bold()
                Text(mainText)
                
            }
        } header: {
            Text(updateNumber)
                .font(.headline)
                .bold()
        }
        .listRowSeparator(.hidden)
        .toolbar(.hidden)
    }
}
