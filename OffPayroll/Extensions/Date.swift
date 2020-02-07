//
//  Date.swift
//  OffPayroll
//
//  Created by Jon Preece on 04/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import Foundation

extension Date {
    static func FromISOString(dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: dateString)!
    }
    
    static func ToFormattedDateString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: date)
    }
}
