//
//  SortType.swift
//  Reminders
//
//  Created by 이재희 on 2/21/24.
//

import Foundation

// TODO: keyPath 공부해서 써보기
enum SortType {
    case title(ascending: Bool)
    case deadline(ascending: Bool)
    case priority(ascending: Bool)
    
    var sortParam: (keyPath: String, ascending: Bool) {
        switch self {
        case .title(let ascending):
            ("title", ascending)
        case .deadline(let ascending):
            ("deadline", ascending)
        case .priority(let ascending):
            ("priority", ascending)
        }
    }
}
