//
//  DetailListCell.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 21/10/2023.
//

import SwiftUI

struct DetailListCell: View {
    
    let detailTitle: String
    let text: String
    
    
    var body: some View {
        VStack {
            Divider()
            HStack {
                Text(detailTitle)
                    .foregroundColor(.gray)
                Spacer()
                Text(text)
            }
        }
    }
}


#Preview {
    DetailListCell(detailTitle: "CEO", text: "Elon Musk")
}
