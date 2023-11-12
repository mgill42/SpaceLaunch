//
//  String+Ext.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 26/09/2023.
//

import Foundation
extension String {
    func formattedDate(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let dateFormatterGetter = DateFormatter()
        dateFormatterGetter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatterGetter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = dateFormatterGetter.date(from: self) else {
            return "Could not convert to date"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        return dateFormatter.string(from: date)
    }
    
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return dateFormatter.date(from: self)
    }
    
    func timeAgoDisplay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        if let date = dateFormatter.date(from: self) {
            
            let relativeDateTimeFormatter = RelativeDateTimeFormatter()
            relativeDateTimeFormatter.unitsStyle = .full
            
            return relativeDateTimeFormatter.localizedString(for: date, relativeTo: Date())
        } else {
            return "Error"
        }
    }
}
