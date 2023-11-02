//
//  LaunchLoadingView.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 14/10/2023.
//

import SwiftUI

struct LaunchLoadingView: View {
    var body: some View {
        VStack(spacing: 10) {
            ProgressView()
                .progressViewStyle(.circular)
                .frame(maxWidth: .infinity)
                .id(UUID())
            Text("Fetching Launches...")
        }
    }
}

#Preview {
    LaunchLoadingView()
}
