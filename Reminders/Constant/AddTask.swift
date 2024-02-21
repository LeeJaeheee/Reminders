//
//  AddTask.swift
//  Reminders
//
//  Created by 이재희 on 2/22/24.
//

import Foundation

enum AddTask: Int, CaseIterable {
    case memo
    case deadline
    case tag
    case priority
    case image
    case folder
    
    var title: String {
        switch self {
        case .memo:
            "제목"
        case .deadline:
            "마감일"
        case .tag:
            "태그"
        case .priority:
            "우선 순위"
        case .image:
            "이미지 추가"
        case .folder:
            "목록"
        }
    }
    
    var notiName: String {
        switch self {
        case .memo:
            ""
        case .deadline:
            "DeadlineReceived"
        case .tag:
            "TagReceived"
        case .priority:
            "PriorityReceived"
        case .image:
            ""
        case .folder:
            ""
        }
    }
}
