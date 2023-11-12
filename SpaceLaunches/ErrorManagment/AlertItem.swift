//
//  AlertItem.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 12/11/2023.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext {
    
    static let networkError = AlertItem(title: Text("Server Error"), message: Text("Please check internet connection and try again"), dismissButton: .default(Text("Ok")))
    
}
