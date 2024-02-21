//
//  DateFormatter+Extension.swift
//  Reminders
//
//  Created by 이재희 on 2/22/24.
//

import Foundation

extension DateFormatter {
    
    static private var sharedDateFormatter: DateFormatter = {
        print("sharedDateFormatter")
        let formatter = DateFormatter()
        formatter.dateFormat = "yy/MM/dd"
        return formatter
    }()
    
    static func displayString(from date: Date) -> String {
        return sharedDateFormatter.string(from: date)
    }
    
    static func displayDate(from string: String) -> Date? {
        return sharedDateFormatter.date(from: string)
    }
    
}
