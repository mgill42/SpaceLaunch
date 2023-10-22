//
//  MissionDetailView.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 22/10/2023.
//

import SwiftUI
import Kingfisher

struct MissionDetailView: View {
    
    let mission: Mission
    let missionPatch: MissionPatch?
    
    var body: some View {
        ScrollView {
        
            if let missionPatch = missionPatch {
                if let url = URL(string: missionPatch.imageUrl) {
                    KFImage(url)
                        .placeholder {
                            ProgressView()
                        }
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .padding()
                       
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("About")
                    .font(.title)
                    .bold()
                Text(mission.description)
                    .foregroundColor(.gray)
                    .padding(.bottom)
                
                
                DetailListCell(detailTitle: "Type", text: mission.type)
                DetailListCell(detailTitle: "Orbit", text: mission.orbit.name)

            }
            .padding()
        }
        .navigationTitle(mission.name)
    }
}

#Preview {
    MissionDetailView(mission: Mission.missionExample(), missionPatch: MissionPatch.missionPatchExample())
}
