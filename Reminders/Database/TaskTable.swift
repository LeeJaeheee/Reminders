//
//  TaskTable.swift
//  Reminders
//
//  Created by 이재희 on 2/15/24.
//

import Foundation
import RealmSwift

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

class Folder: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var iconColor: String
    @Persisted var regDate: Date
    @Persisted var task: List<TaskTable>
    
    convenience init(title: String, iconColor: String = "blue") {
        self.init()
        self.title = title
        self.iconColor = iconColor
        self.regDate = Date()
    }
}

class TaskTable: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var memo: String?
    @Persisted var regDate: Date
    @Persisted var deadline: Date
    @Persisted var tag: String
    @Persisted var priority: Int
    @Persisted var isDone: Bool
    @Persisted var isFlagged: Bool
    @Persisted var taskDescription: String
    @Persisted(originProperty: "task") var parent: LinkingObjects<Folder>
    
    convenience init(title: String, memo: String? = nil, deadline: Date, tag: String, priority: Int) {
        self.init()
        self.title = title
        self.memo = memo
        self.regDate = Date()
        self.deadline = deadline
        self.tag = tag
        self.priority = priority
        self.isDone = false
        self.isFlagged = false
        self.taskDescription = "\(title)은 \(deadline)까지 완료되어야 하는 우선순위 \(Priority(rawValue: priority)!.title)인 업무입니다."
    }
}
