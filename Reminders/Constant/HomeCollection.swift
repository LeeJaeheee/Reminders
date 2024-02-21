//
//  HomeCollection.swift
//  Reminders
//
//  Created by 이재희 on 2/16/24.
//

import UIKit
import RealmSwift

enum HomeCollection: Int, CaseIterable {
    
    case today
    case scheduled
    case all
    case flagged
    case completed
    
    var title: String {
        switch self {
        case .today:
            "오늘"
        case .scheduled:
            "예정"
        case .all:
            "전체"
        case .flagged:
            "깃발 표시"
        case .completed:
            "완료"
        }
    }
    
    var configImage: (image: UIImage, backgroundColor: UIColor) {
        switch self {
        case .today:
            (UIImage(systemName: "calendar")!, .systemBlue)
        case .scheduled:
            (UIImage(systemName: "calendar")!, .systemRed)
        case .all:
            (UIImage(systemName: "tray.fill")!, .darkGray)
        case .flagged:
            (UIImage(systemName: "flag.fill")!, .systemOrange)
        case .completed:
            (UIImage(systemName: "checkmark")!, .lightGray)
        }
    }

}
