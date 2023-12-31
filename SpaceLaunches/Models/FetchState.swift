//
//  FetchState.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 20/09/2023.
//

import Foundation

enum FetchState: Comparable {
    case good
    case isEmpty
    case isLoading
    case loadedAll
    case error
}
