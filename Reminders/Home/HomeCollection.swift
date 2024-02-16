//
//  HomeCollection.swift
//  Reminders
//
//  Created by 이재희 on 2/16/24.
//

import UIKit
import RealmSwift

enum HomeCollection: Int, CaseIterable {
    
    static let realm = try! Realm()
    
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
    
    //FIXME: 지우고 아래 database에서 쿼리로 다시하기
    var today: LazyFilterSequence<Results<TaskTable>> {
        HomeCollection.realm.objects(TaskTable.self).filter { Calendar.current.isDateInToday($0.deadline) }
    }
    
    var database: Results<TaskTable> {
        switch self {
        case .today:
            HomeCollection.realm.objects(TaskTable.self)
        case .scheduled:
            HomeCollection.realm.objects(TaskTable.self)
        case .all:
            HomeCollection.realm.objects(TaskTable.self)
        case .flagged:
            HomeCollection.realm.objects(TaskTable.self)
        case .completed:
            HomeCollection.realm.objects(TaskTable.self).where { $0.isDone }
        }
    }
}
