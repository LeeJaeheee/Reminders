//
//  Priority.swift
//  Reminders
//
//  Created by 이재희 on 2/22/24.
//

import Foundation

enum Priority: Int, CaseIterable {
    case low
    case normal
    case high
    
    var title: String {
        switch self {
        case .low:
            "낮음"
        case .normal:
            "보통"
        case .high:
            "높음"
        }
    }
}
