//
//  EventsLoadingView.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 14/10/2023.
//

import SwiftUI

struct EventsLoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .frame(maxWidth: .infinity)
            .id(UUID())
    }
}

#Preview {
    EventsLoadingView()
}
