//
//  ErrorPlaceholderView.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 12/11/2023.
//

import SwiftUI

struct ErrorPlaceholderView: View {
    var body: some View {
        VStack {
            Text("Oops!")
                .font(.title)
                .bold()
                .padding(.bottom)
            VStack(alignment: .center) {
                Text("Something went wrong")
                Text("Please try again later")
            }
            .foregroundColor(.secondary)
               
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 25.0)
                .foregroundColor(Color(uiColor: .secondarySystemBackground))
                .frame(width: 250, height: 200)

        }
    }
}

#Preview {
    ErrorPlaceholderView()
}
