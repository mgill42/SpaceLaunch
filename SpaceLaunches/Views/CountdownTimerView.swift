//
//  CountdownTimerView.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 01/10/2023.
//

import SwiftUI

struct CountdownTimerView: View {
    
    @State private var countdown = ["","","",""]
    let launchTime: String

    var body: some View {
        HStack {
            VStack {
                Text(countdown[0])
                Text("DAY")
                    .font(.caption)
            }
            Rectangle()
                .frame(width: 1, height: 30)
                .opacity(0.3)
            VStack {
                Text(countdown[1])
                Text("HOUR")
                    .font(.caption)
            }
            Rectangle()
                .frame(width: 1, height: 30)
                .opacity(0.3)
            VStack {
                Text(countdown[2])
                Text("MIN")
                    .font(.caption)
            }
            Rectangle()
                .frame(width: 1, height: 30)
                .opacity(0.3)
            VStack {
                withAnimation {
                    Text(countdown[3])
                        .transition(.move(edge: .bottom))
                }
                Text("SEC")
                    .font(.caption)
            }
            Rectangle()
                .frame(width: 1, height: 30)
                .opacity(0.3)
        
    }
        .font(.title)
        .monospaced()
        .bold()
        .onAppear {
            countdown = getCountdown(launchTime: launchTime)
            let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                countdown = getCountdown(launchTime: launchTime)
            }
            RunLoop.current.add(timer, forMode: .common)
        }
    }
    
    func getCountdown(launchTime: String) -> [String] {
        // Current time
        let currentTime = Date()

        // Create a date formatter for the given format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        // Parse the target time string
        if let targetTime = dateFormatter.date(from: launchTime) {

            // Calculate the time difference
            let timeDifference = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: currentTime, to: targetTime)
            
            
            // Access the individual components of the time difference
            let days = String(format: "%02d", max(timeDifference.day ?? 0, 0))
            let hours = String(format: "%02d", max(timeDifference.hour ?? 0, 0))
            let minutes = String(format: "%02d", max(timeDifference.minute ?? 0, 0))
            let seconds = String(format: "%02d", max(timeDifference.second ?? 0, 0))
            
            return [days, hours, minutes, seconds]
        } else {
            return ["Failed to parse the target time string."]
        }
    }
}


struct CountdownTimerView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownTimerView(launchTime: Launch.example().net)
    }
}
