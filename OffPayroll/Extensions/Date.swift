//
//  Date.swift
//  OffPayroll
//
//  Created by Jon Preece on 04/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import Foundation

extension Date {
    static func FromISOString(dateString: String, format: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: dateString)!
    }
    
    static func ToFormattedDateString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: date)
    }
    
    static func ToDateWithoutTime(date: Date) -> String {
        let formattedString = Date.ToFormattedDateString(date: date)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let parsedDate = formatter.date(from: formattedString)!
        
        return Date.ToFormattedDateString(date: parsedDate)
    }
    
    static func FromAbbreviatedString(date: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        return formatter.date(from: date)!
    }
    
}
